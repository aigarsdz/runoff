require 'sequel'

module Runoff
  # Commands that can be executed by the application.
  module Commands
    class All < Command
      # Public: Exports all Skyoe chat history.
      #
      # args - an array containing skype username
      # options - a hash containing user provided options
      #
      # Examples
      #
      #   All.process ['username'], { from: '~/main.db' }
      def self.process(args, options = {})
        file_writer, export_path = self.get_file_writer_components args, options

        file_writer.export_database Runoff::SkypeDataFormat.new, export_path, options.archive
      end
    end
  end
end
