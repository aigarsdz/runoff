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
    #   export '~/skype_backup'
    #   # => 8
    #
    # Returns the count of the exported files.
    def export(destination_path)
      chat_records = @messages.select(:chatname, :timestamp, :from_dispname, :body_xml)

      chat_records.each { |record| save_to_file record, destination_path }

      @exported_filenames.count
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
      filename = "#{output_directory}/#{parse_chatname chat_record[:chatname]}.txt"

      File.open(filename, 'a') do |file|
        file.puts output_record
      end

      @exported_filenames << filename
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
      match = raw_chatname.match(/#(.+)\/\$(.+);|#(.+)\/\$/)
      first_part, second_part, third_part = match.captures
      chatname = "#{first_part}-#{second_part}-#{third_part}"

      trim_dashes chatname
    end

    # Internal: Removes extra characters from the end of a chatname.
    #
    # raw_chatname - A String with a chatname read from the database
    #
    # Examples
    #
    #   partly_parse_chatname '#someone/$someone_else;521357125362'
    #   # => #someone/$someone_else;
    #
    # Returns a String with a chatname without extra characters at the end.
    def partly_parse_chatname(raw_chatname)
      match = raw_chatname.match(/(#.+\/\$.+;)|(#.+\/\$)/)
      first_group, second_group = match.captures

      first_group || second_group
    end

    # Internal: Removes unnecessary dashes from the begining and the end of the string.
    #
    # string - A String possibly containing dashes at the beggining or the end
    #
    # Examples
    #
    #   str = '--example-'
    #   trim_dashes str
    #   # => example
    #
    # Returns a string without leading and ending dashes.
    def trim_dashes(string)
      string.gsub! /^-+/, ''
      string.gsub! /-+$/, ''

      string
    end
  end
end