# encoding: utf-8

require 'gli'
require 'pathname'
require 'pp'

require_relative 'shared'
require_relative '../version'

require_relative '../processor/processor'

def launch(argv = ARGV)
  run(argv)
end

include GLI::App

program_desc "csv2psql #{Csv2Psql::VERSION} (Codename: #{Csv2Psql::CODENAME})"

cmds = {
  h: {
    desc: 'Header row included',
    default_value: Csv2Psql::Processor::DEFAULT_OPTIONS[:header]
  },

  d: {
    desc: 'Column delimiter',
    type: String,
    default_value: Csv2Psql::Processor::DEFAULT_OPTIONS[:delimiter]
  },

  l: {
    desc: 'How many rows process',
    type: Integer,
    default_value: -1
  },

  q: {
    desc: 'Quoting character',
    type: String,
    default_value: Csv2Psql::Processor::DEFAULT_OPTIONS[:quote]
  },

  s: {
    desc: 'Line separator',
    type: String,
    default_value: Csv2Psql::Processor::DEFAULT_OPTIONS[:separator]
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

module Csv2Psql
  # Apollon CLI
  module Cli
    # CLI Application
    class App
      extend Csv2Psql::Cli::Shared

      cmds = File.absolute_path(File.join(File.dirname(__FILE__), 'cmd'))
      Dir.glob(cmds + '/*.rb').each do |file|
        require file
      end

      def main(argv = ARGV)
        launch(argv)
      end
    end
  end
end

launch if __FILE__ == $PROGRAM_NAME
