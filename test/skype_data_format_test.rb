require 'minitest/autorun'
require 'runoff'

describe Runoff::SkypeDataFormat do
  before do
    @format = Runoff::SkypeDataFormat.new
  end

  it "must return a schema of the necessary data" do
    expected = { table: :Messages, columns: [:chatname, :timestamp, :from_dispname, :body_xml] }

    @format.get_schema.must_equal expected
  end

  it "must yield a schema of the necessary data to a block" do
    @format.get_schema do |table, columns|
      table.must_equal :Messages
      columns.must_equal [:chatname, :timestamp, :from_dispname, :body_xml]
    end
  end

  it "must return a hash with 'filename' and 'content' keys based on the input data" do
    fields = {
      chatname: "#john/$doe;1243435",
      from_dispname: "John",
      body_xml: "Lorem ipsum",
      timestamp: 1387756800
    }

    expected = { filename: "john-doe.txt", content: "[2013-12-23 02:00:00] John: Lorem ipsum\n" }

    @format.build_entry(fields).must_equal expected
  end

  it "must normalize a Skype specific chat title into a human readable string" do
    @format.normalize('#john/$doe;2354657').must_equal 'john-doe'
  end

  it "must normalize a Skype specific chat title into a human readable string even in case of invalid title" do
    @format.normalize('#john/$;2354657').must_equal 'john'
  end

  it "must parse a Skype specific chat title into a valid file name" do
    @format.send(:get_filename, '#john/$doe;2354657').must_equal 'john-doe.txt'
  end

  it "must parse a Skype specific chat title into a valid file name even in case of invalid title" do
    @format.send(:get_filename, '#john/$;2354657').must_equal 'john.txt'
  end
end