require 'sequel'

module Runoff
  # Commands that can be executed by the application.
  module Commands
    class All < Command
      # Public: Export all Skyoe chat history.
      #
      # args - Array containing skype username
      # options - Hash containing user provided options
      #
      # Examples
      #
      #   All.process ['username'], { from: '~/main.db' }
      def self.process(args, options = {})
        if args.empty? && !options.has_key?(:from)
          raise ArgumentError.new 'You must specify the Skype username or a --from option'
        end

        main_db_path = Runoff::Location.get_database_path args[0], options
        db_handler = Sequel.sqlite main_db_path
        file_writer = Runoff::FileWriter.new db_handler

        file_writer.export_database Runoff::SkypeDataFormat.new
      end
    end
  end
end
