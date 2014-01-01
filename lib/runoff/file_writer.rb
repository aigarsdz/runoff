require 'zip'
require 'fileutils'

module Runoff
  class FileWriter
    attr_accessor :selected_entries

    def initialize(db_handler)
      @db_handler = db_handler
      @selected_entries = []
    end

    # Public: Exports all the chats from the database.
    #
    # data_format - an object that defines how the data should be parsed.
    # export_path - a string that points to the directory where exported files must be saved.
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

    # Public: Exports specific chats from the database.
    #
    # data_format - an object that defines how the data should be parsed.
    # export_path - a string that points to the directory where exported files must be saved.
    def export_database_partially(data_format, export_path, create_archive, &block)
      @export_path = export_path

      schema  = data_format.get_schema
      dataset = @db_handler[schema[:table]]
      indices = block.call self, dataset
      clean_indices = indices.split(',').map { |e| e.strip }

      clean_indices.each do |i|
        chatname = @selected_entries[i.to_i]
        approximation = data_format.denormalize chatname
        dataset = @db_handler[schema[:table]]
        dataset = dataset.where(Sequel.like(:chatname, "#{approximation}%"))

        dataset.each { |row| write data_format.build_entry(row) }
      end

      archive unless create_archive == false
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
      zip_file_name = "#@export_path-#{Time.now.strftime "%Y%m%d%H%S%S"}.zip"

      Zip::File.open(zip_file_name, Zip::File::CREATE) do |zf|
        Dir[File.join(@export_path, '**', '**')].each do |f|
          zf.add(f.sub("#@export_path/", ''), f)
        end
      end

      # Delete the destination directory because it is no longer needed.
      FileUtils.rm_r @export_path
    end
  end
end
