require 'minitest/spec'
require 'minitest/autorun'
require 'runoff'

describe Runoff::Commands::All do
  it 'must output an error message if no username or --from option is provided' do
    ->{ Runoff::Commands::All.process []  }.must_output "You must specify a username or a --from option\n"
  end

  it 'must output result of the command' do
    ->{ Runoff::Commands::All.process [], {
      from: 'test/test_db.sqlite', destination: 'test/tmp' }
    }.must_output "Finished: 2 files were exported\n"
  end

  it 'must put exported files into an archive' do
    capture_io { Runoff::Commands::All.process [], { from: 'test/test_db.sqlite', destination: 'test/tmp' } }

    Dir["test/*.zip"].length.must_equal 1

    Dir.glob('test/*.zip').each do |archive|
      File.delete archive
    end
  end
end