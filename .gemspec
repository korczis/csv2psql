# encoding: utf-8

require 'rubygems'

$:.push File.expand_path("../lib", __FILE__)

require 'csv2psql/version.rb'

Gem::Specification.new do |s|
  s.name = 'csv2psql'
  s.version = Csv2Psql::VERSION
  s.summary = 'Tool for converting CSV into SQL statements'
  s.description = 'CSV to SQL conversion tool with user friendly CLI'
  s.authors = [
    'Tomas Korcak'
  ]
  s.email = 'korczis@gmail.com'

  s.homepage = 'https://github.com/korczis/csv2psql'
  s.license = 'MIT'
  s.require_paths = ['lib']

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }

  s.add_dependency 'gli', '~> 2.13', '>= 2.13.2'
  s.add_dependency 'json_pure', '~> 1.8', '>= 1.8.3'
  s.add_dependency 'lru', '~> 0.1', '>= 0.1.0'
  s.add_dependency 'multi_json', '~> 1.11', '>= 1.11.2'
  s.add_dependency 'rake', '~> 10.4', '>= 10.4.2'
  s.add_dependency 'terminal-table', '~> 1.5', '>= 1.5.2'

  s.add_development_dependency 'codeclimate-test-reporter', '~> 0.4', '>= 0.4.8'
  s.add_development_dependency 'coveralls', '~> 0.8', '>= 0.8.3'
  s.add_development_dependency "redcarpet", "~> 3.1.1" if RUBY_PLATFORM != 'java'
  s.add_development_dependency 'rspec', '~> 3.3', '>= 3.3.0'
  s.add_development_dependency 'rubocop', '~> 0.34', '>= 0.34.2'
  s.add_development_dependency 'simplecov', '~> 0.10', '>= 0.10.0'
  s.add_development_dependency 'yard', '~> 0.8.7.6'
end