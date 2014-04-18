require 'runoff/version'
require 'runoff/location'
require 'runoff/skype_data_format'
require 'runoff/file_writer'
require 'runoff/chat'

module Runoff
  TABLE = :Messages
  COLUMNS = [ :chatname, :timestamp, :from_dispname, :body_xml ]
end
