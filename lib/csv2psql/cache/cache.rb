# encoding: UTF-8

module Csv2Psql
  # Last Recently Used cache implementation
  class Cache
    attr_accessor :max_size

    def initialize(max_size = 10_000)
      @data = {}
      @max_size = max_size
    end

    def store(key, value)
      @data.store key, [0, value]
      age_keys
      prune
    end

    def read(key)
      if value == @data[key]
        renew(key)
        age_keys
      end
      value
    end

    private # -------------------------------

    def renew(key)
      @data[key][0] = 0
    end

    def delete_oldest
      m = @data.values.map { |v| v[0] }.max
      @data.reject! { |_k, v| v[0] == m }
    end

    def age_keys
      @data.each { |k, _v| @data[k][0] += 1 }
    end

    def prune
      delete_oldest if @data.size > @max_size
    end
  end
end
