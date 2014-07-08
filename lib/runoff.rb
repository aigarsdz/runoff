require 'runoff/version'
require 'runoff/location'
require 'runoff/adapters/adapter'
require 'runoff/adapters/txt_adapter'
require 'runoff/adapters/json_adapter'
require 'runoff/file_writer'
require 'runoff/chat'

module Runoff
  # Public: A String containing the name of the table, where all the chat messages are stored.
  TABLE = :Messages

  # Public: An Array with all the important column names.
  COLUMNS = [ :convo_id, :chatname, :timestamp, :from_dispname, :body_xml ]
end
