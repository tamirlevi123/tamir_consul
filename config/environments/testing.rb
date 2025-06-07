# Add immediate logging before Rails configuration
puts "=== STARTING TESTING ENVIRONMENT LOAD ==="
puts "Current Rails environment: #{ENV['RAILS_ENV']}"
puts "Current RACK environment: #{ENV['RACK_ENV']}"
puts "Loading from: #{__FILE__}"
puts "Rails root: #{Rails.root}" if defined?(Rails.root)

Rails.application.configure do
  # Debug logging to identify which file is being loaded
  puts "Loading testing.rb environment file"
  puts "File path: #{__FILE__}"

  # Log that testing environment is being loaded
  puts "Loading TESTING environment configuration"

  # Settings specified here will take precedence over those in config/application.rb.

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Eager loading loads your whole application. When running a single test locally,
  # this probably isn't necessary. It's a good idea to do in a continuous integration
  # environment, or in some way before deploying your code.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :local

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Turn false under Spring and add config.action_view.cache_template_loading = true.
  config.action_view.cache_template_loading = true

  # Log that testing environment configuration completed successfully
  puts "TESTING environment configuration loaded successfully"

  # Set default_url_options[:host] for the testing environment
  config.action_mailer.default_url_options = { host: '20.52.249.191' }
end

# Load custom environment configuration if it exists
custom_env_file = Rails.root.join('config', 'environments', 'custom', 'testing.rb')
puts "Attempting to load custom environment file from: #{custom_env_file}"
puts "File exists? #{File.exist?(custom_env_file)}"

begin
  require custom_env_file
  puts "Successfully loaded custom environment file"
rescue => e
  puts "Error loading custom environment file: #{e.message}"
  puts e.backtrace.join("\n")
end 