require 'minitest/spec'
require 'minitest/autorun'
require 'runoff'

describe Runoff::Location do
  describe '.default_skype_data_location' do
    it "must return a default path depending on the operating system" do
      path = Runoff::Location.default_skype_data_location 'aidzis_skype'

      if RbConfig::CONFIG['host_os'] =~ /mingw/
        path.must_match /[A-Z]:\\Users\\[a-zA-Z0-9]+\\AppData\\Roaming\\Skype\\aidzis_skype\\main\.db/
      elsif RbConfig::CONFIG['host_os'] =~ /linux/
        path.must_match /\/home\/[a-zA-Z0-9]+\/\.Skype\/aidzis_skype\/main\.db/
      else
        path.must_match /~\/Library\/Application Support\/Skype\/aidzis_skype\/main\.db/
      end
    end
  end

  describe ".home_path" do
    it "must return a path to the user home directory depending on the operating system" do
      path = Runoff::Location.home_path

      if RbConfig::CONFIG['host_os'] =~ /mingw/
        path.must_match /[A-Z]:\\Users\\[a-zA-Z0-9]+/
      else
        path.must_match /\/home\/[a-zA-Z0-9]+/
      end
    end
  end
end