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
      separator: :auto
    }

    def format_row(row, opts = {})
      headers = row.headers.map do |h|
        h.downcase.gsub(/\./, '_')
      end

      values = row.headers.map do |h|
        "'#{row[h]}'"
      end

      "INSERT INTO #{opts[:table]}(#{headers.join(', ')}) VALUES(#{values.join(', ')});"
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
      }
    end

    def sanitize_header(header)
      header.map do |h|
        h.downcase
      end
    end

    def with_path(path, opts = {}, &block)
      csv_opts = merge_csv_options(opts)
      CSV.open(path, 'rt', csv_opts) do |csv|
        csv.each do |row|
          with_row(path, row, &block)
        end
      end
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
