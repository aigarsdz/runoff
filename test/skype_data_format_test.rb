require 'minitest/autorun'
require 'runoff'

describe Runoff::SkypeDataFormat do
  before do
    @format = Runoff::SkypeDataFormat.new
  end

  it 'must parse a Unix timestamp into a human readable date in YYYY-MM-DD HH:MM:SS format' do
    @format.send(:format_timestamp, 1398165066).must_equal '2014-04-22 14:11:06'
  end

  it 'must parse a chatname into a string without any Skype specific characters' do
    @format.parse_chatname('#santa/$claus;d3d86c6b0e3b8320').must_equal 'santa_claus'
  end

  it 'must create a text entry from the given hash' do
    data = {
      chatname: '#santa/$claus;d3d86c6b0e3b8320' ,
      timestamp: 1398165066,
      from_dispname: 'santa',
      body_xml: 'Get your facts first, then you can distort them as you please.'
    }

    expected_result = '[2014-04-22 14:11:06] santa: Get your facts first, then you can distort them as you please.'

    @format.build_entry(data).must_equal expected_result
  end
end
