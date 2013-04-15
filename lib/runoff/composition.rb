require 'sequel'
require 'set'

module Runoff
  # Public: Provides interaction with a Skype database file.
  #
  # Examples
  #
  #   composition = Composition.new 'path/to/the/main.db'
  #   exported_files_count = composition.export 'export/folder'
  class Composition
    include FileWriter

    # Public: Returns a Set object of all the names of the exported files.
    attr_reader :exported_filenames

    # Public: Initialize a Composition object.
    #
    # main_db_file_path - A String with the path to the Skype database file.
    #
    # Raises IOError if the file cannot be found
    def initialize(main_db_file_path)
      unless File.exists? main_db_file_path
        raise IOError, "File doesn't exist"
      end

      skype_database = Sequel.connect "sqlite://#{main_db_file_path}"
      @messages = skype_database.from :Messages
      @exported_filenames = Set.new
    end

    # Public: Exports Skype chat history to text files.
    #
    # destination_path - A String with folder path, where to put exported files.
    #
    # Examples
    #
    #   export '/home/username/skype_backup'
    #   # => 8
    #
    # Returns the count of the exported files.
    def export(destination_path)
      chat_records = @messages.select(:chatname, :timestamp, :from_dispname, :body_xml)

      run_export chat_records, destination_path
    end

    # Public: Gets parsed chatnames together with partly parsed chatnames.
    #
    # Examples
    #
    #   get_chatnames
    #   # => [['something-more', 'somethindg-else'], ['#something/$more;6521032', '#something/$else;8971263']]
    #
    # Returns two Array objects containing parsed chatnames and partly parsed chatnames.
    def get_chatnames
      chatnames = @messages.select(:chatname)
      raw_chatnames = chatnames.map { |record| partly_parse_chatname record[:chatname] }.uniq
      clean_chatnames = raw_chatnames.map { |chatname| parse_chatname chatname }

      return clean_chatnames, raw_chatnames
    end

    # Public: Exports Skype chat history to text files for specified chats.
    #
    # chatnames - Array of chatnames, which will be exported
    # destination_path - A String with folder path, where to put exported files.
    #
    # Examples
    #
    #  export_chats ['#something/$more;', '#something/$else;'], '~/skype_backup'
    #  # => 2
    #
    # Returns the count of the exported files.
    def export_chats(chatnames, destination_path)
      pattern_chatnames = chatnames.map { |name| "#{name}%" }
      chat_records = @messages.where(Sequel.like(:chatname, *pattern_chatnames))

      run_export chat_records, destination_path
    end

    private

    # Internal: Performs the export process.
    #
    # chat_records - Array of chat records read from database
    #
    # Examples
    #
    #   run_export [{chatname: '#sadsad/$kjhkjh;9878977', 123123213, 'Aidzis', ''}]
    #   # => 1
    #
    # Returns the count of the exported files.
    def run_export(chat_records, destination_path)
      chat_records.each do |record|
        if filename = save_to_file(record, destination_path)
          @exported_filenames << filename
        end
      end

      @exported_filenames.count
    end
  end
end