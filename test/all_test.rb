require 'minitest/autorun'
require 'minitest/unit'
require 'runoff'
require 'fileutils'

class TestAll < MiniTest::Unit::TestCase
  def teardown
    Dir.glob('test/*.zip').each do |archive|
      File.delete archive
    end

    FileUtils.rm_rf 'test/tmp'
  end

  def test_must_output_an_error_message_if_no_username_or_from_option_is_provided
    assert_output "You must specify a username or a --from option\n" do
      Runoff::Commands::All.process []
    end
  end

  def test_must_output_result_of_the_command
    assert_output "Finished: 2 files were exported\n" do
      Runoff::Commands::All.process [], {
        from: 'test/test_db.sqlite',
        destination: 'test/tmp'
      }
    end
  end

  def test_must_put_exported_files_into_an_archive
    capture_io do
      Runoff::Commands::All.process [], { from: 'test/test_db.sqlite', destination: 'test/tmp' }
    end

    assert_equal 1, Dir["test/*.zip"].length, "test directory must contain 1 Zip file"
  end
end