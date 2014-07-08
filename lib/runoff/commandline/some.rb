require_relative 'command'
require 'pry'

module Runoff
  # Public: Command classes used by the executable.
  module Commandline
    # Public: A command class that is used to export specified chat history.
    #
    # Examples
    #
    #   command = Some.new { archive: true }
    #   command.execute [ 'skype_username' ]
    class Some < Command
      # Public: initialize a new All command object.
      #
      # options - A Hash of commandline options (default { archive: true }).
      def initialize(options = {})
        @options = options
        @parser = OptionParser.new do |opts|
          opts.banner = 'Exports specified chats: runoff some [SKYPE_USERNAME] [OPTIONS]'
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
          ids      = prompt_for_chatnames chat
          messages = chat.get_messages

          selected_messages = messages.keep_if { |m| ids.include? m[Runoff::COLUMNS[0]] }

          file_writer.write selected_messages
        end
      end

      # Public: Asks user to specify, which chats to export.
      #
      # chat - A Chat object.
      #
      # Examples
      #
      #   get_requested_chatnames Chat.new('/path/to/main.db')
      #   # => [120, 86, 201]
      #
      # Returns an Array of conversation ids.
      def prompt_for_chatnames(chat)
        puts 'Specify numbers of the chats that you want to export (e.g., 201, 86, 120)'
        puts

        chat.get_chatname_options.each do |opt|
          puts "[#{opt[:id]}] #{opt[:name]}"
        end

        puts
        print "Numbers: "
        options = STDIN.gets # NOTE: For some reason just gets throws an error here.

        options.split(',').map(&:to_i)
      end
    end
  end
end
