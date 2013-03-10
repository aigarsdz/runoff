#!/usr/bin/env ruby

require 'thor'
require 'runoff'

module Runoff
  class Source < Thor
    desc 'all SKYPE_USERNAME', 'Export all chat history'

    long_desc <<-LONGDESC
      runoff all SKYPE_USERNAME will export all your Skype chat history as text files.

      SKYPE_USERNAME - the Skype account username, which data you want to access
    LONGDESC

    method_option :from, aliases: '-f', desc: 'Specify the location of the main.db file'
    method_option :to, aliases: '-t', desc: 'Specify where to put export files'

    def all(skype_username)
      main_db_file_location = Location.default_skype_data_location skype_username
      composition = Composition.new main_db_file_location
      destination = options[:to] || Location.home_path
      file_count = composition.export destination

      if file_count == 1
        puts "Finished: 1 file was exported"
      elsif file_count > 1
        puts "Finished: #{file_count} files were exported"
      end

    rescue IOError => e
      puts e
    end
  end

  Source.start
end