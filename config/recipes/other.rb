# -*- encoding : utf-8 -*-
namespace :other do

  task :create_tmp_dir do
    on roles :all, in: :parallel do
      within release_path do
        execute :mkdir, '-pv', :tmp, "tmp/pids"
      end
    end
  end

  task :restart_sidekiq do
    on roles(:web), in: :parallel do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute "ps -ef | grep sidekiq | grep -v grep | awk '{print $2}' | xargs kill -9"
          execute :bundle, 'exec sidekiq -d -L log/sidekiq.log -C config/sidekiq.yml -e production'
          # execute 'crontab -e'
          execute 'crontab -r'
          execute :bundle, "exec whenever --update-crontab --set environment='production'"
          # execute :bundle, "exec unicorn -c #{fetch(:unicorn_config)} -D"
        end
      end
    end
  end

  task :restart_cron do
    on roles(:web), in: :parallel do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute 'crontab -r'
          execute :bundle, "exec whenever --update-crontab --set environment='production'"
        end
      end
    end
  end

  task :stop_sidekiq do
    on roles(:web), in: :parallel do
      within current_path do
        with rails_env: fetch(:rails_env) do
          begin
            execute "ps -ef | grep sidekiq | grep -v grep | awk '{print $2}' | xargs kill -9"
            # execute :bundle, "exec sidekiqctl stop $PIDFILE"
            # execute capture("sudo restart workers")
            # execute "rm /srv/app/shared/pids/sidekiq.pid"
            # execute "ps aux | grep sidekiq | grep -v grep | awk '{print $2}' "
            # execute :bundle, "exec sidekiqctl stop /srv/app/current/tmp/sidekiq.pid"
            # execute "ps aux | grep sidekiq | grep -v grep | awk '{print $2}' "
            execute :bundle, "exec sidekiqctl stop"
          rescue
            puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>> #{$!.message}"
          end
        end
      end
    end
  end

  task :stop_sunspot do
    on roles(:web), in: :parallel do
      within current_path do
        with rails_env: fetch(:rails_env) do
          begin
            execute "killall -v java; true"
            # execute :rake, "sunspot:solr:stop"
          rescue
            puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>> #{$!.message}"
          end
        end
      end
    end
  end

  task :start_sunspot do
    on roles(:web), in: :parallel do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "sunspot:solr:start RAILS_ENV=#{fetch(:rails_env)}"
          execute :rake, "sunspot:reindex RAILS_ENV=#{fetch(:rails_env)}"
        end
      end
    end
  end

  task :bundle do
    on roles :web, in: :parallel do
      within release_path do
        execute :bundle
      end
    end
  end
end
