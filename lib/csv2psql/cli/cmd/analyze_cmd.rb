# encoding: utf-8

require 'gli'
require 'pp'

include GLI::App

require_relative '../shared'
require_relative '../../convert/convert'
require_relative '../../processor/processor'

cmds = {
}

desc 'Analyze csv file'
command :analyze do |c|
  c.action do |global_options, options, args|
    fail ArgumentError, 'No file to analyze specified' if args.empty?

    opts = {}.merge(global_options).merge(options)
    res = Csv2Psql::Convert.analyze(args, opts)
    pp res.files
  end
end
