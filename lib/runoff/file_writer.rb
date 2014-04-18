require 'zip'
require 'fileutils'

module Runoff
  class FileWriter
    def initialize(options)
      @options = options
    end

    def write(row)
      export_path = Location.get_export_path @options
      file_name   = get_file_name row[Runoff::COLUMNS[0]]
      format = SkypeDataFormat.new

      File.open("#{export_path}/#{file_name}", "a+") do |file|
        file.puts format.build_entry(row)
      end
    end

    private

    def get_file_name(chatname)
      pattern = /^#(.*)\/\$(.*);.*$/
      parts = chatname.match(pattern).captures

      parts.reject(&:empty?).join('-') + '.txt'
    end
  end
end
