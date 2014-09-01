# encoding: UTF-8

require 'multi_json'
require 'pathname'
require 'pp'

require_relative '../version'
require_relative '../helpers/csv_helper'
require_relative '../helpers/erb_helper'

module Csv2Psql
  # SQL Code generator
  class Generator
    BASE_DIR = File.join(File.dirname(__FILE__), '..', '..', '..')
    TEMPLATE_DIR = File.join(BASE_DIR, 'templates')
    CREATE_TABLE_TEMPLATE = File.join(TEMPLATE_DIR, 'create_table.sql.erb')
    DROP_TABLE_TEMPLATE = File.join(TEMPLATE_DIR, 'drop_table.sql.erb')
    HEADER_TEMPLATE = File.join(TEMPLATE_DIR, 'header.sql.erb')
    TRUNCATE_TABLE_TEMPLATE = File.join(TEMPLATE_DIR, 'truncate_table.sql.erb')

    DEFAULT_OPTIONS = {
      'create-table' => false,
      'drop-table' => false,
      'truncate-table' => false,
      table: 'my_table'
    }

    TABLE_FUNCTIONS = {
      'drop-table' => :drop_table,
      'create-table' => :create_table,
      'truncate-table' => :truncate_table
    }

    attr_reader :output

    def initialize(output)
      @output = output
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
      output.write create_header(path, row, opts)

      TABLE_FUNCTIONS.each do |k, v|
        t = DEFAULT_OPTIONS[k]
        t = opts[k] unless opts[k].nil?
        output.write send(v, path, row, opts) if t
      end
    end

    def drop_table(path, row, opts = {})
      ctx = create_erb_context(path, row, opts)
      erb = ErbHelper.new
      erb.process(DROP_TABLE_TEMPLATE, ctx)
    end

    def format_row(row, opts = {})
      table = opts[:table] || DEFAULT_OPTIONS[:table]

      header = get_header(row, opts)
      columns = get_columns(row, opts, header).join(', ')
      values = get_values(row, opts, header).join(', ')
      "INSERT INTO #{table}(#{columns}) VALUES(#{values});"
    end

    def get_header(row, opts = {})
      CsvHelper.get_header(row, opts)
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
        value = row[h]
        sanitized_value = sanitize_value(value)
        "'#{sanitized_value}'"
      end
    end

    def sanitize_header(header_column)
      header_column.downcase.gsub(/[^0-9a-z]/i, '_')
    end

    def sanitize_value(value)
      value ||= ''
      value.gsub("'", "''")
    end

    def truncate_table(path, row, opts = {})
      ctx = create_erb_context(path, row, opts)
      erb = ErbHelper.new
      erb.process(TRUNCATE_TABLE_TEMPLATE, ctx)
    end
  end
end
