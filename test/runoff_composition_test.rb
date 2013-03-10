require 'minitest/spec'
require 'minitest/autorun'
require 'runoff'

describe Runoff::Composition do
  it "must raise an IOError if the file that is passed to the constructor doesn't exist" do
    ->{ composition = Runoff::Composition.new 'not_existing.db' }.must_raise IOError
  end

  it "must have a getter method for exported filenames" do
    composition = Runoff::Composition.new 'test/test_db.sqlite'

    composition.must_respond_to :exported_filenames
  end

  describe "#parse_chatname" do
    before { @composition = Runoff::Composition.new 'test/test_db.sqlite' }

    it "must return a valid and readable filename from a raw chatname" do
      raw_chatname = '#something/$else;521357125362'
      chatname = @composition.send :parse_chatname, raw_chatname

      chatname.must_equal 'something-else.txt'
    end

    it "must raise a StandarError if the chatname is in the wrong format" do
      raw_chatname = '#something/$;521357125362'

      ->{ @composition.send :parse_chatname, raw_chatname }.must_raise StandardError
    end
  end

  describe "#save_to_file" do
    before do
      @composition = Runoff::Composition.new 'test/test_db.sqlite'
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
    end

    after { FileUtils.rm_rf 'test/tmp/.' }

    it "must print an error message if the chatname is in the wrong format" do
      ->{ @composition.send :save_to_file, @incorrect_chat_record, 'test/tmp' }.must_output(
        "Skipping #something/$;521357125362: Chatname in a wrong format\n"
      )
    end

    it "must write chat content to file" do
      @incorrect_chat_record[:chatname] = '#something/$else;521357125362'

      @composition.send :save_to_file, @chat_record, 'test/tmp'
      @composition.send :save_to_file, @incorrect_chat_record, 'test/tmp'
      @composition.exported_filenames.count.must_equal 2
    end

    it "must append to a file if the filename already exists" do
      @incorrect_chat_record[:chatname] = '#something/$else;521357125362'
      @additional_chat_record = @chat_record

      @composition.send :save_to_file, @chat_record, 'test/tmp'
      @composition.send :save_to_file, @incorrect_chat_record, 'test/tmp'
      @composition.send :save_to_file, @additional_chat_record, 'test/tmp'
      @composition.exported_filenames.count.must_equal 2
    end
  end

  describe "#export" do
    after { FileUtils.rm_rf 'test/tmp/.' }

    it "must return a count of the exported filenames" do
      composition = Runoff::Composition.new 'test/test_db.sqlite'
      file_count = composition.export 'test/tmp'

      file_count.must_equal 2
    end
  end
end