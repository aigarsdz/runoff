require 'zip/zip'
require 'fileutils'

module Runoff
  # Public: Methods used for writing to files.
  class FileWriter
    # Public: Initialize a FileWriter object.
    #
    # format - An object containing necessary methods for data formating.
    def initialize(format)
      @format = format
    end
    # Public: Saves a single chat message to a file.
    #
    # record - a Hash containing data about a single chat message.
    # output_directory - A String with the path to the directory, wher the file will be saved.
    #
    # Examples
    #
    #   save_to_file record, '/home/username/skype_backup'
    def save_to_file(record, output_directory)
      filename = "#{output_directory}/#{@format.get_filename(record)}"

      Dir.mkdir(output_directory) unless File.exists?(output_directory)
      File.open(filename, 'a') do |file|
        file.puts @format.build_entry(record)
      end

      filename
    end

    # Public: Compresses all the exported files into a Zip archive.
    #
    # output_directory - A String with the path to the directory, wher the file will be saved.
    #
    # Examples
    #
    #   archive '/home/username/skype-backup'
    def self.archive(output_directory)
      timestamp = Time.now.strftime "%Y%m%d%H%M%S"

      Zip::ZipFile.open "#{output_directory}-#{timestamp}.zip", Zip::ZipFile::CREATE do |zipfile|
        Dir.entries(output_directory).each do |file|
          if File.file?("#{output_directory}/#{file}")
            zipfile.add file, "#{output_directory}/#{file}"
          end
        end
      end

      FileUtils.rm_rf output_directory
    end
  end
end
