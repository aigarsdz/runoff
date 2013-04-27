require 'minitest/spec'
require 'minitest/autorun'
require 'runoff'

describe Runoff::FileWriter do
  before do
    @incorrect_chat_record = {
      chatname: '#something/$;521357125362',
      timestamp: 1366280218,
      from_dispname: 'Aidzis',
      body_xml: ''
    }
    @chat_record = {
      chatname: '#something/$more;521357125362',
      timestamp: 1366280218,
      from_dispname: 'Aidzis',
      body_xml: 'This is a text.'
    }

    class ClassWithFileWriterMixin
      include Runoff::FileWriter
    end

    @test_object = ClassWithFileWriterMixin.new
  end

  it 'must return a string without Skype emotion XML tags' do
    string = 'Some text <ss type="laugh">:D</ss>'
    clean_string = @test_object.parse_body_xml string

    clean_string.must_equal 'Some text :D'
  end

  it 'must remove all starting and ending dashes from a string' do
    string = '---example--'
    valid_name = @test_object.trim_dashes string

    valid_name.must_equal 'example'
  end

  it 'must return a valid and readable name from a raw chatname' do
    raw_chatname = '#something/$else;521357125362'
    chatname = @test_object.parse_chatname raw_chatname

    chatname.must_equal 'something-else'
  end

  it 'must return a valid and readable name from broken chatname records' do
    raw_chatname = '#something/$521357125362'
    chatname = @test_object.parse_chatname raw_chatname

    chatname.must_equal 'something'
  end

  it 'must return a chatname without the extra symbols' do
    raw_chatname = '#something/$else;521357125362'
    chatname = @test_object.partly_parse_chatname raw_chatname

    chatname.must_equal '#something/$else;'
  end

  it 'must return a chatname without the extra symbols for broken chatname records' do
    raw_chatname = '#something/$521357125362'
    chatname = @test_object.partly_parse_chatname raw_chatname

    chatname.must_equal '#something/$'
  end

  it 'must build a chat entry from a database record' do
    entry = @test_object.build_entry @chat_record

    entry.must_equal '[2013-04-18 13:16:58] Aidzis: This is a text.'
  end

  describe "#save_to_file" do
    after do
      FileUtils.rm_rf 'test/tmp/.'
      Dir.glob('test/*.zip').each do |archive|
        File.delete archive
      end
    end

    it 'must write chat content to file' do
      @test_object.save_to_file @chat_record, 'test/tmp'
      @test_object.save_to_file @incorrect_chat_record, 'test/tmp'
      Dir['test/tmp/**/*'].length.must_equal 2
    end

    it 'must append to a file if the filename already exists' do
      @additional_chat_record = @chat_record

      @test_object.save_to_file @chat_record, 'test/tmp'
      @test_object.save_to_file @incorrect_chat_record, 'test/tmp'
      @test_object.save_to_file @additional_chat_record, 'test/tmp'
      Dir['test/tmp/**/*'].length.must_equal 2
    end
  end

  it 'must create a Zip file of the file output directory' do
    output_directory = 'test/tmp'
    files = %w[first.txt second.txt]

    Dir.mkdir(output_directory) unless File.exists?(output_directory)
    files.each do |filename|
      File.new "#{output_directory}/#{filename}", 'w'
    end

    @test_object.archive output_directory
    Dir["test/*.zip"].length.must_equal 1

    Dir.glob('test/*.zip').each do |archive|
      File.delete archive
    end
  end
end