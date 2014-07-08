require 'json'

module Runoff
  module Adapters
    class JsonAdapter < Adapter
      # Public: A format String used to build a single entry.
      ENTRY_FORMAT = '{ "date": "%s", "user": "%s", "message": %s }'

      # Public: Builds a single entry.
      #
      # row - An Array containing a single row of data from the database.
      #
      # Examples
      #
      #   build_entry { chatname: "#first_user/$second_user;d3d86c6b0e3b8320" ... }
      #   # => "{ "date": "2014-04-18 20:20:12", "user": "first_user", "message": "This is a text" }"
      def build_entry(row)
        formated_data = []

        # NOTE: The first column in the array is used for the grouping by id and
        # the second is used for the filename.
        Runoff::COLUMNS[2..-1].each do |column|
          formated_data << send("format_#{column}", row[column])
        end

        ENTRY_FORMAT % formated_data
      end

      # Public: returns a file name.
      #
      # chatname - A String with a Skype chatname
      #
      # Examples
      #
      #   get_file_name "#first_user/$second_user;d3d86c6b0e3b8320"
      #   # => first_user_second_user.json
      #
      # Returns a valid file name.
      def get_file_name(chatname)
        parse_chatname(chatname) + '.json'
      end

      # Public: Parses a chatname into a human readable name.
      #
      # raw_chatname - A String with a Skype chatname.
      #
      # Examples
      #
      #   parse_chatname "#first_user/$second_user;d3d86c6b0e3b8320"
      #   # => first_user_second_user
      #
      # Returns a valid name.
      def parse_chatname(raw_chatname)
        pattern = /^#(.*)\/\$(.*);.*$/
        parts = raw_chatname.match(pattern).captures

        parts.reject(&:empty?).join('_')
      end

      # Public: Formats the provided data buffer so that it could be writter to
      #         a JSON file.
      #
      # buffer - An Array containing all the chat entries.
      #
      # Returns a String
      def format_file_content(buffer)
        content = buffer.join(",\n")

        "[#{content}]"
      end

      protected

      # Internal: Escapes the message body so that it could be used in a JSON string
      #
      # xml_content - A String containing the chat message
      #
      # Examples
      #
      #   format_body_xml 'foo' # => "\"foo\""
      #
      # Returns a String
      def format_body_xml(xml_content)
        JSON.generate(xml_content, quirks_mode: true)
      end
    end
  end
end
