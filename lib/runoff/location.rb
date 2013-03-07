module Runoff
  class Location
    def self.default_skype_data_location(skype_username)
      if RbConfig::CONFIG['host_os'] =~ /mingw/
        "#{ENV['APPDATA']}\\Skype\\#{skype_username}\\main.db"
      elsif RbConfig::CONFIG['host_os'] =~ /linux/
        "#{ENV['HOME']}/.Skype/#{skype_username}/main.db"
      else
        "~/Library/Application Support/Skype/#{skype_username}/main.db"
      end
    end
  end
end