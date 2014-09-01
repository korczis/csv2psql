# encoding: utf-8

require 'gli'
require 'pp'
require 'terminal-table'

include GLI::App

require_relative '../shared'
require_relative '../../convert/convert'
require_relative '../../processor/processor'

desc 'Analyze csv file'
command :analyze do |c|
  c.action do |global_options, options, args|
    fail ArgumentError, 'No file to analyze specified' if args.empty?

    opts = {}.merge(global_options).merge(options)
    res = Csv2Psql::Convert.analyze(args, opts)

    res.files.each do |_file, details|
      header = ['column'] + res.analyzers.map { |a| a[:name] }

      rows = details[:columns].map do |k, v|
        [k] + v.keys.map { |name| v[name].count }
      end

      table = Terminal::Table.new headings: header, rows: rows
      puts table
    end
  end
end
