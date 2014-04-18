module Runoff
  # Defines methods to hide the specific format that is used in the Skype database.
  class SkypeDataFormat
    ENTRY_FORMAT = "[%s] %s: %s"

    def build_entry(row)
      formated_data = []

      Runoff::COLUMNS[1..-1].each do |column|
        formated_data << send("format_#{column}", row[column])
      end

      ENTRY_FORMAT % formated_data
    end

    private

    def format_timestamp(timestamp)
      Time.at(timestamp).strftime '%Y-%m-%d %H:%M:%S'
    end

    def format_from_dispname(dispname)
      dispname
    end

    def format_body_xml(xml_content)
      xml_content
    end
  end
end
