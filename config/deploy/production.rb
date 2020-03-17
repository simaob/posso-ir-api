server ENV['PRODUCTION_IP'],
       user: ENV['SSH_USER'],
       roles: %w{web app db}, primary: true

#server '54.194.113.84',
#       user: 'ubuntu',
#       roles: %w{web app db}, primary: true

set :ssh_options, {
    forward_agent: true,
    auth_methods: %w(publickey password),
    password: fetch(:password)
}

set :branch, 'master'
set :deploy_to, '~/supermarket-rails'

set :rails_env, :production