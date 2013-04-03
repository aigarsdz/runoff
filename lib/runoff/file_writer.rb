module Runoff
  # Public: Methods used for writing to files.
  module FileWriter
    # Public: Saves a single chat message to a file.
    #
    # chat_record - a Hash containing data about a single chat message.
    # output_directory - A String with the path to the directory, wher the file will be saved.
    #
    # Examples
    #
    #   save_to_file record, '/home/username/skype_backup'
    def save_to_file(chat_record, output_directory)
      datetime = Time.at chat_record[:timestamp]
      output_record = "[#{datetime.to_date}] #{chat_record[:from_dispname]}: #{chat_record[:body_xml]}"
      filename = "#{output_directory}/#{parse_chatname chat_record[:chatname]}.txt"

      File.open(filename, 'a') do |file|
        file.puts output_record
      end

      filename
    rescue StandardError
      puts 'An error occured while parsing a chatname'
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
      string = string.gsub /^-+/, ''
      string.gsub /-+$/, ''
    end
  end
end