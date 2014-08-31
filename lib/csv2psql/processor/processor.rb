# encoding: UTF-8

require 'csv'
require 'multi_json'
require 'pathname'
require 'pp'

require_relative '../version'

module Csv2Psql
  # Csv2Psql processor class
  class Processor
    attr_reader :path

    DEFAULT_OPTIONS = {
      delimiter: ',',
      header: true,
      separator: :auto,
      quote: '"'
    }

    def format_row(row, opts = {})
      if opts[:header]
        headers = row.headers.map do |h|
          h.downcase.gsub(/\./, '_')
        end
        h_str = headers.join(', ')
      else
        headers = row.map.with_index { |_item, i| i}
        h_str = headers.map do |h|
          "col_#{h}"
        end
      end

      values = headers.map do |h|
        "'#{row[h]}'"
      end

      v_str = values.join(', ')
      "INSERT INTO #{opts[:table]}(#{h_str}) VALUES(#{v_str});"
    end

    def convert(paths, opts = {})
      with_paths(paths, opts) do |data|
        puts format_row(data[:row], opts)
      end
    end

    def merge_csv_options(opts = {})
      header = !opts[:header].nil? ? opts[:header] : DEFAULT_OPTIONS[:header]
      {
        col_sep: opts[:delimiter] || DEFAULT_OPTIONS[:delimiter],
        headers: header,
        row_sep: opts[:separator] || DEFAULT_OPTIONS[:separator],
        quote_char: opts[:quote] || DEFAULT_OPTIONS[:quote]
      }
    end

    def sanitize_header(header)
      header.map do |h|
        h.downcase
      end
    end

    def with_path(path, opts = {}, &block)
      puts "BEGIN;" if opts[:transaction]
      csv_opts = merge_csv_options(opts)
      CSV.open(path, 'rt', csv_opts) do |csv|
        csv.each do |row|
          with_row(path, row, &block)
        end
      end
      puts "COMMIT;" if opts[:transaction]
    end

    def with_paths(paths, opts = {}, &block)
      paths = [paths] unless paths.is_a?(Array)
      paths.each do |path|
        with_path(path, opts, &block)
      end
    end

    def with_row(path, row, &block)
      args = {
        path: path,
        row: row
      }
      block.call(args) if block_given?
    end
  end
end
