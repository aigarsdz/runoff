require 'optparse'
require_relative '../../runoff.rb'

module Runoff
  # Public: Command classes used by the executable.
  module Commandline
    # Public: The default class that is used when the executable is called
    #         without any commands.
    #
    # Examples
    #
    #   command = None.new { archive: false }
    class None
      # Public: Returns an OptionParser object
      attr_reader :parser

      # Public: initialize a new None command object.
      #
      # options - A Hash of commandline options (default { archive: false }).
      def initialize(options = {})
        @option = options
        @parser = OptionParser.new do |opts|
          opts.banner = <<END
  runoff - a simple application to create Skype backups

  Usage:

    runoff <COMMAND> [SKYPE_USERNAME] [OPTIONS]

  Commands:

    all  - Exports all chats
    some - Exports only specified chats

  Options:

END

          opts.on '-h', '--help', 'Displays help' do
            puts opts
            exit
          end

          opts.on '-v', '--version', 'Displays a version number' do
            puts Runoff::VERSION
            exit
          end
        end
      end
    end
  end
end
