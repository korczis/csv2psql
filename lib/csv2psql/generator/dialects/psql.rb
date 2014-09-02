# encoding: UTF-8

module Csv2Psql
  module Dialect
    # PostgreSQL specific stuff
    class Psql
      NUMERIC_TYPES = [
        {
          type: :numeric,
          name: 'smallint',
          size: 2,
          min: -32_768,
          max: 32_767
        },
        {
          type: :numeric,
          name: 'integer',
          size: 4,
          min: -2_147_483_648,
          max: 2_147_483_647
        },
        {
          type: :numeric,
          name: 'bigint',
          size: 8,
          min: -9_223_372_036_854_775_808,
          max: 9_223_372_036_854_775_807
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
          max: 2_147_483_647
        },
        {
          type: :numeric,
          name: 'bigserial',
          size: 8,
          min: 1,
          max: 9_223_372_036_854_775_807
        }
      ]
    end
  end
end
