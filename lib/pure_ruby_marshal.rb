require "pure_ruby_marshal/version"
require 'pure_ruby_marshal/read_buffer'
require 'pure_ruby_marshal/write_buffer'

module PureRubyMarshal
  extend self

  MAJOR_VERSION = 4
  MINOR_VERSION = 8

  def dump(object)
    WriteBuffer.new.dump(object)
  end

  def load(data)
    ReadBuffer.new(data).read
  end
end

include PureRubyMarshal
