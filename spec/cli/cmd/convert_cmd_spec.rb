# encoding: UTF-8

require_relative '../../../lib/csv2psql/cli/cli'

describe 'csv2psql convert' do
  it 'help convert' do
    run_cli(%w(help convert))
  end

  it 'convert data/cia-data-all.csv' do
    run_cli(%w(convert data/cia-data-all.csv))
  end

  it 'convert data/sample.csv' do
    run_cli(%w(convert data/sample.csv))
  end

  it 'convert --drop-table data/sample.csv' do
    run_cli(%w(convert --drop-table data/sample.csv))
  end

  it 'convert --drop-table --create-table data/sample.csv' do
    run_cli(%w(convert --drop-table --create-table data/sample.csv))
  end

  it 'convert --drop-table --create-table --truncate-table data/sample.csv' do
    args = %w(
      convert
      --drop-table
      --create-table
      --truncate-table
      data/sample.csv
    )
    run_cli(args)
  end
end
