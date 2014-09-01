# encoding: UTF-8

require 'csv'
require 'multi_json'
require 'pathname'
require 'pp'

require_relative '../analyzer/analyzer'
require_relative '../generator/generator'
require_relative '../helpers/csv_helper'
require_relative '../helpers/erb_helper'
require_relative '../output/output'
require_relative '../version'

module Csv2Psql
  # Csv2Psql processor class
  class Processor
    attr_reader :analyzer, :generator, :output, :path

    DEFAULT_OPTIONS = {
      delimiter: ',',
      header: true,
      separator: :auto,
      transaction: false,
      quote: '"'
    }

    def initialize
      @output = Output.new
      @generator = Generator.new(@output)
      @analyzer = Analyzer.new
    end

    def analyze(paths, opts = {})
      with_paths(paths, opts) do |data|
        path = data[:path]
        row = data[:row]
        analyzer.analyze(path, row, opts)
      end
      analyzer
    end


    def convert(paths, opts = {})
      file_headers = {}

      with_paths(paths, opts) do |data|
        path = data[:path]
        row = data[:row]
        unless file_headers.key?(path)
          generator.create_sql_script(path, row, opts)
          file_headers[path] = true
        end

        output.write generator.format_row(row, opts)
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

    def with_path(path, opts = {}, &block)
      output.write 'BEGIN;' if opts[:transaction]
      csv_opts = merge_csv_options(opts)
      @first_row = true
      CSV.open(path, 'rt', csv_opts) do |csv|
        csv.each do |row|
          with_row(path, row, opts, &block)
        end
      end
      output.write 'COMMIT;' if opts[:transaction]
    end

    def with_paths(paths, opts = {}, &block)
      paths = [paths] unless paths.is_a?(Array)
      paths.each do |path|
        with_path(path, opts, &block)
      end
    end

    def with_row(path, row, _opts = {}, &block)
      args = { path: path, row: row }
      block.call(args) if block_given?
    end
  end
end
