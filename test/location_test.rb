require 'minitest/autorun'
require 'minitest/unit'
require 'runoff'

class TestLocation < MiniTest::Unit::TestCase
  def test_must_return_a_default_path_depending_on_the_operating_system
    path = Runoff::Location.default_skype_data_location 'aidzis_skype'

    if RbConfig::CONFIG['host_os'] =~ /mingw/
      assert_match /\/Users\/[a-zA-Z0-9]+\/AppData\/Roaming\/Skype\/aidzis_skype\/main\.db/, path
    elsif RbConfig::CONFIG['host_os'] =~ /linux/
      assert_match /\/home\/[a-zA-Z0-9]+\/\.Skype\/aidzis_skype\/main\.db/, path
    else
      assert_match /~\/Library\/Application Support\/Skype\/aidzis_skype\/main\.db/, path
    end
  end
end