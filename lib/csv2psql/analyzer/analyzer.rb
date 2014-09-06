# encoding: UTF-8

require 'pathname'
require 'pp'

require_relative '../helpers/erb_helper'
require_relative '../extensions/string'

module Csv2Psql
  # Analyzer file analyzer class
  class Analyzer
    DEFAULT_OPTIONS = {}
    ANALYZERS_DIR = File.join(File.dirname(__FILE__), 'types')

    attr_reader :analyzers, :files

    def initialize(cache = nil)
      @files = {}
      @cache = cache
      @analyzers = load_analyzers
    end

    def analyze(path, row, opts = {})
      data = get_data(path)

      header = CsvHelper.get_header(row, opts)
      header.each do |h|
        col = get_column(data, h)
        val = row[h]
        col.each do |_name, analyzer|
          analyzer.analyze(val)
        end
      end

      data[:lines] = data[:lines] + 1
    end

    def create_column(data, column)
      data[:columns][column] = {}
      res = data[:columns][column]

      analyzers.each do |analyzer|
        res[analyzer[:name]] = analyzer[:class].new
      end

      res
    end

    def create_data(path)
      files[path] = {
        columns: {
        },
        lines: 0
      }
      files[path]
    end

    def get_data(path)
      return files[path] if files.key?(path)

      create_data(path)
    end

    def get_column(data, column)
      res = data[:columns][column]
      return res if res

      create_column(data, column)
    end

    def load_analyze_class(analyzer_class)
      Object.const_get('Csv2Psql')
        .const_get('Analyzers')
        .const_get(analyzer_class)
    end

    def load_analyzers
      Dir[ANALYZERS_DIR + '**/*.rb'].map do |path|
        fname = File.basename(path, '.rb')
        analyzer_class = fname.camel_case
        require(path)

        {
          name: analyzer_class,
          class: load_analyze_class(analyzer_class)
        }
      end
    end
  end
end
