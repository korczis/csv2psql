# encoding: utf-8

require 'gli'
require 'json'
require 'pp'
require 'terminal-table'

include GLI::App

require_relative '../shared'
require_relative '../../convert/convert'
require_relative '../../processor/processor'

Csv2Psql::Cli.module_eval do
  desc 'Generate schema for file'
  command :schema do |c|
    c.action do |global_options, options, args|
      fail ArgumentError, 'No file to analyze specified' if args.empty?

      opts = {}.merge(global_options).merge(options)
      res = Csv2Psql::Convert.generate_schema(args, opts)

      puts JSON.pretty_generate(res)
    end
  end
end
