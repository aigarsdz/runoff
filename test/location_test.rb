require 'minitest/autorun'
require 'minitest/unit'
require 'runoff'

class TestLocation < MiniTest::Test
  def test_must_return_a_default_path_depending_on_the_operating_system
    path = Runoff::Location.default_skype_data_location 'aidzis_skype'

    if RbConfig::CONFIG['host_os'] =~ /mingw/
      skip
      if File.exist?("#{ENV['APPDATA']}\\Skype")
        assert_match /\/Users\/[a-zA-Z0-9]+\/AppData\/Roaming\/Skype\/aidzis_skype\/main\.db/, path
      else
        assert_match /\/Users\/[a-zA-Z0-9]+\/AppData\/Local\/Packages\/[a-zA-Z0-9_\/\.]+\/aidzis_skype\/main\.db/, path
      end
    elsif RbConfig::CONFIG['host_os'] =~ /linux/
      assert_match /\/home\/[a-zA-Z0-9]+\/\.Skype\/aidzis_skype\/main\.db/, path
    else
      assert_match /~\/Library\/Application Support\/Skype\/aidzis_skype\/main\.db/, path
    end
  end

  def test_must_replace_backslashes_with_forward_slashes_and_remowe_drive_letter
    windows_path = 'C:\\Users\\user\\AppData\\Roaming\\Skype'
    unix_style_path = Runoff::Location.send :format_windows_path, windows_path

    assert_equal '/Users/user/AppData/Roaming/Skype', unix_style_path
  end
end