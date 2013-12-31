require 'zip'

module Runoff
  class FileWriter
    attr_accessor :selected_entries

    def initialize(db_handler)
      @db_handler = db_handler
      @selected_entries = []
    end

    # Public: Exports data based on the provided data format to text files.
    #
    # data_format - an object that defines how the data should be parsed.
    # export_path - a string that points to the directory where exported files must be saved.
    #
    # Returns true if the operation succeeded or false if it failed.
    def export_database(data_format, export_path, create_archive)
      @export_path = export_path

      schema  = data_format.get_schema
      dataset = @db_handler[schema[:table]]
      dataset = dataset.select(*schema[:columns])

      dataset.each do |row|
        write data_format.build_entry(row)
      end

      archive unless create_archive == false
    end

    def export_database_partially(data_format, export_path, create_archive, &block)
      @export_path = export_path

      schema  = data_format.get_schema
      dataset = @db_handler[schema[:table]]
      indices = block.call self, dataset

      # TODO: export chats based on the provided chat name indices.
    end

    private

    # Internal: Appends a new entry to a file.
    #
    # entry - a hash containing "filename" and "content" keys.
    #
    # Examples
    #
    #   write { filename: "test.txt", content: "test content" }
    def write(entry)
      path = "#@export_path/#{entry[:filename]}"

      File.open(path, "a+") { |file| file.write entry[:content] }
    end

    # Internal: Creates a Zip file of the destination directory.
    def archive
      zip_file_name = "#@export_path.zip"

      Zip::File.open(zip_file_name, Zip::File::CREATE) do |zf|
        Dir[File.join(@export_path, '**', '**')].each do |f|
          zf.add(f.sub("#@export_path/", ''), f)
        end
      end
    end
  end
end
