module Runoff
  # Public: Deals with Skype specific formats.
  class SkypeDataFormat
    #Public: Builds an appropriate filename.
    #
    # chat_record - A Hash containing necessary data.
    #
    # Examples
    #
    #   get_filename { chatname: 'demo-chat' }
    #   # => demo-chat.txt
    #
    # Retruns a filename as a String.
    def get_filename(chat_record)
      "#{parse_chatname chat_record[:chatname]}.txt"
    end

    # Public: Creates a String with one entry from the chat.
    #
    # chat_record - a Hash containing data about a single chat message.
    #
    # Examples
    #
    #   build_entry { timestamp: 213213232, from_dispname: 'aidzis', body_xml: 'This is text.' }
    #   # => [2013-04-13 14:23:57] aidzis: This is text.
    #
    # Returns a String with a chat entry.
    def build_entry(chat_record)
      datetime = Time.at chat_record[:timestamp]
      output_record = "[#{datetime.strftime "%Y-%m-%d %H:%M:%S"}] "
      output_record << "#{chat_record[:from_dispname]}: #{parse_body_xml chat_record[:body_xml]}"

      output_record
    rescue StandardError
    end

    # Public: Converts chatname from database to a valid file name.
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

    # Public: Removes extra characters from the end of a chatname.
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

    private
    # Internal: Remove Skype emotion tags.
    #
    # text - String containing XML data
    #
    # Examples
    #
    #   parse_body_xml "Some text <ss type="laugh">:D</ss>"
    #   # => "Some text :D"
    #
    # Returns the duplicated String.
    def parse_body_xml(text)
      clean_text = text.gsub(/<ss type=".+">/, '')
      clean_text.gsub(/<\/ss>/, '')
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
      clean_string = string.gsub(/^-+/, '')
      clean_string.gsub(/-+$/, '')
    end
  end
end