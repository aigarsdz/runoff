require 'sequel'

module Runoff
  # Commands that can be executed by the application.
  module Commands
    class All
      # Public: Exports all Skyoe chat history.
      #
      # args - an array containing skype username
      # options - a hash containing user provided options
      #
      # Examples
      #
      #   All.process ['username'], { from: '~/main.db' }
      def self.process(args, options = {})
        if args.empty? && !options.has_key?(:from)
          raise ArgumentError.new 'You must specify the Skype username or a --from option'
        end

        main_db_path = Runoff::Location.get_database_path args[0], options
        export_path = Runoff::Location.get_export_path options
        db_handler = Sequel.sqlite main_db_path
        file_writer = Runoff::FileWriter.new db_handler

        file_writer.export_database Runoff::SkypeDataFormat.new, export_path, options.archive
      end
    end
  end
end
