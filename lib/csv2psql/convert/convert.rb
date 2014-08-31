# encoding: UTF-8

require 'csv'
require 'multi_json'
require 'pathname'
require 'pp'

require_relative '../version'

module Csv2Psql
  # Csv2Psql convert module
  module Convert
    class << self
      def convert(paths, opts = {})
        paths = [paths] unless paths.is_a?(Array)
        paths.each do |path|
          puts "Converting #{path}"
        end
      end
    end
  end
end
