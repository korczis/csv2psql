# encoding: UTF-8

require 'multi_json'

module Csv2Psql
  # Json Helper
  class JsonHelper
    BASE_DIR = File.join(File.dirname(__FILE__), '..')

    class << self
      def load_file(path)
        # Load input file
        raw = IO.read(path)

        # Try to parse json from loaded data
        begin
          return MultiJson.load(raw)
        rescue Exception => e # rubocop:disable RescueException
          log_exception(e)
          raise e
        end
        nil
      end

      def log_exception(e)
        puts 'Invalid json, see error.txt'
        File.open('error.txt', 'wt') { |f| f.write(e.to_s) }
      end
    end
  end
end
