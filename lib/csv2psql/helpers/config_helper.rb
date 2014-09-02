# encoding: UTF-8

require_relative '../config/config'

module Csv2Psql
  # CSV Helper
  class ConfigHelper
    class << self
      def config(path = Config::CONFIG_PATH)
        Config.config(path)
      end
    end
  end
end
