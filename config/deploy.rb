require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
load 'config/recipes/unicorn.rb'
load 'config/recipes/other.rb'

set :rvm_type, :user
set :rvm_ruby_string, '2.2.1'

set :bundle_bins, %w{rake gem ruby rails}
set :bundle_roles, %w{app}
set :bundle_servers, -> { release_roles(fetch(:bundle_roles)) }
set :bundle_path, -> { shared_path.join('bundle') }
set :bundle_without, %w{development test}.join(' ')
set :bundle_flags, '--deployment --quiet'
set :bundle_env_variables, {}

set :rails_env, 'production'
set :migration_role, 'web'
set :conditionally_migrate, true
set :assets_roles, [:web]
set :whenever_roles, [:web]
set :assets_prefix, 'assets'

set :assets_roles, %w{web}

set :application, 'gooddeal'
set :repo_url, 'git@github.com:gsapophis/cristmas.git'

set :ssh_options, { user: 'nostris' }
set :scm, :git

set :pty, true

set :forward_agent, true
set :deploy_via, :remote_cache

set :app_dir, "/srv/#{fetch(:application)}/"
set :deploy_to, "/srv/#{fetch(:application)}"
set :unicorn_config, "#{fetch(:deploy_to)}/current/config/unicorn.rb"
set :unicorn_pid, "#{fetch(:deploy_to)}/shared/pids/unicorn.pid"
set :use_sudo, false

SSHKit.config.command_map[:rake]  = "bundle exec rake"
SSHKit.config.command_map[:rails] = "bundle exec rails"
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/application.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('public/system')

#     # run "ln -nfs /srv/#{application}/shared/uploads/ #{release_path}/public/uploads/"
#     run "ln -nfs /srv/#{application}/shared/config/database.yml #{release_path}/config/database.yml"
#     run "ln -nfs /srv/#{application}/shared/config/secrets.yml #{release_path}/config/secrets.yml"
#     run "ln -nfs /srv/#{application}/shared/config/application.yml #{release_path}/config/application.yml"
#     run "ln -nfs /srv/#{application}/shared/config/.env #{release_path}/.env"
#     run "ln -nfs /srv/#{application}/shared/dumps/ #{release_path}"
namespace :deploy do
  after :updating, 'other:bundle'

  # before :finished, 'other:stop_sidekiq'
  # before :finished, 'other:stop_sunspot'

  after :finished, 'unicorn:reload'

  # after :finished, 'other:restart_sidekiq'
  # after :finished, 'other:start_sunspot'
  # after :finished, 'whenever:update_crontab'
end

