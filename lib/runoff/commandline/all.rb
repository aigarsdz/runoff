require_relative 'command'

module Runoff
  # Public: Command classes used by the executable.
  module Commandline
    # Public: A command class that is used to export all chat history.
    #
    # Examples
    #
    #   command = All.new { archive: true }
    #   command.execute [ 'skype_username' ]
    class All < Command
      # Public: initialize a new All command object.
      #
      # options - A Hash of commandline options (default { archive: true, adapter: 'TxtAdapter' }).
      def initialize(options = {})
        @options = options
        @parser = OptionParser.new do |opts|
          opts.banner = 'Exports all chats: runoff all [SKYPE_USERNAME] [OPTIONS]'
          opts.on '-h', '--help', 'Displays help' do
            puts opts
            exit
          end

          opts.on '-f', '--from PATH', 'Specifies the location of the database file (main.db)' do |path|
            @options[:from] = path
          end

          opts.on '-d', '--destination PATH', 'Changes the default path for the exported files' do |path|
            @options[:destination] = path
          end

          opts.on '-a', '--[no-]archive', 'Toggles archiving feature' do |enable|
            @options[:archive] = enable
          end

          opts.on '-A', '--adapter [NAME]', 'Uses a specific file type adapter' do |adapter|
            @options[:adapter] = adapter.capitalize + 'Adapter'
          end
        end
      end

      # Public: executes the command.
      #
      # args - An Array of commandline arguments.
      def execute(args)
        super args do |chat, file_writer|
          file_writer.write chat.get_messages
        end
      end
    end
  end
end
