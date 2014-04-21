module Runoff
  # Public: Handles the data format used by Skype.
  class SkypeDataFormat
    # Public: A format String used to build a single entry.
    ENTRY_FORMAT = "[%s] %s: %s"

    # Public: Builds a single entry.
    #
    # row - An Array containing a single row of data from the database.
    #
    # Examples
    #
    #   build_entry { chatname: "#first_user/$second_user;d3d86c6b0e3b8320" ... }
    #   # => "[2014-04-18 20:20:12] first_user: This is a text"
    def build_entry(row)
      formated_data = []

      # NOTE: The first column in the array is used for the grouping by id and
      # the second is used for the filename.
      Runoff::COLUMNS[2..-1].each do |column|
        formated_data << send("format_#{column}", row[column])
      end

      ENTRY_FORMAT % formated_data
    end

    # Internal: Parses a chatname into a human readable name.
    #
    # raw_chatname - A String with a Skype chatname.
    #
    # Examples
    #
    #   get_file_name "#first_user/$second_user;d3d86c6b0e3b8320"
    #   # => first_user_second_user
    #
    # Returns a valid name.
    def parse_chatname(raw_chatname)
      pattern = /^#(.*)\/\$(.*);.*$/
      parts = raw_chatname.match(pattern).captures

      parts.reject(&:empty?).join('_')
    end

    private

    # Internal: Converts a Unix timestamp to a datetime string.
    #
    # timestamp - An integer with a Unix timestamp value.
    #
    # Examples
    #
    #   format_timestamp 1397852412
    #   # => "2014-18-04 20:20:12"
    #
    # Returns a datetime string in a format of YYY-DD-MM HH:MM::SS
    def format_timestamp(timestamp)
      Time.at(timestamp).strftime '%Y-%m-%d %H:%M:%S'
    end

    # Internal: Skip.
    def format_from_dispname(dispname)
      dispname
    end

    # Internal: Skip.
    def format_body_xml(xml_content)
      xml_content
    end
  end
end
