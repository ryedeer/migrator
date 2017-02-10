desc "Build the release"
task :build do
  puts "Starting Vagrant VM..."
  sh 'vagrant up'
  puts "Building the release..."
  sh 'echo "cd /vagrant; mix local.hex --force && mix local.rebar --force && mix deps.get && MIX_ENV=prod mix release --env=prod" | vagrant ssh'
  puts "Suspending the Vagrant VM..."
  sh 'vagrant suspend'
  puts "Removing post-build artifacts..."
  sh 'rm -rf `find ./deps -name .rebar`'
  sh 'rm -rf `find ./deps -name .rebar3`'
  puts "Finished."
end
