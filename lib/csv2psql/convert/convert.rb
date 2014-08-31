# encoding: UTF-8

require 'csv'
require 'multi_json'
require 'pathname'
require 'pp'

require_relative '../version'
require_relative '../processor/processor'

module Csv2Psql
  # Csv2Psql convert module
  module Convert
    class << self
      def convert(paths, opts = {})
        p = Processor.new
        p.convert(paths, opts)
      end
    end
  end
end
