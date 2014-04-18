require 'sequel'

module Runoff
  class Chat
    include Enumerable

    def initialize(db_location)
      db_handler = Sequel.sqlite db_location
      @messages  = db_handler[Runoff::TABLE]
    end

    def each
      @messages.select(*Runoff::COLUMNS).each { |row| yield row }
    end
  end
end
