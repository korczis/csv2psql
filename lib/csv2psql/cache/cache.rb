# encoding: UTF-8

require 'lru'

module Csv2Psql
  # Last Recently Used cache implementation
  class Cache
    attr_accessor :max_size

    def initialize(max_size = 1000)
      @cache = ::Cache::LRU.new(max_elements: max_size)
    end

    def put(key, value)
      @cache.put(key, value)
    end

    def get(key, &block)
      @cache.get(key, &block)
    end
  end
end
