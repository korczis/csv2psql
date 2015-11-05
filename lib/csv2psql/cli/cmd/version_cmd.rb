# encoding: utf-8

require_relative '../../version'

desc 'Print version info'
command :version do |c|
  c.action do |_global_options, _options, _args|
    puts Csv2Psql::VERSION
  end
end
