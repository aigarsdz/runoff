$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "runoff/version"
require "runoff/location"
require "runoff/file_writer"
require "runoff/composition"
require "runoff/source"