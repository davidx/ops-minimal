

default_run_options[:pty] = true
ssh_options[:user] = 'root'
ssh_options[:forward_agent] = true

set :dataroot, "/data/ops"
set :chefroot, "/data/ops/current/chef/repository"
set :repository, "git@github.com:davidx/ops-minimal.git"
set :timestamp, Time.now.strftime("%s")
set :release_path, "#{dataroot}/releases/#{timestamp}"


namespace :ops do
  task :deploy do
    cmd = "mkdir -p #{dataroot}/releases &&"
    cmd << "cd #{dataroot} && git clone #{repository} #{release_path} &&"
    cmd << "rm -f #{dataroot}/current && ln -sf #{release_path} #{dataroot}/current"
    run cmd
  end
end

namespace :chef do

  task :runsolo do
    update
    solo
  end
  task :solo do
    run "cd #{chefroot} && rake runsolo"
  end
  task :update do
    git_command = ENV['branch']  ? "git checkout #{ENV['branch']}" : "git pull"  
    run "cd #{chefroot} && #{git_command}"
  end
end