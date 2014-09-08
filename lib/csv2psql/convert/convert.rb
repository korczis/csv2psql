# encoding: UTF-8

require_relative '../version'
require_relative '../processor/processor'

module Csv2Psql
  # Csv2Psql convert module
  module Convert
    class << self
      def analyze(paths, opts = {})
        p = Processor.new
        p.analyze(paths, opts)
      end

      def convert(paths, opts = {})
        p = Processor.new
        p.convert(paths, opts)
      end

      def generate_schema(paths, opts = {})
        p = Processor.new
        p.generate_schema(paths, opts)
      end
    end
  end
end
