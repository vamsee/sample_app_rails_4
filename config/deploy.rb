set :application, 'railstut'
set :repo_url, 'git@github.com:vamsee/sample_app_rails_4.git'

set :branch, 'testbr'

set :deploy_to, '/home/vagrant/railstut'
set :scm, :git
set :deploy_via, :remote_cache

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "echo 'CREATING RELEASE **** #{release_timestamp} ****'"
      execute "ln -s /home/vagrant/railstut/current /vagrant/railstut/current"
      # execute "cd /vagrant/railstut && docker build -t release_#{release_timestamp} ."
      [10004, 10003, 10002, 10001].each do |port|
        test "(docker ps | grep web_#{port}) && docker stop web_#{port} && docker rm web_#{port}"
        # execute "docker run -d -p #{port}:9292 -name web_#{port} release_#{release_timestamp}"
        execute "docker run -d -p #{port}:9292 -name web_#{port} release_20140103031709"
      end
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
