require 'minitest/spec'
require 'minitest/autorun'
require 'runoff'

describe Runoff::Commands::Chat do
  it 'must output an error message if no username or --from option is provided' do
    ->{ Runoff::Commands::Chat.process []  }.must_output "You must specify a username or a --from option\n"
  end
end