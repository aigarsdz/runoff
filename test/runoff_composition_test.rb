require 'minitest/spec'
require 'minitest/autorun'
require 'runoff'

describe Runoff::Composition do
  it "must raise an IOError if the file that is passed to the constructor doesn't exist" do
    ->{ composition = Runoff::Composition.new 'not_existing.db' }.must_raise IOError
  end
end