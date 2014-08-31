# encoding: UTF-8

require 'csv'
require 'multi_json'
require 'pathname'
require 'pp'

require_relative '../version'

module Csv2Psql
  # Csv2Psql convert module
  module Convert
    DEFAULT_OPTIONS = {
      delimiter: ',',
      header: true
    }

    class << self
      def format_row(row)
        headers = row.headers.map do |h|
          h.downcase.gsub(/\./, '_')
        end

        values = row.headers.map do |h|
          "'#{row[h]}'"
        end

        "INSERT INTO aaa(#{headers.join(', ')}) VALUES(#{values.join(', ')});"
      end

      def convert(paths, opts = {})
        paths = [paths] unless paths.is_a?(Array)
        paths.each do |path|
          puts "Converting #{path}"

          header = !opts[:header].nil? ? opts[:header] : DEFAULT_OPTIONS[:header]
          csv_opts = {
            col_sep: opts[:delimiter] || DEFAULT_OPTIONS[:delimiter],
            :headers => header
          }

          CSV.open(path, 'rt', csv_opts) do |csv|
            csv.each do |row|
              puts format_row(row)
            end
          end
        end
      end

      def sanitize_header(header)
        header.map do |h|
          h.downcase
        end
      end
    end
  end
end
