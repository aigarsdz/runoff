require 'sequel'

module Runoff
  # Public: Reads data from the SQLite database used by Skype/
  class Chat
    include Enumerable # Not realy necessary at this point.

    # Public: Initializes a Chat object.
    #
    # db_location - A String with a path to the database file.
    def initialize(db_location)
      db_handler = Sequel.sqlite db_location
      @messages  = db_handler[Runoff::TABLE]
    end

    # Public: Iterates over all the records in the databse.
    #
    # Examples
    #
    #   each do |row|
    #     puts row[:chatname]
    #     puts row[:from_dispname]
    #   end
    def each
      @messages.select(*Runoff::COLUMNS).each { |row| yield row }
    end
  end
end
