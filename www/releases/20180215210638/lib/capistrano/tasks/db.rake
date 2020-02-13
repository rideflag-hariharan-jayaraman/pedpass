namespace :db do
  desc 'Runs rails db:seed'
  task :seed do
    raise 'not allowed' if fetch(:stage).eql?(:production)
    on primary :db do
      within release_path do
        with rails_env: fetch(:stage) do
          execute :rails, 'db:seed'
        end
      end
    end
  end

  desc 'Runs rails db:reset'
  task :reset do
    raise 'not allowed' if fetch(:stage).eql?(:production)
    on primary :db do
      within release_path do
        with rails_env: fetch(:stage) do
          execute :rails, 'db:reset'
        end
      end
    end
  end

  desc 'Runs rails db:drop db:create'
  task :recreate do
    raise 'not allowed' if fetch(:stage).eql?(:production)
    on primary :db do
      within release_path do
        with rails_env: fetch(:stage) do
          execute :rails, 'db:drop db:create'
        end
      end
    end
  end
end
