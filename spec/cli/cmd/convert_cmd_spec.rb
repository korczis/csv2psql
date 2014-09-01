# encoding: UTF-8

require_relative '../../../lib/csv2psql/cli/cli'

describe Csv2Psql do
  it 'help convert' do
    run_cli(%w(help convert))
  end

  it 'convert data/sample.csv' do
    run_cli(%w(convert data/sample.csv))
  end
end
