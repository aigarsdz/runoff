require 'optparse'
require_relative '../../runoff.rb'

module Runoff
  # Public: Command classes used by the executable.
  module Commandline
    # Public: A command class that is used to export all chat history.
    #
    # Examples
    #
    #   command = All.new { archive: false }
    #   command.execute [ 'skype_username' ]
    class All
      # Public: Returns an OptionParser object
      attr_reader :parser

      # Public: initialize a new All command object.
      #
      # options - A Hash of commandline options (default { archive: false }).
      def initialize(options = nil)
        @options = options
        @parser = OptionParser.new do |opts|
          opts.banner = 'Exports all chats: runoff all [SKYPE_USERNAME] [OPTIONS]'
          opts.on '-h', '--help', 'Displays help' do
            puts opts
            exit
          end

          opts.on '-d', '--destination PATH', 'Changes the default path for the exported files' do |path|
            @options[:destination] = path
          end
        end
      end

      # Public: executes the command.
      #
      # args - An Array of commandline arguments.
      def execute(args)
        db_location = Location.get_database_path args, @options
        chat = Chat.new db_location
        file_writer = FileWriter.new @options

        chat.each { |entry| file_writer.write entry }
      end
    end
  end
end
