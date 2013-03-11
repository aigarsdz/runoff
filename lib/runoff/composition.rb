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

    # Public: Returns a Set object of all the names of the exported files.
    attr_reader :exported_filenames

    # Public: Initialize a Composition object.
    #
    # main_db_file_path - A String with the path to the Skype database file.
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
    #   export ~/skype_backup
    #   # => 8
    #
    # Returns the count of the exported files.
    def export(destination_path)
      chat_records = @messages.select(:chatname, :timestamp, :from_dispname, :body_xml)

      chat_records.each { |record| save_to_file record, destination_path }

      @exported_filenames.count
    end

    private

    # Internal: Saves a single chat message to a file.
    #
    # chat_record - a Hash containing data about a single chat message.
    # output_directory - A String with the path to the directory, wher the file will be saved.
    #
    # Examples
    #
    #   save_to_file record, '~/skype_backup'
    def save_to_file(chat_record, output_directory)
      datetime = Time.at chat_record[:timestamp]
      output_record = "[#{datetime.to_date}] #{chat_record[:from_dispname]}: #{chat_record[:body_xml]}"
      filename = "#{output_directory}/#{parse_chatname chat_record[:chatname]}"

      File.open(filename, 'a') do |file|
        file.puts output_record
      end

      @exported_filenames << filename

    rescue StandardError => e
      puts e
    end

    # Internal: Converts chatname from database to a valid file name.
    #
    # raw_chatname - A String with a chatname read from the database.
    #
    # Examples
    #
    #   parse_chatname '#someone/$someone_else;521357125362'
    #   # => someone-someone_else.txt
    #
    # Returns a String with a valid file name.
    def parse_chatname(raw_chatname)
      if match = raw_chatname.match(/#(.+)\/\$(.+);/)
        first_part, second_part = match.captures

        "#{first_part}-#{second_part}.txt"
      else
        raise StandardError, "Skipping #{raw_chatname}: Chatname in a wrong format"
      end
    end
  end
end