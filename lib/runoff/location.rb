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

        location.gsub! /\\/, '/'
        location.gsub /^[a-zA-Z]:/, ''
      elsif RbConfig::CONFIG['host_os'] =~ /linux/
        "#{ENV['HOME']}/.Skype/#{skype_username}/main.db"
      else
        "#{ENV['HOME']}/Library/Application Support/Skype/#{skype_username}/main.db"
      end
    end

    # Public: Clarifies the path to the user's home directory depending on the operating system
    #
    # Examples
    #
    #   On Linux:
    #   home_path
    #   # => /home/user
    #
    #   On Windows:
    #   home_path
    #   # => C:\Users\user
    #
    # Returns a String that contains the path to the user's home directory.
    def self.home_path
      if RbConfig::CONFIG['host_os'] =~ /mingw/
        ENV['USERPROFILE']
      else
        ENV['HOME']
      end
    end
  end
end