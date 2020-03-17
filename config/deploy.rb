# config valid for current version and patch releases of Capistrano
lock "~> 3.12.1"

set :application, "supermarket-api"
set :repo_url, "git@github.com:simaob/covid19_shopping_assistant.git"

#set :default_env, {
#    'PATH' => "/home/ubuntu/.rvm/gems/ruby-2.6.3/bin:/home/ubuntu/.rvm/bin:$PATH",
#    'RUBY_VERSION' => 'ruby-2.4.6',
#    'GEM_HOME' => '/home/ubuntu/.rvm/gems/ruby-2.6.3',
#    'GEM_PATH' => '/home/ubuntu/.rvm/gems/ruby-2.6.3',
#    'BUNDLE_PATH' => '/home/ubuntu/.rvm/gems/ruby-2.6.3'
#}

set :passenger_restart_with_touch, true

set :rvm_type, :user
set :rvm_ruby_version, '2.6.3'
set :rvm_roles, [:app, :web, :db]

append :linked_files, '.env'

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", 'db/files'

set :user, 'ubuntu'