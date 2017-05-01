# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'bridge_blueprint/version'

Gem::Specification.new do |gem|
  gem.authors =       ["Jay Shaffer"]
  gem.email =         ["jshaffer@instructure.com"]
  gem.description =   %q{Tools for consuming bridge data dumps}
  gem.summary =       %q{Bridge Blueprint}
  gem.homepage =      "https://getbridge.com"
  gem.license = 'MIT'

  gem.files = `git ls-files`.split("\n")
  gem.files += Dir.glob("lib/**/*.rb")
  gem.files += Dir.glob("spec/**/*")
  gem.test_files    = Dir.glob("spec/**/*")
  gem.name          = "bridge_blueprint"
  gem.require_paths = ["lib"]
  gem.version       = BridgeBlueprint::VERSION

  gem.add_runtime_dependency 'bridge_api', '~> 0.0.12'
  gem.add_runtime_dependency 'open_uri_redirections', '~> 0.2.1'
  gem.add_runtime_dependency 'rubyzip', '~> 1.2.1'

  gem.add_development_dependency 'rake', '~> 0'
  gem.add_development_dependency 'bundler', '~> 1.0', '>= 1.0.0'
  gem.add_development_dependency 'rspec', '~> 2.6'
  gem.add_development_dependency 'webmock', '~>2.3.1'
  gem.add_development_dependency 'pry', '~> 0'
  gem.add_development_dependency 'tilt', '>= 1.3.4', '~> 1.3'
  gem.add_development_dependency 'sinatra', '~> 1.0'
  gem.add_development_dependency 'byebug', '~> 8.2.2'
end
