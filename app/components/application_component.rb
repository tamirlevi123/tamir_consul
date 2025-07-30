class ApplicationComponent < ViewComponent::Base
  include SettingsHelper
  include ActionView::Helpers::TranslationHelper

  def t(key = nil, **options)
    current_locale = options[:locale].presence || I18n.locale

    @i18n_content_translations ||= {}
    @i18n_content_translations[current_locale] ||= I18nContent.translations_hash(current_locale)

    # Handle pluralization by constructing the pluralized key
    lookup_key = key
    if options[:count].present?
      # Get the pluralization rule for the current locale
      pluralization_rule = I18n.t('i18n.plural.rule', locale: current_locale, default: ->(*args) { :other })
      
      # Determine the plural form based on count
      plural_form = case pluralization_rule
      when :one
        options[:count] == 1 ? :one : :other
      when :other
        :other
      else
        # For Hebrew, use the standard pluralization rules
        case options[:count]
        when 0
          :zero
        when 1
          :one
        else
          :other
        end
      end
      
      lookup_key = "#{key}.#{plural_form}"
    end

    translation = @i18n_content_translations[current_locale][lookup_key]

    if translation.present?
      translation % options
    else
      I18n.t(key, **options)
    end
  end

  use_helpers :back_link_to
  delegate :default_form_builder, to: :controller
end
