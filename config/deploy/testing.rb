set :stage, :testing
set :rails_env, :testing

# Set environment variables for Rails
env_path = File.expand_path('../../shared/.env', __dir__)
postgres_password = nil
if File.exist?(env_path)
  File.foreach(env_path) do |line|
    if line =~ /^POSTGRES_PASSWORD=(.*)/
      postgres_password = $1.strip
      break
    end
  end
end
set :default_env, fetch(:default_env, {}).merge(
  'POSTGRES_PASSWORD' => 'postgres',
  'RAILS_ENV' => 'testing',
  'RACK_ENV' => 'testing'
)
puts "[CAP DEBUG] Capistrano :default_env POSTGRES_PASSWORD=#{fetch(:default_env)['POSTGRES_PASSWORD'].inspect}, RAILS_ENV=#{fetch(:default_env)['RAILS_ENV'].inspect}, RACK_ENV=#{fetch(:default_env)['RACK_ENV'].inspect} at #{Time.now}"

server '20.52.249.191', user: 'azureuser', roles: %w{app db web}

set :deploy_to, '/home/azureuser/apps/consul231'

# Set the branch to deploy
set :branch, 'testing-deploy'

# Set the number of worker processes
set :puma_workers, 2

# Set the number of threads per worker
set :puma_threads, [4, 16]

# Set the port
set :puma_port, 3005

# Use the testing-specific secrets file
set :deploy_secrets_file, 'config/deploy/testing-secrets.yml'

# Add .env to linked files for testing environment
set :linked_files, fetch(:linked_files, []) + ['.env']

# RVM Configuration
set :rvm_type, :user
set :rvm_ruby_version, '3.0.6'
set :rvm_custom_path, '/home/azureuser/.rvm'

# SSH configuration
set :ssh_options, {
  forward_agent: true,
  auth_methods: %w(publickey),
  user: 'azureuser',
  keys: %w(/home/consul/.ssh/id_rsa_testing_new),
  port: 22,
  paranoid: false,
  config: false,
  user_known_hosts_file: '/dev/null'
}

# Skip RVM hook
Rake::Task['rvm1:hook'].clear_actions

# Testing environment specific settings
namespace :deploy do
  namespace :testing do
    desc 'Configure testing environment SSH settings'
    task :configure_ssh do
      # SSH configuration is now set globally above
    end

    desc 'Verify Rails environment'
    task :verify_env do
      on roles(:app) do
        within release_path do
          execute :echo, "=== Verifying Rails Environment ==="
          execute :echo, "RAILS_ENV: $RAILS_ENV"
          execute :echo, "RACK_ENV: $RACK_ENV"
          execute :bundle, "exec rails runner 'puts Rails.env'"
          execute :bundle, "exec rails runner 'puts Rails.root'"
          execute :bundle, "exec rails runner 'puts Rails.root.join(\"config/environments/testing.rb\")'"
          execute :bundle, "exec rails runner 'puts File.exist?(Rails.root.join(\"config/environments/testing.rb\"))'"
        end
      end
    end

    desc 'Debug environment variables before migration'
    task :debug_env do
      on roles(:app) do
        within release_path do
          execute :echo, '=== DEBUGGING ENVIRONMENT VARIABLES ==='
          execute %(printenv | grep POSTGRES_PASSWORD || echo 'POSTGRES_PASSWORD not set')
          execute :echo, '======================================'
        end
      end
    end

    desc 'Check .env presence and contents on server'
    task :check_env_file do
      on roles(:app) do
        within shared_path do
          execute :echo, '=== Checking for .env in shared directory ==='
          execute :ls, '-l .env || echo ".env not found"'
          execute :echo, '=== .env contents ==='
          execute :cat, '.env || echo ".env not found"'
          execute :echo, '====================='
        end
      end
    end
  end

  namespace :assets do
    desc 'Precompile assets'
    task :precompile do
      on roles(:app) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            # Create a temporary initializer to set eager_load
            execute :echo, 'Rails.application.config.eager_load = false' > 'config/initializers/eager_load.rb'
            execute :bundle, "exec rake assets:precompile"
          end
        end
      end
    end
  end

  desc "Restart application with Docker Compose"
  task :restart do
    on roles(:app) do
      within release_path do
        # Removed Docker Compose commands; not needed for Capistrano VM deployment
      end
    end
  end
end

# Add load_env to more deployment hooks
before 'deploy:starting', 'deploy:testing:configure_ssh'
before 'deploy:migrate', 'deploy:testing:verify_env'
before 'deploy:migrate', 'deploy:testing:debug_env'
before 'deploy:migrate', 'deploy:testing:check_env_file'

after 'deploy:publishing', 'deploy:restart'

set :deploy_via, :copy

# Remove set :scm, :copy and set :deploy_via, :copy to revert to default git strategy.

set :deploy_via, :copy
set :scm, :git
set :repo_url, 'git@github.com:tamirlevi123/tamir_consul.git'

# Remove Puma-specific settings/tasks for Docker deployment
# (Remove or comment out any set :puma_port, :puma_conf, and Puma hooks)

# namespace :puma do
#   desc 'Debug Puma environment before start/restart'
#   task :debug_env do
#     on roles(:app) do
#       within release_path do
#         execute :echo, '=== [PUMA DEBUG] Current working directory ==='
#         execute :pwd
#         execute :echo, '=== [PUMA DEBUG] Contents of config/puma ==='
#         execute :ls, '-l', "#{release_path}/config/puma/"
#         # Use Capistrano's logger to avoid shell issues with parentheses
#         info "[PUMA DEBUG] fetch(:puma_conf) = #{fetch(:puma_conf)}"
#       end
#     end
#   end
# end

# before 'puma:start', 'puma:debug_env'
# before 'puma:restart', 'puma:debug_env'

# set :puma_conf, "#{release_path}/config/puma/testing.rb" 