$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "runoff/version"
require "runoff/location"
require "runoff/skype_data_format"
require "runoff/file_writer"
require "runoff/composition"
require "runoff/commands/command"
require "runoff/commands/all"
require "runoff/commands/chat"