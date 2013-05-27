require 'minitest/spec'
require 'minitest/autorun'
require 'runoff'
require 'fileutils'

describe Runoff::Composition do
  before { @composition = Runoff::Composition.new 'test/test_db.sqlite' }

  it "must raise an IOError if the file that is passed to the constructor doesn't exist" do
    ->{ composition = Runoff::Composition.new 'not_existing.db' }.must_raise IOError
  end

  it 'must have a getter method for exported filenames' do
    @composition.must_respond_to :exported_filenames
  end

  it 'must return parsed chatnames together with partly parsed chatnames' do
    chatnames, raw_chatnames = @composition.get_chatnames

    chatnames.must_equal ['something-more', 'something-else']
    raw_chatnames.must_equal ['#something/$more;', '#something/$else;']
  end

  it 'must return a count of the exported filenames' do
    file_count = @composition.send(
      :run_export,
      [{
        chatname: '#test/$one;7687623',
        timestamp: 123123213,
        from_dispname: 'Aidzis',
        body_xml: ''
      }],
      'test/tmp'
    )

    file_count.must_equal 1
    FileUtils.rm_rf 'test/tmp'
  end

  it 'must return a count of the exported filenames when called for all chats' do
    file_count = @composition.export 'test/tmp'

    file_count.must_equal 2
    FileUtils.rm_rf 'test/tmp'
  end

  it 'must return a count of the exported filenames when called for specific chats' do
    file_count = @composition.export_chats ['#something/$more;', '#something/$else;'], 'test/tmp'

    file_count.must_equal 2
    FileUtils.rm_rf 'test/tmp'
  end
end