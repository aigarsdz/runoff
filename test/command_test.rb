require 'minitest/spec'
require 'minitest/autorun'
require 'runoff'

describe Runoff::Commands::Command do
  it 'must create a Composition object based on the Skype username or a specific path' do
    Runoff::Commands::Command.send(:get_composition, nil, 'test/test_db.sqlite').must_be_instance_of Runoff::Composition
  end

  it 'must return a default destination path if no optional path is specified' do
    Runoff::Commands::Command.send(:get_destination, nil).must_equal "#{ENV['HOME']}/skype-backup"
  end

  it 'must return a custom path if an optional path variable is specified' do
    path = Runoff::Commands::Command.send(:get_destination, 'test/test_db.sqlite')
    path.must_equal 'test/test_db.sqlite'
  end

  it 'must output correct message based on the exported items count' do
    ->{ Runoff::Commands::Command.send(:print_result, 1) }.must_output "Finished: 1 file was exported\n"
    ->{ Runoff::Commands::Command.send(:print_result, 2) }.must_output "Finished: 2 files were exported\n"
  end

  it 'must output a list of available chatnames' do
    chatnames = ['first-chatname', 'second-chatname']

    ->{ Runoff::Commands::Command.send(:list_chatnames, chatnames) }.must_output "[0] first-chatname\n[1] second-chatname\n\n"
  end
end