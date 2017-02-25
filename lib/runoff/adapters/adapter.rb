module Runoff
  module Adapters
    class Adapter
      protected

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

      # Public: Parses a chatname into a human readable name.
      #
      # raw_chatname - A String with a Skype chatname.
      #
      # Examples
      #
      #   parse_chatname "#first_user/$second_user;d3d86c6b0e3b8320"
      #   #=> first_user_second_user
      #
      #   parse_chatname "19:g7f8hg76f8g9d6f5ghj4357346@thread.skype"
      #   #=> g7f8hg76f8g9d6f5ghj4357346
      #
      #   parse_chatname "john_doe"
      #   #=> john_doe
      #
      # Returns a valid name.
      def parse_chatname(raw_chatname)
        case raw_chatname
        when /\:(?<hash>.+)@/
          $~[:hash]
        when /#(?<first_participant>.*)\/\$(?<second_participant>.*);/
          first_participant  = $~[:first_participant]
          second_participant = $~[:second_participant]

          [first_participant, second_participant].reject(&:empty?).join('_')
        else
          raw_chatname
        end
      end
    end
  end
end
