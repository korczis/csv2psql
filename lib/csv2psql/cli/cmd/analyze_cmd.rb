# encoding: utf-8

require 'json'
require 'pp'
require 'terminal-table'

require_relative '../../convert/convert'
require_relative '../../processor/processor'

formats = {
  'json' => lambda do |res|
    res.files.each do |_fname, results|
      results[:columns].each do |_k, v|
        v.each do |d, det|
          v[d] = det[:results]
        end
      end
    end

    JSON.pretty_generate(res.files)
  end,

  'table' => lambda do |res|
    res.files.map do |file, details|
      header = ['column'] + res.analyzers.map { |a| a[:name] }

      rows = details[:columns].map do |k, v|
        [k] + v.keys.map { |name| v[name][:results][:count] }
      end

      Terminal::Table.new title: file, headings: header, rows: rows
    end
  end
}

desc 'Analyze csv file'
command :analyze do |c|
  c.desc "Output format #{formats.keys.join(', ')}"
  c.default_value(formats.keys.first)
  c.flag [:f, :format]
  c.action do |global_options, options, args|
    help_now!('No file to analyze specified!') if args.empty?

    opts = {}.merge(global_options).merge(options)

    formater = formats[opts[:format]]
    if formater.nil?
      fmters = formats.keys.join(', ')
      fail ArgumentError, "Wrong formatter specified, can be: #{fmters}"
    end

    res = Csv2Psql::Convert.analyze(args, opts)

    output = formater.call(res)
    if output.is_a?(Array)
      output.each do |o|
        puts o
      end
    else
      puts output
    end
  end
end
