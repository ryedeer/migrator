# These tasks are used to recreate the base droplet from a snapshot,
# deploy the release there, and create a new snapshot containing that release.
# Use `cap production snapshot:deploy` to do it.

namespace :release do
  desc "Deploy the release to the droplet"
  task :deploy do
    Rake::Task['release:upload'].invoke
    Rake::Task['release:cleanup'].invoke
    puts "Finished."
  end

  desc "Upload the release tarball to the droplet, extract it, and symlink it"
  task :upload do
    abort "ERROR: Cannot find the release (#{fetch(:build_archive)}).\nMake sure to build the release first (cap production build)." unless File.exist?(fetch(:build_archive))
    droplet_address = ENV['DROPLET_IP'] || fetch(:droplet_address)
    abort "ERROR: droplet_address isn't set; specify it in the config file or as \"DROPLET_IP=<ip_address> cap production release:upload\"" unless droplet_address
    puts "Uploading the release to the droplet..."

    host = SSHKit::Host.new(fetch(:deploy_user) + "@" + droplet_address)
    on host do |host|
      unless test("[ -d #{fetch(:deploy_to)} ]")
        puts "Creating the deploy directory..."
        execute :mkdir, fetch(:deploy_to)
      end

      puts "Uploading the release archive..."
      upload! fetch(:build_archive), fetch(:deploy_to)

      within fetch(:deploy_to) do
        unless test("[ -d #{fetch(:deploy_to)}/releases ]")
          puts "Creating the releases directory..."
          execute :mkdir, "releases"
        end

        puts "Creating the subdirectory for the current release..."
        timestamp = Time.now.to_i
        execute :mkdir, "releases/#{timestamp}"

        puts "Extracting the release archive..."
        execute :tar, "-xzf #{fetch(:application)}.tar.gz --directory releases/#{timestamp}"
        execute :rm, "#{fetch(:application)}.tar.gz"

        puts "Symlinking the release directory to #{fetch(:deploy_to)}/current..."
        if test("[ -e #{fetch(:deploy_to)}/current ]")
          execute :rm, "#{fetch(:deploy_to)}/current"
        end
        execute :ln, "-s releases/#{timestamp} current"

        puts "Uploading migrate.sh and rollback.sh..."
        upload! "deploy/resources/migrate.sh", fetch(:deploy_to)
        execute :chmod, "a+x #{fetch(:deploy_to)}/migrate.sh"
        upload! "deploy/resources/rollback.sh", fetch(:deploy_to)
        execute :chmod, "a+x #{fetch(:deploy_to)}/rollback.sh"
      end
    end
  end

  desc "Delete all releases except the few latest ones"
  task :cleanup do
    puts "Removing the old releases..."
    keep_count = fetch(:keep_releases) || 3

    droplet_address = ENV['DROPLET_IP'] || fetch(:droplet_address)
    host = SSHKit::Host.new(fetch(:deploy_user) + "@" + droplet_address)
    on host do |host|
      within fetch(:deploy_to) do
        unless test("[ -d #{fetch(:deploy_to)}/releases ]")
          abort "ERROR: nothing to clean up: releases directory does not exist."
        end

        releases = capture(:ls, "-xt releases").split
        if releases.count > fetch(:keep_releases)
          count = releases.count - fetch(:keep_releases)
          puts "Removing #{count} old release(s)..."
          within "releases" do
            execute :rm, "-rf", releases.last(count).join(" ")
          end
        else
          puts "No old releases to remove."
        end
      end
    end
  end

  desc "Delete the current release and revert to the previous one"
  task :rollback do
    puts "Rolling back the release..."

    droplet_address = ENV['DROPLET_IP'] || fetch(:droplet_address)
    host = SSHKit::Host.new(fetch(:deploy_user) + "@" + droplet_address)
    on host do |host|
      abort "ERROR: #{fetch(:deploy_to)} directory does not exist." unless test("[ -d #{fetch(:deploy_to)} ]")

      within fetch(:deploy_to) do
        abort "ERROR: #{fetch(:deploy_to)}/releases directory does not exist." unless test("[ -d #{fetch(:deploy_to)}/releases ]")

        releases = capture(:ls, "-xt releases").split
        abort "ERROR: no older release to roll back to." if releases.count < 2

        if test("[ -e #{fetch(:deploy_to)}/current ]")
          puts "Deleting the current release..."
          current_release = capture(:readlink, "current")
          execute :rm, "current"
          execute :rm, "-rf", current_release
        end        

        puts "Symlinking the previous release..."
        rollback_release = capture(:ls, "-xt releases").split.first
        execute :ln, "-s", "releases/#{rollback_release}", "current"
      end
    end
    puts "Finished."
  end
end
