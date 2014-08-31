# encoding: UTF-8

require 'csv'
require 'multi_json'
require 'pathname'
require 'pp'

require_relative '../version'
require_relative '../helpers/erb_helper'

module Csv2Psql
  # Csv2Psql processor class
  class Processor # rubocop:disable Metrics/ClassLength
    attr_reader :path

    DEFAULT_OPTIONS = {
      'create-table' => false,
      'drop-table' => false,
      delimiter: ',',
      header: true,
      separator: :auto,
      table: 'my_table',
      transaction: true,
      quote: '"'
    }

    TABLE_FUNCTIONS = {
      'drop-table' => :drop_table,
      'create-table' => :create_table,
      'truncate-table' => :truncate_table
    }

    BASE_DIR = File.join(File.dirname(__FILE__), '..', '..', '..')
    TEMPLATE_DIR = File.join(BASE_DIR, 'templates')
    CREATE_TABLE_TEMPLATE = File.join(TEMPLATE_DIR, 'create_table.sql.erb')
    DROP_TABLE_TEMPLATE = File.join(TEMPLATE_DIR, 'drop_table.sql.erb')
    HEADER_TEMPLATE = File.join(TEMPLATE_DIR, 'header.sql.erb')
    TRUNCATE_TABLE_TEMPLATE = File.join(TEMPLATE_DIR, 'truncate_table.sql.erb')

    def convert(paths, opts = {})
      with_paths(paths, opts) do |data|
        puts format_row(data[:row], opts)
      end
    end

    def create_erb_context(path, row, opts = {})
      header = get_header(row, opts)
      columns = get_columns(row, opts, header)
      {
        path: path,
        header: header,
        columns: columns,
        table: opts[:table] || DEFAULT_OPTIONS[:table]
      }
    end

    def create_header(path, row, opts = {})
      ctx = create_erb_context(path, row, opts)
      erb = ErbHelper.new
      erb.process(HEADER_TEMPLATE, ctx)
    end

    def create_table(path, row, opts = {})
      ctx = create_erb_context(path, row, opts)
      erb = ErbHelper.new
      erb.process(CREATE_TABLE_TEMPLATE, ctx)
    end

    def create_sql_script(path, row, opts = {})
      return unless @first_row

      puts create_header(path, row, opts)

      TABLE_FUNCTIONS.each do |k, v|
        t = DEFAULT_OPTIONS[k]
        t = opts[k] unless opts[k].nil?
        puts send(v, path, row, opts) if t
      end

      @first_row = false
    end

    def drop_table(path, row, opts = {})
      ctx = create_erb_context(path, row, opts)
      erb = ErbHelper.new
      erb.process(DROP_TABLE_TEMPLATE, ctx)
    end

    def format_row(row, opts = {})
      header = get_header(row, opts)
      columns = get_columns(row, opts, header).join(', ')
      values = get_values(row, opts, header).join(', ')
      "INSERT INTO #{opts[:table]}(#{columns}) VALUES(#{values});"
    end

    def get_header(row, opts = {})
      if opts[:header]
        row.headers
      else
        row.map.with_index { |_item, i| i }
      end
    end

    def get_columns(row, opts = {}, header = get_header(row, opts))
      if opts[:header]
        header.map { |h| sanitize_header(h) }
      else
        row.map.with_index do |_item, i|
          "col_#{i}"
        end
      end
    end

    def get_values(row, opts = {}, header = get_header(row, opts))
      header.map do |h|
        "'#{row[h]}'"
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

    def sanitize_header(header_column)
      header_column.downcase.gsub(/[^0-9a-z ]/i, '_')
    end

    def truncate_table(path, row, opts = {})
      ctx = create_erb_context(path, row, opts)
      erb = ErbHelper.new
      erb.process(TRUNCATE_TABLE_TEMPLATE, ctx)
    end

    def with_path(path, opts = {}, &block)
      puts 'BEGIN;' if opts[:transaction]
      csv_opts = merge_csv_options(opts)
      @first_row = true
      CSV.open(path, 'rt', csv_opts) do |csv|
        csv.each do |row|
          with_row(path, row, opts, &block)
        end
      end
      puts 'COMMIT;' if opts[:transaction]
    end

    def with_paths(paths, opts = {}, &block)
      paths = [paths] unless paths.is_a?(Array)
      paths.each do |path|
        with_path(path, opts, &block)
      end
    end

    def with_row(path, row, opts = {}, &block)
      create_sql_script(path, row, opts)

      args = { path: path, row: row }
      block.call(args) if block_given?
    end
  end
end
