#!/usr/bin/env ruby

require 'optparse'

options = {}

option_parser = OptionParser.new do |opt|
  opt.banner = 'Usage: runoff SKYPE_ACCOUNT_NAME [PATH_TO_THE_DATABASE_FILE] [OPTIONS]'
  opt.separator ''
  opt.separator 'Options'

  opt.on '-h', '--help', 'help' do
    puts option_parser
  end
end

option_parser.parse!

unless ARGV[0].empty?
  # do the magic
end