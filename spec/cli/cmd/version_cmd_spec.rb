# encoding: UTF-8

require_relative '../../../lib/csv2psql/cli/cli'

describe 'csv2psql version' do
  it 'version' do
    run_cli(%w(version))
  end
end
