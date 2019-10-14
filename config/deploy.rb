# Change the 'YOUR_AZURE_VM_IP' to the publicIpAddress from the output of
# `az vm create` command executed above
server '168.61.17.14', roles: [:web, :app, :db], primary: true

# Change the YOUR_GITHUB_NAME to your github user name
set :repo_url,        'https://github.com/mdonagh/google-news-search.git'
set :application,     'google-news-search'
set :user,            'deploy'
set :puma_threads,    [4, 16]
set :puma_workers,    0
set :keep_releases, 1

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  # before :start, :make_dirs
end

namespace :deploy do
  desc "Start job queue."
  task :start_jobs do
    invoke 'delayed_job:start'
  end
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end


  task :symlink_secrets do
    on roles(:app) do
      execute "rm -rf #{release_path}/config/secrets.yml" 
      execute "ln -nfs ~/secrets.yml #{release_path}/config/secrets.yml"
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :symlink_secrets
  after  :finishing,    :compile_assets
  after  :finishing,    :start_jobs
  after  :finishing,    :cleanup
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma