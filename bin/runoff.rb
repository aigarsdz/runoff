#!/usr/bin/env ruby

require 'thor'
require 'runoff'

module Runoff
  class RunoffSource < Thor
    desc 'all SKYPE_USERNAME', 'Export all chat history'

    long_desc <<-LONGDESC
      runoff all SKYPE_USERNAME will export all your Skype chat history as text files.

      SKYPE_USERNAME - the Skype account username, which data you want to access
    LONGDESC

    method_option :from, alias: '-f', desc: 'Specify the location of the main.db file'
    method_option :to, alias: '-t', desc: 'Specify where to put export files'

    def all(skype_username)
      main_db_file_location = Location.default_skype_data_location skype_username
      composition = Composition.new main_db_file_location
      destination = options[:to] || Location.home_path

      composition.export destination

    rescue IOError => message
      puts message
    end
  end

  RunoffSource.start
end