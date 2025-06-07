Rails.application.configure do
  # Debug logging to identify which file is being loaded
  puts "Loading CUSTOM testing.rb environment file"
  puts "File path: #{__FILE__}"

  # Log that testing environment is being loaded
  puts "Loading CUSTOM TESTING environment configuration"

  # Explicitly set eager_load for testing environment
  config.eager_load = false

  # Add your custom testing environment configurations here
  # These will override the settings in the main testing.rb file

  # Example custom configurations:
  # config.action_mailer.default_url_options = { host: 'testing.example.com' }
  # config.force_ssl = false
  # config.log_level = :debug

  # Log that custom testing environment configuration completed successfully
  puts "CUSTOM TESTING environment configuration loaded successfully"
end 