module Runoff
  # Commands that can be executed by the application.
  module Commands
    # The base class for every runoff command.
    class Command
      # Public: Provides a FileWriter object and the destination path for the command.
      #
      # args - an array of command line arguments
      # options - an object with options passed to the command
      #
      # Examples
      #
      #   file_writer, path = get_file_writer_components [], nil
      #
      # Raises an ArgumentError.
      # Returns a FileWriter object and a string with file path.
      def self.get_file_writer_components(args, options)
        if args.empty? && !options.from
          fail ArgumentError, 'Error: You must specify the Skype username or a --from option'
        end

        main_db_path = Runoff::Location.get_database_path args[0], options
        export_path  = Runoff::Location.get_export_path options
        db_handler   = Sequel.sqlite main_db_path

        return Runoff::FileWriter.new(db_handler), export_path
      end
    end
  end
end