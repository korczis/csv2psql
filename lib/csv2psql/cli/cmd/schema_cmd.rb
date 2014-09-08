# encoding: utf-8

require 'gli'
require 'json'
require 'pp'
require 'terminal-table'

include GLI::App

require_relative '../shared'
require_relative '../../convert/convert'
require_relative '../../helpers/erb_helper'
require_relative '../../processor/processor'

Csv2Psql::Cli.module_eval do
  BASE_DIR = File.join(File.dirname(__FILE__), '..', '..', '..', '..')
  TEMPLATE_DIR = File.join(BASE_DIR, 'templates')
  SCHEMA_TEMPLATE = File.join(TEMPLATE_DIR, 'schema.sql.erb')

  formats = {
    'json' => lambda do |res|
      JSON.pretty_generate(res)
    end,

    'sql' => lambda do |data|
      res = ''
      data.each do |_k, v|
        v[:table] = 'my_table'
        ctx = v
        erb = Csv2Psql::ErbHelper.new
        res += "\n" unless res.empty?
        res += erb.process(SCHEMA_TEMPLATE, ctx)
      end
      res
    end,

    'table' => lambda do |res|
      res.map do |file, data|
        header = %w(column type null)

        rows = data[:columns].map do |k, v|
          [k, v[:type], v[:null]]
        end

        Terminal::Table.new title: file, headings: header, rows: rows
      end
    end
  }

  cmds = {
    f: {
      desc: 'Output format',
      type: String,
      default_value: formats.keys.first
    }
  }

  desc 'Generate schema for file'
  command :schema do |c|
    c.flag [:f, :format], cmds[:f]

    c.action do |global_options, options, args|
      fail ArgumentError, 'No file to analyze specified' if args.empty?

      opts = {}.merge(global_options).merge(options)

      formater = formats[opts[:format]]
      if formater.nil?
        fmters = formats.keys.join(', ')
        fail ArgumentError, "Wrong formatter specified, can be: #{fmters}"
      end

      res = Csv2Psql::Convert.generate_schema(args, opts)

      output = formater.call(res)
      if output.is_a?(Array)
        output.each do |o|
          puts o
        end
      else
        puts output
      end
    end
  end
end
