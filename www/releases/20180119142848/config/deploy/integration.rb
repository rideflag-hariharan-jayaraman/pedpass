server '52.0.221.79', user: 'deploy', roles: %w[app db puma_role], primary: true

set :stage, :integration
set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || :develop

set :deploy_to, '/home/deploy/www'
set :rvm_ruby_version, 'ruby-2.4.1@pedestrian-web'
set :linked_dirs, %w[docs/api]
set :linked_files, %w[config/database.yml config/puma.rb config/secrets.yml.key]

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:puma_role), in: :sequence, wait: 5 do
      execute 'sudo restart puma-manager'
    end
  end

  after  :finishing, :cleanup
  after  :finishing, :restart
end
