# encoding: UTF-8

require 'multi_json'

require_relative '../helpers/json_helper'

module Csv2Psql
  # Configuration module
  module Config
    BASE_DIR = File.join(File.dirname(__FILE__), '..', '..', '..')
    CONFIG_PATH = File.join(BASE_DIR, 'config', 'config.json')

    class << self
      def config(path = CONFIG_PATH)
        @config ||= load_config(path)
        @config
      end

      def load_config(path = CONFIG_PATH)
        JsonHelper.load_file(path)
      end
    end
  end
end
