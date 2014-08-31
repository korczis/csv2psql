# encoding: UTF-8

require 'erb'
require 'pathname'

module Csv2Psql
  # ERB Helper
  class ErbHelper
    BASE_DIR = File.join(File.dirname(__FILE__), '..')

    def render(filename)
      path = File.join(BASE_DIR, filename)
      File.read(path)
    end

    def process(filename, ctx = {})
      ctx ||= {} # rubocop:disable Lint/UselessAssignment
      b = binding
      erb = ERB.new(File.read(filename), 0, '>')
      erb.filename = filename
      erb.result b
    end

    def run
      FILES.each do |files|
        process(files)
      end
    end
  end
end
