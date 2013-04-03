require 'minitest/spec'
require 'minitest/autorun'
require 'runoff'

describe Runoff::FileWriter do
  before do
    @incorrect_chat_record = {
      chatname: '#something/$;521357125362',
      timestamp: 1362864487,
      from_dispname: 'Aidzis',
      body_xml: ''
    }
    @chat_record = {
      chatname: '#something/$more;521357125362',
      timestamp: 1362864487,
      from_dispname: 'Aidzis',
      body_xml: ''
    }

    class ClassWithFileWriterMixin
      include Runoff::FileWriter
    end

    @test_object = ClassWithFileWriterMixin.new
  end

  it "must return a string without Skype emotion XML tags" do
    string = 'Some text <ss type="laugh">:D</ss>'
    clean_string = @test_object.parse_body_xml string

    clean_string.must_equal 'Some text :D'
  end

  it "must remove all starting and ending dashes from a string" do
    string = "---example--"
    valid_name = @test_object.trim_dashes string

    valid_name.must_equal 'example'
  end

  it "must return a valid and readable name from a raw chatname" do
    raw_chatname = '#something/$else;521357125362'
    chatname = @test_object.parse_chatname raw_chatname

    chatname.must_equal 'something-else'
  end

  it "must return a valid and readable name from broken chatname records" do
    raw_chatname = '#something/$521357125362'
    chatname = @test_object.parse_chatname raw_chatname

    chatname.must_equal 'something'
  end

  it "must return a chatname without the extra symbols" do
    raw_chatname = '#something/$else;521357125362'
    chatname = @test_object.partly_parse_chatname raw_chatname

    chatname.must_equal '#something/$else;'
  end

  it "must return a chatname without the extra symbols for broken chatname records" do
    raw_chatname = '#something/$521357125362'
    chatname = @test_object.partly_parse_chatname raw_chatname

    chatname.must_equal '#something/$'
  end

  describe "#save_to_file" do
    after { FileUtils.rm_rf 'test/tmp/.' }

    it "must write chat content to file" do
      @test_object.save_to_file @chat_record, 'test/tmp'
      @test_object.save_to_file @incorrect_chat_record, 'test/tmp'
      Dir["test/tmp/**/*"].length.must_equal 2
    end

    it "must append to a file if the filename already exists" do
      @additional_chat_record = @chat_record

      @test_object.save_to_file @chat_record, 'test/tmp'
      @test_object.save_to_file @incorrect_chat_record, 'test/tmp'
      @test_object.save_to_file @additional_chat_record, 'test/tmp'
      Dir["test/tmp/**/*"].length.must_equal 2
    end
  end
end