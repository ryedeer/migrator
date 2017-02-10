# default deploy_config_path is 'config/deploy.rb'
set :deploy_config_path, 'deploy/capistrano/deploy.rb'
# default stage_config_path is 'config/deploy'
set :stage_config_path, 'deploy/capistrano/stages'

# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Load the SCM plugin appropriate to your project:
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# DigitalOcean API v2 client
require "droplet_kit"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("deploy/capistrano/tasks/*.rake").each { |r| import r }

# Fix DropletKit incompatibility issue
Capistrano::DSL::Env.send(:remove_method, :delete)
