# encoding: utf-8

require 'gli'

include GLI::App

require_relative '../shared'
require_relative '../../convert/convert'

cmds = {
  h: {
    desc: 'Header row included',
    default_value: true
  },

  d: {
    desc: 'Column delimiter',
    type: String, default_value: ','
  },

  t: {
    desc: 'Table to insert to',
    type: String, default_value: 'my_table'
  },

  q: {
    desc: 'Quoting character',
    type: String, default_value: '"'
  },

  s: {
    desc: 'Line separator',
    type: String, default_value: :auto
  },

  transaction: {
    desc: 'Import in transaction block',
    type: String, default_value: true
  }
}

desc 'Convert csv file'
command :convert do |c|
  c.switch [:h, :header], cmds[:h]
  c.flag [:d, :delimiter], cmds[:d]
  c.flag [:t, :table], cmds[:t]
  c.flag [:q, :quote], cmds[:q]
  c.flag [:s, :separator], cmds[:s]
  c.switch [:transaction], cmds[:transaction]

  c.action do |global_options, options, args|
    fail ArgumentError, 'No file to convert specified' if args.empty?

    opts = {}.merge(global_options).merge(options)
    Csv2Psql::Convert.convert(args, opts)
  end
end

# default_command :convert
