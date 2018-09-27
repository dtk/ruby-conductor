require File.expand_path('../lib/nf-conductor/version', __FILE__)

Gem::Specification.new do |s|
  s.name	= 'nf-conductor'
  s.version	= Conductor::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary	= "an example of a project that can be deployed"
  s.description	= "Make something that can run in production"
  s.author	= "Joe Developer"
  s.email	= "github@example.com"
  s.homepage	= "http://github.com"
  s.files	=  Dir['README.md', 'VERSION', 'Gemfile', 'Rakefile', '{bin,lib,config,vendor}/**/*']
  s.require_path = 'lib'
  s.add_dependency 'concurrent-ruby', '~> 1.0'
  s.add_dependency 'faraday', '~> 0.13.1'
  s.add_dependency 'faraday_middleware',  '~> 0.12.2'
  s.add_dependency 'json', '~> 1.8'
  s.add_dependency 'pry', '~> 0.11'
end