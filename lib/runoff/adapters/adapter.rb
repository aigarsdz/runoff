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
    end
  end
end
