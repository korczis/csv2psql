# encoding: UTF-8

require_relative '../../../lib/csv2psql/cli/cli'

describe Csv2Psql do
  it 'version' do
    run_cli(%w(version))
  end
end
