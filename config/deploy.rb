require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm'    # for rvm support. (http://rvm.io)


set :domain, '10.18.3.107'
set :deploy_to, '/var/www/file-operator'
set :repository, 'https://github.com/Zhengquan/FileOperator'
set :branch, 'master'
set :rails_env,  'production'
set :forward_agent, true
set :term_mode, :system

set :app_path, '/var/www/file-operator/current'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['log']

# Optional settings:
set :user, 'devops'    # Username in the server to SSH to.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use[ruby-1.9.3-p194]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'

    to :launch do
      invoke :'unicorn:restart'
    end
  end
end

#                                                                       Unicorn
# ==============================================================================
namespace :unicorn do
  set :unicorn_pid, "#{app_path}/tmp/pids/unicorn.pid"
  set :start_unicorn, %{
    cd #{app_path} && bundle exec unicorn -c #{app_path}/config/unicorn.rb -E #{rails_env} -D
    }

    #                                                                    Start task
    # ------------------------------------------------------------------------------
    desc "Start unicorn"
    task :start => :environment do
      queue 'echo "-----> Start Unicorn"'
      queue! start_unicorn
    end

    #                                                                     Stop task
    # ------------------------------------------------------------------------------
    desc "Stop unicorn"
    task :stop do
      queue 'echo "-----> Stop Unicorn"'
      queue! %{
      test -s "#{unicorn_pid}" && kill -QUIT `cat "#{unicorn_pid}"` && echo "Stop Ok" && exit 0
      echo >&2 "Not running"
      }
    end

    #                                                                  Restart task
    # ------------------------------------------------------------------------------
    desc "Restart unicorn using 'upgrade'"
    task :restart => :environment do
      invoke 'unicorn:stop'
      invoke 'unicorn:start'
    end
end
