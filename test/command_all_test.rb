require 'minitest/autorun'
require 'runoff/commandline/all'
require 'colorize'
require 'fileutils'

describe Runoff::Commandline::All, 'Export all chats' do
  before do
    @current_directory      = File.expand_path(File.dirname(__FILE__))

    @default_output_dir     = "#@current_directory/data"
    @test_database_location = "#@current_directory/data/test_main.db"
    @expected_message       = 'Exporting...'.colorize(:green) + "\n" + 'Finished.'.colorize(:green) + "\n"
  end

  it 'must raise a ArgumentError if called with an empty list of arguments' do
    command = Runoff::Commandline::All.new( archive: true )

    -> { -> { command.execute [] }.must_output 'Exporting...' }.must_raise ArgumentError
  end

  it 'must export all chat history as a Zip archive and save it in the default location' do
    command          = Runoff::Commandline::All.new( archive: true )
    ENV['HOME']      = @default_output_dir

    Runoff::Location.stub :default_skype_data_location, @test_database_location do
      -> { command.execute ['white_mike'] }.must_output @expected_message
    end

    Dir["#@default_output_dir/*.zip"].count.must_equal 1
  end

  it 'must export all chat history as a folder in the default location if a --no-archive option is provided' do
    command          = Runoff::Commandline::All.new( archive: false )
    ENV['HOME']      = @default_output_dir

    Runoff::Location.stub :default_skype_data_location, @test_database_location do
      -> { command.execute ['white_mike'] }.must_output @expected_message
    end

    Dir["#@default_output_dir/skype_chat_history"].count.must_equal 1
  end

  it 'must export all chat history as a Zip archive from a custom location and save it in the default location' do
    test_custom_database_location = "#@current_directory/data/custom_location/test_main.db"

    command          = Runoff::Commandline::All.new( archive: true, from: test_custom_database_location )
    ENV['HOME']      = @default_output_dir

    Runoff::Location.stub :default_skype_data_location, @test_database_location do
      -> { command.execute ['white_mike'] }.must_output @expected_message
    end

    Dir["#@default_output_dir/*.zip"].count.must_equal 1
  end

  it 'must export all chat history as a Zip archive and save it in a custom location' do
    custom_output_location = "#@current_directory/data/custom_output_location"

    command          = Runoff::Commandline::All.new( archive: true, destination: custom_output_location )
    ENV['HOME']      = @default_output_dir

    Runoff::Location.stub :default_skype_data_location, @test_database_location do
      -> { command.execute ['white_mike'] }.must_output @expected_message
    end

    Dir["#@default_output_dir/custom_output_location/*.zip"].count.must_equal 1
  end

  after do
    Dir["#@default_output_dir/*"].each do |f|
      if File.extname(f) == '.zip'
        File.delete f
      elsif File.directory?(f) && f !~ /custom_location/
        FileUtils.rm_rf f
      end
    end
  end
end
