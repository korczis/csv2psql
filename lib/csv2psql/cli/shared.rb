# encoding: UTF-8

require 'gli'

require_relative '../version'
require_relative '../processor/processor'

include GLI::App

program_desc "csv2psql #{Csv2Psql::VERSION} (Codename: #{Csv2Psql::CODENAME})"

cmds = {
  h: {
    desc: 'Header row included',
    default_value: Csv2Psql::Processor::DEFAULT_OPTIONS['header']
  },

  d: {
    desc: 'Column delimiter',
    type: String,
    default_value: Csv2Psql::Processor::DEFAULT_OPTIONS['delimiter']
  },

  l: {
    desc: 'How many rows process',
    type: Integer,
    default_value: -1
  },

  q: {
    desc: 'Quoting character',
    type: String,
    default_value: Csv2Psql::Processor::DEFAULT_OPTIONS['quote']
  },

  s: {
    desc: 'Line separator',
    type: String,
    default_value: Csv2Psql::Processor::DEFAULT_OPTIONS['separator']
  },

  'skip' => {
    desc: 'How many rows skip',
    type: Integer,
    default_value: -1
  }
}

switch [:h, :header], cmds[:h]
flag [:d, :delimiter], cmds[:d]
flag [:l, :limit], cmds[:l]
flag [:q, :quote], cmds[:q]
flag [:s, :separator], cmds[:s]
flag [:skip], cmds['skip']
