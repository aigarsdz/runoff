require 'minitest/spec'
require 'minitest/autorun'
require 'runoff'

describe Runoff::Source do
  before { @source = Runoff::Source.new }

  after do
    FileUtils.rm_rf 'test/tmp/.'
    Dir.glob('test/*.zip').each do |archive|
      File.delete archive
    end
  end

  it 'must export all the chats from a Skype database into text files and print a count of the exported files' do
    command = 'all -f test/test_db.sqlite -t test/tmp'

    ->{ Runoff::Source.start command.split }.must_output "Finished: 2 files were exported\n"
  end

  it 'must raise a StandardError if no Skype username or --form option is provided' do
    ->{ @source.send :get_composition, nil }.must_raise StandardError
  end

  it 'must print how many files were exported' do
    ->{ @source.send :print_result, 1 }.must_output "Finished: 1 file was exported\n"
    ->{ @source.send :print_result, 5 }.must_output "Finished: 5 files were exported\n"
  end

  it 'must print all available chatnames' do
    chatnames = ['something-more', 'something-else']

    ->{ @source.send :list_chatnames, chatnames }.must_output "[0] something-more\n[1] something-else\n\n"
  end
end