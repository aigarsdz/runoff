require 'sequel'
require 'set'

module Runoff
  class Composition
    attr_reader :exported_filenames

    def initialize(main_db_file_path)
      unless File.exists? main_db_file_path
        raise IOError, "File doesn't exist"
      end

      skype_database = Sequel.connect "sqlite://#{main_db_file_path}"
      @messages = skype_database.from :Messages
      @exported_filenames = Set.new
    end

    def export(destination_path)
      chat_records = @messages.select(:chatname, :timestamp, :from_dispname, :body_xml)

      chat_records.each { |record| save_to_file record, destination_path }

      @exported_filenames.count
    end

    private
    def save_to_file(chat_record, output_directory)
      datetime = Time.at chat_record[:timestamp]
      output_record = "[#{datetime.to_date}] #{chat_record[:from_dispname]}: #{chat_record[:body_xml]}"
      filename = "#{output_directory}/#{parse_chatname chat_record[:chatname]}"

      File.open(filename, 'a') do |file|
        file.puts output_record
      end

      @exported_filenames << filename

    rescue StandardError => e
      puts e
    end

    def parse_chatname(raw_chatname)
      if match = raw_chatname.match(/#(.+)\/\$(.+);/)
        first_part, second_part = match.captures

        "#{first_part}-#{second_part}.txt"
      else
        raise StandardError, "Skipping #{raw_chatname}: Chatname in a wrong format"
      end
    end
  end
end