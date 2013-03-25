#!/usr/bin/env ruby

require 'thor'
require 'runoff'

# Public: Provides the functionality to back up Skype chat history.
#
# Examples
#
#   runoff all skype_username
#   # => Finished: 8 files were exported
module Runoff

  # Public: Entry point for the executable. Processes the CLI input from the user.
  class Source < Thor
    desc 'all [SKYPE_USERNAME] [OPTIONS]', 'Export all chat history'

    long_desc <<-LONGDESC
      runoff all [SKYPE_USERNAME] [OPTIONS] will export all your Skype chat history as text files.

      SKYPE_USERNAME - the Skype account username, which data you want to access
    LONGDESC

    method_option :from, aliases: '-f', desc: 'Specify the location of the main.db file'
    method_option :to, aliases: '-t', desc: 'Specify where to put export files'

    # Public: Exports all chat history from the Skype database.
    #
    # skype_username - A String that contains a username of the Skype account,
    #                  which database we want to access.
    #
    # Examples
    #
    #   all 'skype_username'
    #   # => Finished: 8 files were exported
    def all(skype_username = nil)
      composition = get_composition skype_username
      destination = get_destination

      print_result composition.export(destination)

    rescue IOError => e
      puts e
    rescue StandardError => e
      puts e
    end

    desc 'chat [SKYPE_USERNAME] [OPTIONS]', 'Export pecified chats history'

    long_desc <<-LONGDESC
      runoff chat [SKYPE_USERNAME] [OPTIONS] will export all your Skype chat history as text files.

      SKYPE_USERNAME - the Skype account username, which data you want to access
    LONGDESC

    method_option :from, aliases: '-f', desc: 'Specify the location of the main.db file'
    method_option :to, aliases: '-t', desc: 'Specify where to put export files'

    # Public: Exports specified chats from the Skype database.
    #
    # skype_username - A String that contains a username of the Skype account,
    #                  which database we want to access.
    #
    # Examples
    #
    #   chat 'skype_username'
    #   # => Finished: 3 files were exported
    def chat(skype_username = nil)
      composition = get_composition skype_username
      destination = get_destination
      chatnames, raw_chatnames = composition.get_chatnames

      list_chatnames chatnames
      indecies = ask "Which chats do you want to export? (Enter indecies) "
      indecies = indecies.split.map { |index| index.to_i }
      selected_chatnames = []

      indecies.each { |index| selected_chatnames << raw_chatnames[index] }
      print_result composition.export_chats(selected_chatnames, destination)

    rescue IOError => e
      puts e
    rescue StandardError => e
      puts e
    end

    private

    # Internal: Gets a Composition object.
    #
    # skype_username - A String that contains a username of the Skype account,
    #                  which database we want to access.
    #
    # Examples
    #
    #   get_composition 'skype_username'
    #   # => #<Composition:0x00002324212>
    #
    # Returns a Composition object with a reference to a specific Skype database.
    # Raises StandardError if no Skype username or --from option is provided.
    def get_composition(skype_username)
      unless skype_username || options[:from]
        raise StandardError, 'You must provide a Skype username or a --from option'
      end

      main_db_file_location = options[:from] || Location.default_skype_data_location(skype_username)
      Composition.new main_db_file_location
    end

    # Internal: Gets a destination path depending on the entered options.
    #
    # Examples
    #
    #   get_destination
    #   # => '~/skype_backup'
    #
    # Returns a String containing a path to the destination directory.
    def get_destination
      options[:to] || Location.home_path
    end

    # Internal: Informs the user that the application has finished running.
    #
    # count - A number of files that have been exported
    #
    # Examples
    #
    #   print_result 4
    #   # => Finished: 4 files were exported
    def print_result(count)
      if count == 1
        puts "Finished: 1 file was exported"
      elsif count > 1
        puts "Finished: #{count} files were exported"
      end
    end

    # Internal: Prints available chatnames.
    #
    # chatnames - An Array containing the chatname strings
    #
    # Examples
    #
    #   list_chatnames ['something-more', 'something-else']
    #   # => [0] something-more
    #        [1] something-else
    def list_chatnames(chatnames)
      chatnames.each_with_index { |n, i| puts "[#{i}] #{n}" }
      puts
    end
  end

  Source.start
end