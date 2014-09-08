# encoding: UTF-8

require 'csv'

require_relative 'base'

module Csv2Psql
  # Frontend parsers
  module Frontend
    # Csv frontend class
    class Csv < Base
      def open(path, open_opts = 'rt', csv_opts = {}, &block)
        CSV.open(path, open_opts, csv_opts) do |csv|
          Proc.new.call(csv)
        end
      end
    end
  end
end
