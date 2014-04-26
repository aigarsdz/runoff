require 'minitest/autorun'
require 'runoff'

describe Runoff::Location do
  it 'must return the default Skype database location on Windows 8.1' do
    skype_username = 'skype_username'
    path = "/AppData/Local/Packages/Microsoft.SkypeApp_124nb4j3654/LocalState/#{skype_username}/main.db"

    Dir.stub :[], ['/AppData/Local/Packages/Microsoft.SkypeApp_124nb4j3654'] do
      Runoff::Location.get_default_skype_data_location_on_windows_8(skype_username)
                      .must_equal(path)
    end
  end

  it 'must convert a path string from Windows style to Unix style' do
    original_path = 'C:\Users\Neo\main.db'
    expected_path = '/Users/Neo/main.db'

    Runoff::Location.format_windows_path(original_path).must_equal(expected_path)
  end

  it 'must build a path for a directory, where the files are supposed to be saved, if the destination option is specified' do
    path    = '/Users/Neo/backups'
    options = { destination: path }

    File.stub :exist?, true do
      Runoff::Location.get_export_path(options).must_equal("#{path}/skype_chat_history")
    end
  end

  it 'must build a path for a directory, where the files are supposed to be saved, if the destination option is not specified' do
    options     = { destination: nil }
    ENV['HOME'] = '/Users/Neo'

    File.stub :exist?, true do
      Runoff::Location.get_export_path(options).must_equal("#{ENV['HOME']}/skype_chat_history")
    end
  end

  it 'must return the default Skype database location for Windows Desktop app' do
    RbConfig::CONFIG['host_os'] = 'mingw'
    ENV['APPDATA'] = 'C:\Users\Neo\AppData\Roaming'

    skype_username = 'skype_username'
    expected_path  = "/Users/Neo/AppData/Roaming/Skype/#{skype_username}/main.db"

    File.stub :exist?, true do
      Runoff::Location.default_skype_data_location(skype_username).must_equal(expected_path)
    end
  end

  it 'must return the default Skype database location on Linux' do
    RbConfig::CONFIG['host_os'] = 'linux'
    ENV['HOME'] = '/home/Neo'

    skype_username = 'skype_username'
    expected_path = "#{ENV['HOME']}/.Skype/#{skype_username}/main.db"

    Runoff::Location.default_skype_data_location(skype_username).must_equal(expected_path)
  end

  it 'must return the default Skype database location on Mac OS' do
    RbConfig::CONFIG['host_os'] = 'darvin'
    ENV['HOME'] = '/Users/Neo'

    skype_username = 'skype_username'
    expected_path = "#{ENV['HOME']}/Library/Application Support/Skype/#{skype_username}/main.db"

    Runoff::Location.default_skype_data_location(skype_username).must_equal(expected_path)
  end

  it 'must return the path that are specified in the from option' do
    path    = '/Users/Neo/Desktop/main.db'
    options = { from: path }

    Runoff::Location.get_database_path('Neo', options).must_equal(path)
  end
end
