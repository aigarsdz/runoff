require 'zip'
require 'fileutils'

module Runoff
  # Public: Writes data received from the database to text files.
  class FileWriter
    # Public: Initializes a FileWriter object.
    #
    # options - A Hash with commandline options.
    def initialize(options)
      @export_path       = Location.get_export_path options
      @adapter           = Object.const_get("Runoff::Adapters::#{options[:adapter]}").new
      @current_file_name = nil
      @buffer            = []
    end

    # Public: Writes a single row of data to a text file.
    #
    # messages - An Array of data received from the database.
    #
    # Examples
    #
    #   write [{ chatname: "#first_user/$second_user;d3d86c6b0e3b8320" ... }, ...]
    def write(messages)
      messages.each_with_index do |m, i|
        file_name = @adapter.get_file_name m[Runoff::COLUMNS[1]]

        dump unless @current_file_name.nil? || @current_file_name == file_name

        @current_file_name = file_name

        @buffer << @adapter.build_entry(m)
        dump if i == (messages.count - 1)
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

    private

    # Internal: Dumps the content buffer to a file.
    def dump
      File.open("#{@export_path}/#@current_file_name", "w") do |file|
        file.puts @buffer.join("\n")
      end

      @buffer.clear
    end
  end
end
