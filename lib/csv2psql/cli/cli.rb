# encoding: UTF-8

require 'gli'
require 'pp'

# Define Csv2Psql::Cli as GLI Wrapper
module Csv2Psql
  module Cli
    include GLI::App

    # Require shared part of GLI::App - flags, meta, etc
    require_relative 'shared.rb'

    # Require Hooks
    # require_relative 'hooks.rb'

    base = File.join(File.dirname(__FILE__), 'cmd')
    Dir[base + '/**/*.rb'].each do |f|
      require f
    end

    # GLI::App.commands_from(File.join(File.dirname(__FILE__), 'cmd'))

    def self.main(args = ARGV)
      run(args)
    end
  end
end

Csv2Psql::Cli.main(ARGV) if __FILE__ == $PROGRAM_NAME
