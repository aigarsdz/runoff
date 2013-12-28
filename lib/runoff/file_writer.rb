module Runoff
  class FileWriter
    def initialize(db_handler)
      @db_handler = db_handler
    end

    # Public: Exports data based on the provided data format to text files.
    #
    # data_format - an object that defines how the data should be parsed.
    #
    # Returns true if the operation succeeded or false if it failed.
    def export_database(data_format)
      schema  = data_format.get_schema
      dataset = @db_handler[schema[:table]]
      dataset = dataset.select(*schema[:columns])

      dataset.each do |row|
        write data_format.build_entry(row)
      end
    end

    private


    def write(entry)
      # TODO: write the entry to a file.
    end
  end
end
