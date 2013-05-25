module Runoff
  module Commands
    class Command
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
      def self.get_composition(skype_username, options)
        main_db_file_location = options[:from] || Runoff::Location.default_skype_data_location(skype_username)
        Runoff::Composition.new main_db_file_location
      end

      # Internal: Gets a destination path depending on the entered options.
      #
      # Examples
      #
      #   get_destination
      #   # => '~/skype_backup'
      #
      # Returns a String containing a path to the destination directory.
      def self.get_destination(options)
        options[:destination] || "#{Location.home_path}/skype-backup"
      end

      # Internal: Informs the user that the application has finished running.
      #
      # count - A number of files that have been exported
      #
      # Examples
      #
      #   print_result 4
      #   # => Finished: 4 files were exported
      def self.print_result(count)
        if count == 1
          puts 'Finished: 1 file was exported'
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
      def self.list_chatnames(chatnames)
        chatnames.each_with_index { |n, i| puts "[#{i}] #{n}" }
        puts
      end

      # Internal: performs archiving if an --archive option is provided
      #
      # composition - A Compositon object
      # destination - A String containing a path to the export directory.
      #
      # Examples
      #
      #   try_to_archive composition, '/home/username/skype-backup'
      def self.try_to_archive(composition, destination, options)
        if options[:archive]
          composition.archive destination
        end
      rescue StandardError
        puts 'Faild to create an archive'
      end
    end
  end
end