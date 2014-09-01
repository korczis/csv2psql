# encoding: UTF-8

require_relative '../../lib/csv2psql/cli/cli'

describe Csv2Psql do
  it 'help' do
    run_cli(['help'])
  end
end