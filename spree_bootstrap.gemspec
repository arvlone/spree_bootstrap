# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'spree_bootstrap/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_bootstrap'
  s.version     = SpreeBootstrap::VERSION
  s.summary     = 'Spree Frontend with Twitter Bootstrap'
  s.description = s.summary
  s.required_ruby_version = '>= 1.9.3'

  s.author       = 'Jeff Dutil'
  s.email        = 'jeff@burlingtonwebapps.com'
  s.homepage     = 'https://github.com/jdutil/spree_bootstrap'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_runtime_dependency 'bootstrap-sass', '~> 2.3.1.0'
  s.add_runtime_dependency 'font-awesome-rails'
  s.add_runtime_dependency 'spree_api'
  s.add_runtime_dependency 'spree_core', '~> 2.0.3'
  s.add_runtime_dependency 'spree_frontend'

  s.add_development_dependency 'capybara', '~> 2.1.0'
  s.add_development_dependency 'coffee-rails', '~> 3.2.2'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails', '~> 2.13'
  s.add_development_dependency 'sass-rails', '~> 3.2.6'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'shoulda-matchers', '~> 2.2'
  s.add_development_dependency 'elabs_matchers', '~> 0.0.6'
  s.add_development_dependency 'i18n-spec', '~> 0.4.0'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'fuubar', '>= 0.0.1'
  s.add_development_dependency 'simplecov', '~> 0.7.1'
  s.add_development_dependency 'sqlite3', '~> 1.3.7'
  s.add_development_dependency 'launchy'
end
