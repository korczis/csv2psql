# encoding: utf-8

require 'gli'

include GLI::App

require_relative '../shared'
require_relative '../../convert/convert'
require_relative '../../processor/processor'

cmds = {
  t: {
    desc: 'Table to insert to',
    type: String,
    default_value: Csv2Psql::Processor::DEFAULT_OPTIONS[:table]
  },

  transaction: {
    desc: 'Import in transaction block',
    default_value: Csv2Psql::Processor::DEFAULT_OPTIONS[:transaction]
  },

  'create-table' => {
    desc: 'Crate SQL Table before inserts',
    default_value: Csv2Psql::Processor::DEFAULT_OPTIONS['create-table']
  },

  'drop-table' => {
    desc: 'Drop SQL Table before inserts',
    default_value: Csv2Psql::Processor::DEFAULT_OPTIONS['drop-table']
  },

  'truncate-table' => {
    desc: 'Truncate SQL Table before inserts',
    default_value: Csv2Psql::Processor::DEFAULT_OPTIONS['truncate-table']
  }
}

desc 'Convert csv file'
command :convert do |c|
  c.flag [:t, :table], cmds[:t]
  c.switch [:transaction], cmds[:transaction]
  c.switch ['create-table'], cmds['create-table']
  c.switch ['drop-table'], cmds['drop-table']
  c.switch ['truncate-table'], cmds['truncate-table']

  c.action do |global_options, options, args|
    fail ArgumentError, 'No file to convert specified' if args.empty?

    opts = {}.merge(global_options).merge(options)
    Csv2Psql::Convert.convert(args, opts)
  end
end

# default_command :convert
