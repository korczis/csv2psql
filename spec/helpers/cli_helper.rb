# encoding: UTF-8

require_relative '../../lib/csv2psql/cli/cli'

# CliHelper
module CliHelper
  # Execute block and capture its stdou
  # @param block Block to be executed with stdout redirected
  # @returns Captured output as string
  def capture_stdout(&block)
    original_stdout = $stdout
    $stdout = fake = StringIO.new
    begin
      block.call if block_given?
    ensure
      $stdout = original_stdout
    end
    fake.string
  end

  # Run CLI with arguments and return captured stdout
  # @param args Arguments
  # @return Captured stdout
  def run_cli(args = [])
    old = $PROGRAM_NAME
    $PROGRAM_NAME = 'csv2psql'
    res = capture_stdout { Csv2Psql::Cli.main(args) }
    $PROGRAM_NAME = old
    res
  end
end
