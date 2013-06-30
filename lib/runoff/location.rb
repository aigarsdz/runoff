module Runoff

  # Public: Contains class methods for finding out the appropriate file paths.
  #
  # Examples
  #
  #   Location::default_skype_data_location skype_username
  #   # => /home/user/.Skype/skype_username/main.db
  class Location

    # Public: Composes the default Skype database location depending on the operating system.
    #
    # skype_username - A String that contains a username of the Skype account,
    #                  which database we want to access.
    #
    # Examples
    #
    #   On Linux:
    #   default_skype_data_location skype_username
    #   # => /home/user/.Skype/skype_username/mai.db
    #
    #   On Windows:
    #   default_skype_data_location skype_username
    #   # =>  /Users/user/AppData/Roaming/Skype/skype_username/main.db
    #
    # Returns a String that contains the path to the Skype database file.
    def self.default_skype_data_location(skype_username)
      if RbConfig::CONFIG['host_os'] =~ /mingw/
        location = "#{ENV['APPDATA']}\\Skype\\#{skype_username}\\main.db"

        unless File.exist?("#{ENV['APPDATA']}\\Skype")
          location = self.get_default_skype_data_location_on_windows_8 skype_username
        end

        location.gsub!(/\\/, '/')
        location.gsub(/^[a-zA-Z]:/, '')
      elsif RbConfig::CONFIG['host_os'] =~ /linux/
        "#{ENV['HOME']}/.Skype/#{skype_username}/main.db"
      else
        "#{ENV['HOME']}/Library/Application Support/Skype/#{skype_username}/main.db"
      end
    end

    private

    # Public: Composes the default Skype database location for the Windows 8 operating system.
    #
    # skype_username - A String that contains a username of the Skype account,
    #                  which database we want to access.
    #
    # Examples
    #
    #   get_default_skype_data_location_on_windows_8 skype_username
    #   # => C:/Users/user/AppData/Local/Packages/Microsoft.SkypeApp_sakjhds8asd/LocalState/skype_username/main.db
    #
    # Returns a String that contains the path to the Skype database file.
    def self.get_default_skype_data_location_on_windows_8(skype_username)
      location = "#{ENV['HOME']}/AppData/Local/Packages"

      Dir["#{location}/*"].each do |item|
        if item =~ /Microsoft\.SkypeApp/
          location = "#{item}/LocalState/#{skype_username}/main.db"
        end
      end

      location
    end
  end
end