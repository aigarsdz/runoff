require 'minitest/autorun'
require 'minitest/unit'
require 'runoff'

class TestChat < MiniTest::Test
  def test_must_output_an_error_message_if_no_username_or_from_option_is_procided
    assert_output "You must specify a username or a --from option\n" do
      Runoff::Commands::Chat.process []
    end
  end
end