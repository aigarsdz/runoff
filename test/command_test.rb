require 'minitest/autorun'
require 'minitest/unit'
require 'runoff'

class TestCommand < MiniTest::Unit::TestCase
  def test_must_create_a_composition_object_based_on_a_specified_path_to_database_file
    assert_instance_of Runoff::Composition, Runoff::Commands::Command.send(:get_composition, nil, 'test/test_db.sqlite')
  end

  def test_must_return_a_default_destination_path_if_no_optional_path_is_specified
    assert_equal "#{ENV['HOME']}/skype-backup", Runoff::Commands::Command.send(:get_destination, nil)
  end

  def test_must_return_a_custom_path_if_an_optional_path_is_specified
    path = Runoff::Commands::Command.send :get_destination, 'test/test_db.sqlite'

    assert_equal 'test/test_db.sqlite', path
  end

  def test_must_output_correct_message_based_on_the_exported_items_count
    assert_output "Finished: 1 file was exported\n" do
      Runoff::Commands::Command.send :print_result, 1
    end

    assert_output "Finished: 2 files were exported\n" do
      Runoff::Commands::Command.send :print_result, 2
    end
  end

  def test_must_output_a_list_of_available_chatnames
    chatnames = ['first-chatname', 'second-chatname']

    assert_output "[0] first-chatname\n[1] second-chatname\n\n" do
      Runoff::Commands::Command.send :list_chatnames, chatnames
    end
  end

  def test_does_not_create_an_archive_if_the_archive_option_is_set_to_false
    skip
  end
end