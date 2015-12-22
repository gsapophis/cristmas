# -*- encoding : utf-8 -*-
namespace :db do
  desc 'Start Unicorn'
  task :clean do
    on roles(:web), in: :parallel do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rake db:drop db:create db:migrate db:seed RAILS_ENV=production"
        end
      end
    end
  end
end
