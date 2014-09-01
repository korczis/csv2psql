# encoding: UTF-8

require_relative '../../../lib/csv2psql/cli/cli'

describe 'csv2psql analyze' do
  it 'help analyze' do
    run_cli(%w(help analyze))
  end

  it 'analyze data/cia-data-all.csv' do
    run_cli(%w(analyze data/cia-data-all.csv))
  end

  it 'analyze data/sample.csv' do
    run_cli(%w(analyze data/sample.csv))
  end

  it '--delimiter ";" analyze data/sample.csv' do
    run_cli(%w(analyze --delimiter ";" data/sample_semicolon.csv))
  end

  it 'analyze --format json data/sample.csv' do
    run_cli(%w(analyze --format json data/sample.csv))
  end

  it 'analyze --format table data/sample.csv' do
    run_cli(%w(analyze --format table data/sample.csv))
  end
end
