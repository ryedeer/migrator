use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: :dev

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"MP&5n](Wg&;*%0f_912]HO0tmbCG6GW8<nE;o=VUR2fAf$,q{tDx3h|e4}1cfC&D"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"/Q]k$VaOVW9;Pz$OnbTou&uCO`kO8f:,prr_$|5cj;im=Db%?P_UiN3OKkQU7=M1"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :migrator do
  set version: current_version(:migrator)
end

