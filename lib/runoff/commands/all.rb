module Runoff
  # Public: Commands that can be executed by the application.
  module Commands
    # Public: Command to export all Skype chat history.
    #
    # Examples
    #
    #   All.process ['username'], { from: '/path/to/main.db' }
    class All < Command
      # Public: Export all chats.
      #
      # args - Array containing skype username
      # options - Hash containing user provided options
      #
      # Examples
      #
      #   All.process ['username'], { from: '~/main.db' }
      def self.process(args, options = {})
        if args.empty? && !options.has_key?(:from)
          raise ArgumentError.new 'You must specify a username or a --from option'
        end

        composition = self.get_composition args[0], options[:from]
        destination = self.get_destination options[:destination]

        self.print_result composition.export(destination)
        self.try_to_archive destination, options[:archive]

      rescue ArgumentError => e
        puts e
      rescue IOError => e
        puts e
      end
    end
  end
end