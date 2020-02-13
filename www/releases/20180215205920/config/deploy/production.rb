server '18.220.75.162', user: 'deploy', roles: %w[app db puma_role], primary: true

set :stage, :production

set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || :master

set :deploy_to, '/home/deploy/www'
set :rvm_ruby_version, 'ruby-2.4.1@rideflag'
# set :linked_dirs, %w[docs/api] # not needed on production
set :linked_files, %w(config/puma.rb)

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
