module Runoff
  # Defines methods to hide the specific format that is used in the Skype database.
  class SkypeDataFormat
    # Public: Defines what kind of information can be queried from the database.
    #
    # Example
    #
    #   get_schema do |table, columns|
    #     # SELSECT *columns FROM table
    #   end
    #
    #   get_schema
    #   # => { table: :Messages, columns: [:chatname, :timestamp, :from_dispname, :body_xml] }
    #
    # Returns a hash with keys "table" and "columns" if no block is given.
    def get_schema
      if block_given?
        yield :Messages, [:chatname, :timestamp, :from_dispname, :body_xml]
      else
        return {
          table: :Messages,
          columns: [:chatname, :timestamp, :from_dispname, :body_xml]
        }
      end
    end

    # Public: Provides a filename and the data that should be written to the file.
    #
    # fields - an array representing a single entry in the database.
    #
    # Examples
    #
    #   build_entry {
    #     chatname: "#john/$doe;1243435",
    #     from_dispname: "John",
    #     body_xml: "Lorem ipsum",
    #     timestamp: 12435463
    #   } # => { filename: john-doe.txt, content: "[2013-12-27 12:23:43] John: Lorem ipsum" }
    #
    # Returns a hash with "filename" and "content" keys.
    def build_entry(fields)
      chatname = fields[:chatname]
      username = fields[:from_dispname]
      message  = fields[:body_xml]
      datetime = Time.at(fields[:timestamp]).strftime "%Y-%m-%d %H:%M:%S"

      {
        filename: get_filename(chatname),
        content: "[#{datetime}] #{username}: #{message}\n"
      }
    end

    private

    # Internal: Parses a string into a valid file name.
    #
    # chatname - a string that must be converted into a valid filename.
    #
    # Examples
    #
    #   get_filename "#john/$doe;2354657"
    #   # => john-doe.txt
    #
    # Returns a string that can be used as a file name.
    def get_filename(chatname)
      pattern = /^#(.+)\/\$(.+)?;.*$/
      initiator, respondent = chatname.match(pattern).captures

      "#{initiator}-#{respondent}".gsub(/(^-+|-+$)/, '') + ".txt"
    end
  end
end
