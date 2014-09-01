# encoding: UTF-8

require 'erb'
require 'pathname'

module Csv2Psql
  # CSV Helper
  class CsvHelper
    BASE_DIR = File.join(File.dirname(__FILE__), '..')

    class << self
      def get_header(row, opts = {})
        if opts[:header]
          row.headers
        else
          row.map.with_index { |_item, i| i }
        end
      end
    end
  end
end
