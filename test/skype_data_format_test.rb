require 'minitest/autorun'
require 'minitest/unit'
require 'runoff'

class TestSkypeDataFormat < MiniTest::Unit::TestCase
  def setup
    @format = Runoff::SkypeDataFormat.new
  end

  def test_must_return_a_valid_filename_from_a_hash
    record = { chatname: '#brian/$john;521357125362' }
    filename = @format.get_filename record

    assert_equal 'brian-john.txt', filename
  end

  def test_must_build_a_string_from_the_necessary_database_record_columns
    record = {
      chatname: '#brian/$john;521357125362',
      timestamp: 1366280218,
      from_dispname: 'Aidzis',
      body_xml: 'This is a text.'
    }

    entry = @format.build_entry record

    assert_equal '[2013-04-18 13:16:58] Aidzis: This is a text.', entry
  end

  def test_must_return_a_valid_and_readable_name_from_a_raw_chatname
    raw_chatname = '#something/$else;521357125362'
    chatname = @format.parse_chatname raw_chatname

    assert_equal 'something-else', chatname
  end

  def test_must_return_a_valid_and_readable_name_from_a_broken_chatname_record
    raw_chatname = '#something/$521357125362'
    chatname = @format.parse_chatname raw_chatname

    assert_equal 'something', chatname
  end

  def test_must_return_a_chatname_without_the_extra_symbols
    raw_chatname = '#something/$else;521357125362'
    chatname = @format.partly_parse_chatname raw_chatname

    assert_equal '#something/$else;', chatname
  end

  def test_must_return_a_chatname_without_the_extra_symbols_for_a_broken_chatname_record
    raw_chatname = '#something/$521357125362'
    chatname = @format.partly_parse_chatname raw_chatname

    assert_equal '#something/$', chatname
  end

  def test_must_return_a_string_without_skype_emotion_xml_tags
    string = 'Some text <ss type="laugh">:D</ss>'
    clean_string = @format.send :parse_body_xml, string

    assert_equal 'Some text :D', clean_string
  end

  def test_must_remove_all_starting_and_ending_dashes_from_a_string
    string = '---example--'
    valid_name = @format.send :trim_dashes, string

    assert_equal 'example', valid_name
  end
end