require 'minitest/autorun'
require 'minitest/unit'
require 'runoff'
require 'fileutils'

class TestComposition < MiniTest::Unit::TestCase
  def setup
    @composition = Runoff::Composition.new 'test/test_db.sqlite'
  end

  def teardown
    FileUtils.rm_rf 'test/tmp'
  end

  def test_must_raise_an_IOError_if_the_file_that_is_passed_to_the_constructor_does_not_exist
    assert_raises IOError do
      composition = Runoff::Composition.new 'not_existing.db'
    end
  end

  def test_must_respond_to_exported_filenames_method
    assert_respond_to @composition, :exported_filenames
  end

  def test_must_return_parsed_chatnames_together_with_partly_parsed_chatnames
    chatnames, raw_chatnames = @composition.get_chatnames

    assert_equal ['something-more', 'something-else'], chatnames
    assert_equal ['#something/$more;', '#something/$else;'], raw_chatnames
  end

  def test_must_return_a_count_of_the_exported_filenames
    file_count = @composition.send(
      :run_export,
      [{
        chatname: '#john/$elis;7687623',
        timestamp: 123123213,
        from_dispname: 'John',
        body_xml: ''
      }],
      'test/tmp'
    )

    assert_equal 1, file_count
  end

  def test_must_return_a_count_of_the_exported_filenames_when_called_for_all_chats
    file_count = @composition.export 'test/tmp'

    assert_equal 2, file_count
  end

  def test_must_return_a_count_of_the_exported_filenames_when_called_for_specific_chats
    file_count = @composition.export_chats ['#something/$more;', '#something/$else;'], 'test/tmp'

    assert_equal 2, file_count
  end
end