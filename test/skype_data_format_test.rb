require 'minitest/spec'
require 'minitest/autorun'
require 'runoff'

describe Runoff::SkypeDataFormat do
  before do
    @format = Runoff::SkypeDataFormat.new
  end

  it 'must return a valid filename from a hash (single record in a database)' do
    record = { chatname: '#brian/$john;521357125362' }
    filename = @format.get_filename record

    filename.must_equal 'brian-john.txt'
  end

  it 'must build a string from the necessary database record columns' do
    record = {
      chatname: '#brian/$john;521357125362',
      timestamp: 1366280218,
      from_dispname: 'Aidzis',
      body_xml: 'This is a text.'
    }
    entry = @format.build_entry record

    entry.must_equal '[2013-04-18 13:16:58] Aidzis: This is a text.'
  end

  it 'must return a valid and readable name from a raw chatname' do
    raw_chatname = '#something/$else;521357125362'
    chatname = @format.parse_chatname raw_chatname

    chatname.must_equal 'something-else'
  end

  it 'must return a valid and readable name from broken chatname records' do
    raw_chatname = '#something/$521357125362'
    chatname = @format.parse_chatname raw_chatname

    chatname.must_equal 'something'
  end

  it 'must return a chatname without the extra symbols' do
    raw_chatname = '#something/$else;521357125362'
    chatname = @format.partly_parse_chatname raw_chatname

    chatname.must_equal '#something/$else;'
  end

  it 'must return a chatname without the extra symbols for broken chatname records' do
    raw_chatname = '#something/$521357125362'
    chatname = @format.partly_parse_chatname raw_chatname

    chatname.must_equal '#something/$'
  end

  it 'must return a string without Skype emotion XML tags' do
    string = 'Some text <ss type="laugh">:D</ss>'
    clean_string = @format.send :parse_body_xml, string

    clean_string.must_equal 'Some text :D'
  end

  it 'must remove all starting and ending dashes from a string' do
    string = '---example--'
    valid_name = @format.send :trim_dashes, string

    valid_name.must_equal 'example'
  end
end