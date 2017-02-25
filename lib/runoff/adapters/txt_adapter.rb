module Runoff
  module Adapters
    class TxtAdapter < Adapter
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
      #
      # Returns a string
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
      #   # => first_user_second_user.txt
      #
      #   get_file_name "19:g7f8hg76f8g9d6f5ghj4357346@thread.skype"
      #   #=> g7f8hg76f8g9d6f5ghj4357346.txt
      #
      #   get_file_name "john_doe"
      #   #=> john_doe.txt
      #
      # Returns a valid file name.
      def get_file_name(chatname)
        parse_chatname(chatname) + '.txt'
      end

      # Public: Formats the provided data buffer so that it could be writter to
      #         a text file.
      #
      # buffer - An Array containing all the chat entries.
      #
      # Returns a String
      def format_file_content(buffer)
        buffer.join("\n")
      end
    end
  end
end
