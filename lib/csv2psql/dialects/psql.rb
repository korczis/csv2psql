# encoding: UTF-8

module Csv2Psql
  module Dialect
    class Psql
      NUMERIC_TYPES = [
        {
          type: :numeric,
          name: 'smallint',
          size: 2,
          min: -32768,
          max: 32767
        },
        {
          type: :numeric,
          name: 'integer',
          size: 4,
          min: -2147483648,
          max: 2147483647
        },
        {
          type: :numeric,
          name: 'bigint',
          size: 8,
          min: -9223372036854775808,
          max: 9223372036854775807
        },
        {
          type: :numeric,
          name: 'decimal',
          size: nil
        },
        {
          type: :numeric,
          name: 'numeric',
          size: nil
        },
        {
          type: :numeric,
          name: 'real',
          size: 4
        },
        {
          type: :numeric,
          name: 'double',
          size: 8
        },
        {
          type: :numeric,
          name: 'serial',
          size: 4,
          min: 1,
          max: 2147483647
        },
        {
          type: :numeric,
          name: 'bigserial',
          size: 8,
          min: 1,
          max: 9223372036854775807
        }
      ]
    end
  end
end
