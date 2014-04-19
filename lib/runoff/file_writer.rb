require 'zip'
require 'fileutils'

module Runoff
  # Public: Writes data received from the database to text files.
  class FileWriter
    # Public: Initializes a FileWriter object.
    #
    # options - A Hash with commandline options.
    def initialize(options)
      @options = options
    end

    # Public: Writes a single row of data to a text file.
    #
    # row - A Has of data received from the database.
    #
    # Examples
    #
    #   write { chatname: "#first_user/$second_user;d3d86c6b0e3b8320" ... }
    def write(row)
      @export_path = Location.get_export_path @options
      file_name   = get_file_name row[Runoff::COLUMNS[0]]
      format      = SkypeDataFormat.new

      File.open("#{@export_path}/#{file_name}", "a+") do |file|
        file.puts format.build_entry(row)
      end
    end

    # Public: Puts all the exported files in a Zip archive
    def archive
      archive_name = "#{@export_path}_#{Time.now.to_i}.zip"

      Zip::File.open archive_name, Zip::File::CREATE do |archive|
        Dir[File.join(@export_path, '**', '**')].each do |file|
          archive.add File.basename(file), file
        end
      end

      FileUtils.rm_rf @export_path
    end

    private

    # Internal: Parses a chatname into a valid file name.
    #
    # chatname - A String with a Skype chatname.
    #
    # Examples
    #
    #   get_file_name "#first_user/$second_user;d3d86c6b0e3b8320"
    #   # => first_user_second_user.txt
    #
    # Returns a valud file name.
    def get_file_name(chatname)
      pattern = /^#(.*)\/\$(.*);.*$/
      parts = chatname.match(pattern).captures

      parts.reject(&:empty?).join('_') + '.txt'
    end
  end
end
