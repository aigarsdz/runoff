module Runoff
  class RunoffLocation
    def self.default_skype_data_location(host_username, skype_username)
      if RbConfig::CONFIG['host_os'] =~ /mingw/
        "C:\\Users\\#{host_username}\\AppData\\Roaming\\Skype\\#{skype_username}\\main.db"
      elsif RbConfig::CONFIG['host_os'] =~ /linux/
        # TODO: return Linux path
        "~/.Skype"
      else
        # TODO: return Mac OS path
        "~/Library/Application Support/Skype"
      end
    end
  end
end