module Runoff
  class FileWriter
    def initialize(db_handler)
      @db_handler = db_handler
    end

    # Public: Exports data based on the provided data format to text files.
    #
    # data_format - An object that defines how the data should be parsed.
    #
    # Returns true if the operation succeeded or false if it failed.
    def export_database(data_format)
      data_format.get_schema do |table, columns, format_string|
        dataset = @db_handler[table]
        dataset = dataset.select(*columns)

        write dataset
      end
    end

    private

    def write(dataset)
      # TODO: Iterate through each DB row and write the content to files.
    end
  end
end
