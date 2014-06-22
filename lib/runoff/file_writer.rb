require 'zip'
require 'fileutils'

module Runoff
  # Public: Writes data received from the database to text files.
  class FileWriter
    # Public: Initializes a FileWriter object.
    #
    # options - A Hash with commandline options.
    def initialize(options)
      @export_path = Location.get_export_path options
      @adapter     = Object.const_get("Runoff::Adapters::#{options[:adapter]}").new
    end

    # Public: Writes a single row of data to a text file.
    #
    # row - A Has of data received from the database.
    #
    # Examples
    #
    #   write { chatname: "#first_user/$second_user;d3d86c6b0e3b8320" ... }
    def write(row)
      file_name    = @adapter.get_file_name row[Runoff::COLUMNS[1]]

      File.open("#{@export_path}/#{file_name}", "a+") do |file|
        file.puts @adapter.build_entry(row)
      end
    end

    # Public: Saves all the exported files in a Zip archive.
    def archive
      archive_name = "#{@export_path}_#{Time.now.to_i}.zip"

      Zip::File.open archive_name, Zip::File::CREATE do |archive|
        Dir[File.join(@export_path, '**', '**')].each do |file|
          archive.add File.basename(file), file
        end
      end

      FileUtils.rm_rf @export_path # Delete the folder.
    end
  end
end
