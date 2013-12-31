require 'sequel'
require 'set'

module Runoff
  # Commands that can be executed by the application.
  module Commands
    class Some < Command
      # Public: Exports a specified part of Skyoe chat history.
      #
      # args - an array containing skype username
      # options - a hash containing user provided options
      #
      # Examples
      #
      #   Some.process ['username'], { from: '~/main.db' }
      def self.process(args, options = {})
        file_writer, export_path = self.get_file_writer_components args, options
        format = Runoff::SkypeDataFormat.new

        file_writer.export_database_partially format, export_path, options.archive do |w, d|
          chatname_dataset = d.select(:chatname)
          chatnames = Set.new # Set is necessary to filter out duplicate chatnames.

          chatname_dataset.each { |row| chatnames.add format.normalize(row[:chatname]) }

          # In order to use indices we need an array.
          w.selected_entries = chatnames.to_a

          w.selected_entries.each_with_index { |e, i| puts "[#{i}] #{e}" }

          puts # Ensure a blank line.
          # Return the user response back to the FileWriter class.
          next ask("Specify which chats to export separating each number with a comma:")
        end
      end
    end
  end
end