require 'sequel'
require 'set'

module Runoff
  # Provides interaction with a Skype database file.
  class Composition
    # Public: Initialize a Composition object.
    #
    # main_db_file_path - A String with the path to the Skype database file.
    #
    # Raises IOError if the file cannot be found
    def initialize(main_db_file_path)
      raise IOError, "File doesn't exist" unless File.exists? main_db_file_path

      skype_database = Sequel.sqlite main_db_file_path
    end
  end
end
