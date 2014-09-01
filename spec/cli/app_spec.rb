# encoding: UTF-8

require_relative '../../lib/csv2psql/cli/cli'

describe 'csv2psql' do
  it 'help' do
    run_cli(['help'])
  end
end