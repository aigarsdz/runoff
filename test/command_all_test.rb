require 'minitest/autorun'
require 'runoff/commandline/all'
require 'colorize'
require 'fileutils'

class CommandAllTest < MiniTest::Unit::TestCase
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
    command = Runoff::Commandline::All.new( archive: true )

    assert_raises ArgumentError do
      assert_output 'Exporting...' do
        command.execute []
      end
    end
  end

  def test_it_exports_all_chat_history_as_a_zip_archive_and_saves_it_in_the_default_location
    command     = Runoff::Commandline::All.new( archive: true )
    ENV['HOME'] = @default_output_dir

    Runoff::Location.stub :default_skype_data_location, @test_database_location do
      assert_output @expected_message do
        command.execute ['white_mike']
      end
    end

    assert_equal 1, Dir["#@default_output_dir/*.zip"].count
  end

  def test_it_exports_all_chat_history_as_a_folder_in_the_default_location_if_a_no_archive_option_is_set
    command     = Runoff::Commandline::All.new( archive: false )
    ENV['HOME'] = @default_output_dir

    Runoff::Location.stub :default_skype_data_location, @test_database_location do
      assert_output @expected_message do
        command.execute ['white_mike']
      end
    end

    assert_equal 1, Dir["#@default_output_dir/skype_chat_history"].count;
  end

  def test_it_exports_all_chat_history_as_a_zip_archive_from_a_custom_location_and_saves_it_in_the_default_location
    test_custom_database_location = "#@current_directory/data/custom_location/test_main.db"

    command     = Runoff::Commandline::All.new( archive: true, from: test_custom_database_location )
    ENV['HOME'] = @default_output_dir

    Runoff::Location.stub :default_skype_data_location, @test_database_location do
      assert_output @expected_message do
        command.execute ['white_mike']
      end
    end

    assert_equal 1, Dir["#@default_output_dir/*.zip"].count
  end

  def test_it_exports_all_chat_history_as_a_zip_archive_and_saves_it_in_a_custom_location
    custom_output_location = "#@current_directory/data/custom_output_location"

    command          = Runoff::Commandline::All.new( archive: true, destination: custom_output_location )
    ENV['HOME']      = @default_output_dir

    Runoff::Location.stub :default_skype_data_location, @test_database_location do
      assert_output @expected_message do
        command.execute ['white_mike']
      end
    end

    assert_equal 1, Dir["#@default_output_dir/custom_output_location/*.zip"].count
  end
end
