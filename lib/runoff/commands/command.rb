module Runoff
  # Public: Commands that can be executed by the application.
  module Commands
    # Public: The base class for all the commands.
    class Command
      private

      # Internal: Gets a path to the Skype's main.db file.
      #
      # username - A String containing Skype username
      # options  - A hash containing command-line options passed to the command.
      #            If the username is empty, then the hash must contain :from key.
      #
      # Examples
      #
      #   get_database_path('john_doe', {})
      #   # => Path to the default Skype database location depending on the operating system.
      #
      #   get_database_path('', { from: '~/Desktop/main.db' })
      #   # => '~/Desktop/main.db'
      #
      # Returns a String
      def self.get_database_path(username, options)
        if options.has_key?(:from)
          options[:from]
        else
          Runoff::Location.default_skype_data_location username
        end
      end
    end
  end
end
