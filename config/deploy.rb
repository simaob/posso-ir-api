# config valid for current version and patch releases of Capistrano
lock "~> 3.12.1"

set :application, "supermarket-api"
set :repo_url, "git@github.com:simaob/covid19_shopping_assistant.git"

set :default_env, {
    'PATH' => "/home/ubuntu/.rvm/gems/ruby-2.6.3/bin:/home/ubuntu/.rvm/bin:$PATH",
    'RUBY_VERSION' => 'ruby-2.4.6',
    'GEM_HOME' => '/home/ubuntu/.rvm/gems/ruby-2.6.3',
    'GEM_PATH' => '/home/ubuntu/.rvm/gems/ruby-2.6.3',
    'BUNDLE_PATH' => '/home/ubuntu/.rvm/gems/ruby-2.6.3'
}

set :passenger_restart_with_touch, true

set :rvm_type, :user
set :rvm_ruby_version, '2.6.3'
set :rvm_roles, [:app, :web, :db]


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, '.env'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
