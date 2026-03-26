ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.

begin
  require "bootsnap/setup" # Speed up boot time by caching expensive operations.
rescue LoadError
  # bootsnap is optional — not available when booted from the engine root Gemfile
end
