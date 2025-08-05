class RemoteTranslations::Microsoft::Client
  include RemoteTranslations::Microsoft::SentencesParser
  CHARACTERS_LIMIT_PER_REQUEST = 5000
  PREVENTING_TRANSLATION_KEY = "notranslate".freeze
  API_ENDPOINT = "https://api.cognitive.microsofttranslator.com/translate".freeze

  def call(fields_values, locale)
    texts = prepare_texts(fields_values)
    valid_locale = RemoteTranslations::Microsoft::AvailableLocales.app_locale_to_remote_locale(locale)
    request_translation(texts, valid_locale)
  end

  def fragments_for(text)
    return [text] if text.size <= CHARACTERS_LIMIT_PER_REQUEST

    split_position = detect_split_position(text)
    start_text = text[0..split_position]
    end_text = text[split_position + 1..text.size]

    fragments_for(start_text) + [end_text]
  end

  private

    def request_translation(texts, locale)
      response = []
      split_response = false

      if characters_count(texts) <= CHARACTERS_LIMIT_PER_REQUEST
        response = translate_texts(texts, locale)
      else
        texts.each do |text|
          response << translate_text(text, locale)
        end
        split_response = true
      end

      parse_response(response, split_response)
    end

    def translate_text(text, locale)
      fragments_for(text).map do |fragment|
        translate_texts([fragment], locale)
      end.flatten
    end

    def translate_texts(texts, locale)
      uri = URI(API_ENDPOINT)
      uri.query = URI.encode_www_form({
        'api-version' => '3.0',
        'to' => locale
      })

      request = Net::HTTP::Post.new(uri)
      request['Ocp-Apim-Subscription-Key'] = Tenant.current_secrets.microsoft_api_key
      request['Ocp-Apim-Subscription-Region'] = 'westeurope'  # Add region header
      request['Content-Type'] = 'application/json'
      request['X-ClientTraceId'] = SecureRandom.uuid

      # Format texts for Azure Translator API
      body = texts.map { |text| { 'text' => text } }.to_json
      request.body = body

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      response = http.request(request)

      if response.code == '200'
        parse_azure_response(response.body)
      else
        raise "Translation failed: #{response.code} - #{response.body}"
      end
    end

    def parse_azure_response(response_body)
      json_response = JSON.parse(response_body)
      json_response.map { |item| item['translations'].first['text'] }
    rescue JSON::ParserError => e
      raise "Failed to parse Azure response: #{e.message}"
    end

    def parse_response(response, split_response)
      response.map do |translation|
        if split_response
          build_translation(translation)
        else
          get_field_value(translation)
        end
      end
    end

    def build_translation(translations)
      translations.map { |translation| get_field_value(translation) }.join
    end

    def get_field_value(translation)
      notranslate?(translation) ? nil : translation
    end

    def prepare_texts(texts)
      texts.map { |text| text || PREVENTING_TRANSLATION_KEY }
      #https://docs.microsoft.com/es-es/azure/cognitive-services/translator/prevent-translation
    end

    def notranslate?(text)
      text.downcase == PREVENTING_TRANSLATION_KEY
    end
end
