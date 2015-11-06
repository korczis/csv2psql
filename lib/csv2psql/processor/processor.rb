# encoding: UTF-8

require 'csv'
require 'pathname'
require 'pp'

require_relative '../analyzer/analyzer'
require_relative '../cache/cache'
require_relative '../frontend/csv'
require_relative '../generator/generator'
require_relative '../helpers/config_helper'
require_relative '../helpers/csv_helper'
require_relative '../helpers/erb_helper'
require_relative '../output/output'
require_relative '../schema/schema_generator'
require_relative '../version'

module Csv2Psql
  # Csv2Psql processor class
  class Processor
    attr_reader :analyzer, :generator, :output, :path

    DEFAULT_OPTIONS = ConfigHelper.config['processor']

    def initialize
      @output = Output.new
      @generator = Generator.new(@output)
      @cache = Cache.new
      @analyzer = Analyzer.new(@cache)
      @frontend = Frontend::Csv.new
    end

    def analyze(paths, opts = {})
      with_files(paths, opts) do |data|
        analyzer.analyze(data[:path], data[:row], opts)
      end
      analyzer
    end

    def convert(paths, opts = {})
      details = {}
      with_files(paths, opts) do |data|
        create_converted_header(details, data, opts)
        output.write generator.format_row(data[:row], opts)
      end
    end

    def create_converted_header(details, data, opts = {})
      detail = get_file_details(details, data[:path])
      unless detail[:header] # rubocop:disable Style/GuardClause
        generator.create_sql_script(data[:path], data[:row], opts)
        detail[:header] = true
      end
    end

    def create_file_details(files, path)
      files[path] = {
        header: false,
        lines: 0,
        line: 0
      }
      files[path]
    end

    def generate_schema(paths, opts = {})
      res = {}
      paths.each do |path|
        with_file(path, opts) do |data|
          path = data[:path]
          analyzer.analyze(path, data[:row], opts)
        end

        analysis = analyzer.files[path]
        if analysis
          res[path] = SchemaGenerator.generate(analysis)
        end

      end
      res
    end

    def get_file_details(files, path)
      if files.key?(path)
        files[path]
      else
        create_file_details(files, path)
      end
    end

    def merge_csv_options(opts = {})
      header = !opts['header'].nil? ? opts['header'] : DEFAULT_OPTIONS['header']
      res = {
        headers: header,
        quote_char: opts['quote'] || DEFAULT_OPTIONS['quote']
      }
      res[:col_sep] = opts['delimiter'] if opts['delimiter']
      res[:col_sep] = opts[:delimiter] if opts[:delimiter]
      res[:row_sep] = opts['separator'] if opts['separator']
      res[:row_sep] = opts[:separator] if opts[:separator]
      res
    end

    def process_file(path, csv, opts, &block)
      lines = 0
      limit = opts[:l]
      skip = opts[:skip]
      csv.each do |row|
        lines += 1
        next if skip > 0 && lines <= skip

        with_row(path, row, opts, &block)

        return if limit > 0 && lines >= limit
      end
    end

    def with_file(path, opts = {}, &block)
      output.write 'BEGIN;' if opts[:transaction]
      csv_opts = merge_csv_options(opts)
      @first_row = true
      @frontend.open(path, 'rt', csv_opts) do |csv|
        process_file(path, csv, opts, &block)
      end
      output.write 'COMMIT;' if opts[:transaction]
    end

    def with_files(paths, opts = {}, &block)
      paths = [paths] unless paths.is_a?(Array)
      paths.each do |path|
        with_file(path, opts, &block)
      end
    end

    def with_row(path, row, _opts = {}, &_block)
      args = { path: path, row: row }
      Proc.new.call(args)
    end
  end
end
