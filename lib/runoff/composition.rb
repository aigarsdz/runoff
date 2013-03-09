require 'sequel'

module Runoff
  class Composition
    def initialize(main_db_file_path)
      unless File.exists? main_db_file_path
        raise IOError, "File doesn't exist"
      end

      skype_database = Sequel.connect "sqlite://#{main_db_file_path}"
      @messages = @skype_database.from :Messages
    end

    def export(destination_path)
      chat_records = @messages.select(:chatname, :timestamp, :from_dispname, :body_xml)

      chat_records.each &method(:save_to_file)
    end

    private
    def save_to_file(chat_record)
      datetime = Time.at chat_record[:timestamp]
      output_record = "[#{datetime.to_date}] #{chat_record[:from_dispname]}: #{chat_record[:body_xml]}"
      filename = parse_chatname chat_record[:chatname]
    end

    def parse_chatname(raw_chatname)

    end
  end
end