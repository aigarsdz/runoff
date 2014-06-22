require 'minitest/autorun'
require 'runoff/commandline/some'
require 'colorize'
require 'fileutils'

class CommandSomeTest < MiniTest::Unit::TestCase
  def setup
    @current_directory      = File.expand_path(File.dirname(__FILE__))

    @default_output_dir     = "#@current_directory/data"
    @test_database_location = "#@current_directory/data/test_main.db"
    @expected_message       = 'Exporting...'.colorize(:green) + "\n" + 'Finished.'.colorize(:green) + "\n"
  end

  def teardown
    Dir["#@default_output_dir/*"].each do |f|
      if File.extname(f) == '.zip'
        File.delete f
      elsif File.directory?(f) && f !~ /custom_location/
        FileUtils.rm_rf f
      end
    end
  end

  def test_it_raises_a_ArgumentError_if_called_with_an_empty_list_of_arguments
    command = Runoff::Commandline::Some.new( archive: true )

    assert_raises ArgumentError do
      assert_output 'Exporting...' do
        command.execute []
      end
    end
  end

  def test_it_exports_specified_chat_history_as_a_zip_archive_and_saves_it_in_the_default_location
    command     = Runoff::Commandline::Some.new( archive: true )
    ENV['HOME'] = @default_output_dir

    Runoff::Location.stub :default_skype_data_location, @test_database_location do
      assert_output @expected_message do
        command.stub :prompt_for_chatnames, [1] do
          command.execute ['white_mike']
        end
      end
    end

    assert_equal 1, Dir["#@default_output_dir/*.zip"].count
  end
end
