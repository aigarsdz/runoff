require 'minitest/unit'
require 'runoff'
require 'fileutils'

describe Runoff::FileWriter do
  before do
    @incorrect_chat_record = {
      chatname: '#john/$;521357125362',
      timestamp: 1366280218,
      from_dispname: 'Aidzis',
      body_xml: 'This is a text'
    }

    @chat_record = {
      chatname: '#braun/$drake;521357125362',
      timestamp: 1366280218,
      from_dispname: 'Aidzis',
      body_xml: 'This is a text.'
    }

    correct_format = MiniTest::Mock.new

    correct_format.expect :get_filename, 'something-more', [Hash]
    correct_format.expect :get_filename, 'something-more', [Hash]
    correct_format.expect :build_entry, '[2013-04-18 13:16:58] Aidzis: This is a text.', [Hash]
    correct_format.expect :build_entry, '[2013-04-18 13:16:58] Aidzis: This is a text.', [Hash]

    @correct_file_writer = Runoff::FileWriter.new correct_format

    incorrect_format = MiniTest::Mock.new

    incorrect_format.expect :get_filename, 'something', [Hash]
    incorrect_format.expect :build_entry, '[2013-04-18 13:16:58] Aidzis: This is a text.', [Hash]

    @incorrect_file_writer = Runoff::FileWriter.new incorrect_format
  end

  describe "#save_to_file" do
    after do
      FileUtils.rm_rf 'test/tmp'
      Dir.glob('test/*.zip').each do |archive|
        File.delete archive
      end
    end

    it 'must write chat content to file' do
      @correct_file_writer.save_to_file @chat_record, 'test/tmp'
      @incorrect_file_writer.save_to_file @incorrect_chat_record, 'test/tmp'
      Dir.glob('test/tmp/*.txt').count.must_equal 2
    end

    it 'must append to a file if the filename already exists' do
      @additional_chat_record = @chat_record

      @correct_file_writer.save_to_file @chat_record, 'test/tmp'
      @incorrect_file_writer.save_to_file @incorrect_chat_record, 'test/tmp'
      @correct_file_writer.save_to_file @additional_chat_record, 'test/tmp'
      Dir.glob('test/tmp/*.txt').count.must_equal 2
    end
  end

  it 'must create a Zip file of the file output directory' do
    output_directory = 'test/tmp'
    files = %w[first.txt second.txt]

    Dir.mkdir(output_directory) unless File.exists?(output_directory)
    files.each do |filename|
      File.new "#{output_directory}/#{filename}", 'w'
    end

    Runoff::FileWriter.archive output_directory
    Dir["test/*.zip"].length.must_equal 1

    Dir.glob('test/*.zip').each do |archive|
      File.delete archive
    end

    FileUtils.rm_rf 'test/tmp'
  end
end