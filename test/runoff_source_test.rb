require 'minitest/spec'
require 'minitest/autorun'
require 'runoff'

describe Runoff::Source do
  after { FileUtils.rm_rf 'test/tmp/.' }

  it 'must export all the chats from a Skype database into text files and print a count of the exported files' do
    command = 'all -f test/test_db.sqlite -t test/tmp'

    ->{ Runoff::Source.start command.split }.must_output "Finished: 2 files were exported\n"
  end
end