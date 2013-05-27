module Runoff
  # Public: Commands that can be executed by the application.
  module Commands
    # Public: Methods that are shared between different commands.
    class Command
      private
      # Internal: Gets a Composition object.
      #
      # skype_username - A String that contains a username of the Skype account,
      #                  which database we want to access.
      # optional_path - A String that contains path to a main.db file (Skype's database).
      #
      # Examples
      #
      #   get_composition 'skype_username', ''
      #   # => #<Composition:0x00002324212>
      #
      # Returns a Composition object with a reference to a specific Skype database.
      def self.get_composition(skype_username, optional_path)
        Runoff::Composition.new optional_path, skype_username
      end

      # Internal: Gets a destination path depending on the entered options.
      #
      # optional_path - A String that contains path where to save exported files.
      #
      # Examples
      #
      #   get_destination ''
      #   # => '~/skype_backup'
      #
      # Returns a String containing a path to the destination directory.
      def self.get_destination(optional_path)
        optional_path || "#{ENV['HOME']}/skype-backup"
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
      # destination - A String containing a path to the export directory.
      # is_archive_enebled - A flag indicating whether to create an archive.
      #
      # Examples
      #
      #   try_to_archive '/home/username/skype-backup', { archive: false }
      def self.try_to_archive(destination, is_archive_enebled)
        unless is_archive_enebled
          Runoff::FileWriter.archive destination
        end
      rescue StandardError => e
        puts e
        puts 'Faild to create an archive'
      end
    end
  end
end