require 'sequel'
require 'set'

module Runoff
  # Public: Reads data from the SQLite database used by Skype/
  class Chat

    # Public: Initializes a Chat object.
    #
    # db_location - A String with a path to the database file.
    def initialize(db_location, options)
      @messages = Sequel.sqlite(db_location)[Runoff::TABLE]
      @adapter  = Object.const_get("Runoff::Adapters::#{options[:adapter]}").new
    end

    # Public: Returns a list of all the records in the databse.
    def get_messages
      @messages.select(*Runoff::COLUMNS).all.sort_by do |row|
        [row[Runoff::COLUMNS[0]], row[Runoff::COLUMNS[2]]]
      end
    end

    # Public: Creates a collection with all chats available for export.
    #
    # Returns a Set with hashes e.g. [{ id: 12, name: "chatname" }, ... ]
    def get_chatname_options
      options = Set.new

      @messages.select(*Runoff::COLUMNS[0..1]).each do |row|
        readable_name = @adapter.parse_chatname row[Runoff::COLUMNS[1]]

        options << { id: row[Runoff::COLUMNS[0]], name: readable_name }
      end

      options
    end
  end
end
