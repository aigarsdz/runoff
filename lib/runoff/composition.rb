module Runoff
  class Composition
    def initialize(main_db_file_path)
      unless File.exists? main_db_file_path
        raise IOError.new "File doesn't exist"
      end

      @main_db_file_path = main_db_file_path
    end

    def export(destination_path)
      #TODO: export Skype chat history
    end
  end
end