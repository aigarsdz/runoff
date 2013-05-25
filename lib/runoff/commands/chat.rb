module Runoff
  module Commands
    class Chat < Command
      def self.process(args, options = {})
        if args.empty? && !options.has_key?('from')
          raise ArgumentError.new 'You must specify a username or a --from option'
        end

        composition = self.get_composition args[0], options
        destination = self.get_destination options
        chatnames, raw_chatnames = composition.get_chatnames

        self.list_chatnames chatnames
        indecies = ask 'Which chats do you want to export? (Enter indecies) '
        indecies = indecies.split.map { |index| index.to_i }
        selected_chatnames = []

        indecies.each { |index| selected_chatnames << raw_chatnames[index] }
        self.print_result composition.export_chats(selected_chatnames, destination)
        self.try_to_archive composition, destination, options

      rescue ArgumentError => e
        puts e
      rescue IOError => e
        puts e
      end
    end
  end
end