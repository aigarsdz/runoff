require 'optparse'
require 'colorize'

require_relative '../../runoff'

module Runoff
  # Public: Command classes used by the executable.
  module Commandline
    # Public: A base class for all runoff commands except None.
    #
    # Should be used only by inheriting.
    class Command
      # Public: Returns an OptionParser object
      attr_reader :parser

      # Public: executes the command.
      #
      # args - An Array of commandline arguments.
      def execute(args)
        puts 'Exporting...'.colorize :green

        db_location = Location.get_database_path args, @options
        chat = Chat.new db_location
        file_writer = FileWriter.new @options

        yield chat, file_writer if block_given?

        file_writer.archive if @options[:archive]

        puts 'Finished.'.colorize :green
      end
    end
  end
end
