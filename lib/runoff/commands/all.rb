module Runoff
  module Commands
    class All < Command
      def self.process(args, options = {})
        if args.empty? && !options.has_key?('from')
          raise ArgumentError.new 'You must specify a username or a --from option'
        end

        composition = self.get_composition args[0], options
        destination = self.get_destination options

        self.print_result composition.export(destination)
        self.try_to_archive composition, destination, options

      rescue ArgumentError => e
        puts e
      rescue IOError => e
        puts e
      end
    end
  end
end