require 'minitest/autorun'
require 'runoff/commandline/some'
require 'colorize'
require 'fileutils'

class CommandSomeTest < MiniTest::Unit::TestCase
  def test_it_raises_a_ArgumentError_if_called_with_an_empty_list_of_arguments
    command = Runoff::Commandline::Some.new( archive: true )

    assert_raises ArgumentError do
      assert_output 'Exporting...' do
        command.execute []
      end
    end
  end
end
