#!/usr/bin/env ruby

require 'thor'

module Runoff
  class RunoffSource < Thor
    desc 'all USERNAME', 'Export all chat history'
    long_desc <<-LONGDESC
      runoff all USERNAME will export all your Skype chat history as text files
    LONGDESC

    # TODO: add default locations
    method_option :from, alias: '-f', desc: 'Specify the location of the main.db file'
    method_option :to, alias: '-t', desc: 'Specify where to put export files'

    def all(username)
      # TODO: export skype chat history
    end
  end

  RunoffSource.start
end