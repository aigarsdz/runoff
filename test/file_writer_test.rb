require 'minitest/autorun'
require 'minitest/unit'
require 'runoff'
require 'fileutils'

class TestFileWriter < MiniTest::Unit::TestCase
  def setup
    @incorrect_chat_record = {
      chatname: '#john/$;521357125362',
      timestamp: 1366280218,
      from_dispname: 'John',
      body_xml: 'This is a text'
    }

    @chat_record = {
      chatname: '#braun/$drake;521357125362',
      timestamp: 1366280218,
      from_dispname: 'Braun',
      body_xml: 'This is a text.'
    }

    correct_format = get_correct_format_mock
    @correct_file_writer = Runoff::FileWriter.new correct_format
    incorrect_format = get_incorrect_format_mock
    @incorrect_file_writer = Runoff::FileWriter.new incorrect_format
  end

  def teardown
    FileUtils.rm_rf 'test/tmp'

    Dir.glob('test/*.zip').each do |archive|
      File.delete archive
    end
  end

  def test_must_write_chat_content_to_file
    @correct_file_writer.save_to_file @chat_record, 'test/tmp'
    @incorrect_file_writer.save_to_file @incorrect_chat_record, 'test/tmp'

    assert_equal 2, Dir['test/tmp/*.txt'].count
  end

  def test_must_append_to_a_file_if_the_filename_already_exists
    @additional_chat_record = @chat_record

    @correct_file_writer.save_to_file @chat_record, 'test/tmp'
    @incorrect_file_writer.save_to_file @incorrect_chat_record, 'test/tmp'
    @correct_file_writer.save_to_file @additional_chat_record, 'test/tmp'

    assert_equal 2, Dir['test/tmp/*.txt'].count
  end

  def test_must_create_a_zip_file_of_the_destination_directory
    output_directory = 'test/tmp'
    files = %w[first.txt second.txt]

    Dir.mkdir(output_directory) unless File.exists?(output_directory)

    files.each do |filename|
      File.new "#{output_directory}/#{filename}", 'w'
    end

    Runoff::FileWriter.archive output_directory

    assert_equal 1, Dir['test/*.zip'].count
  end

  private

  def get_correct_format_mock
    correct_format = MiniTest::Mock.new

    correct_format.expect :get_filename, 'braun-drake.txt', [Hash]
    correct_format.expect :get_filename, 'braun-drake.txt', [Hash]
    correct_format.expect :build_entry, '[2013-04-18 13:16:58] Braun: This is a text.', [Hash]
    correct_format.expect :build_entry, '[2013-04-18 13:16:58] Braun: This is a text.', [Hash]

    correct_format
  end

  def get_incorrect_format_mock
    incorrect_format = MiniTest::Mock.new

    incorrect_format.expect :get_filename, 'john.txt', [Hash]
    incorrect_format.expect :build_entry, '[2013-04-18 13:16:58] John: This is a text.', [Hash]

    incorrect_format
  end
end