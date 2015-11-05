# encoding: utf-8

require_relative '../../convert/convert'
require_relative '../../processor/processor'

desc 'Convert csv file'
command :convert do |c|
  c.desc 'Table to insert to'
  c.default_value Csv2Psql::Processor::DEFAULT_OPTIONS[:table]
  c.flag [:t, :table]

  c.desc 'Import in transaction block'
  c.default_value Csv2Psql::Processor::DEFAULT_OPTIONS[:transaction]
  c.switch [:transaction]

  c.desc 'Crate SQL Table before inserts'
  c.default_value Csv2Psql::Processor::DEFAULT_OPTIONS['create-table']
  c.switch ['create-table']

  c.desc 'Drop SQL Table before inserts'
  c.default_value Csv2Psql::Processor::DEFAULT_OPTIONS['drop-table']
  c.switch ['drop-table']

  c.desc 'Truncate SQL Table before inserts'
  c.default_value Csv2Psql::Processor::DEFAULT_OPTIONS['truncate-table']
  c.switch ['truncate-table']

  c.action do |global_options, options, args|
    help_now!('No file to convert specified!') if args.empty?

    opts = {}.merge(global_options).merge(options)
    Csv2Psql::Convert.convert(args, opts)
  end
end
