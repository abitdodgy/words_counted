# -*- encoding : utf-8 -*-
require "words_counted/version"
require "words_counted/tokeniser"
require "words_counted/counter"

begin
  require "pry"
rescue LoadError
end

module WordsCounted
  def self.count(string, options = {})
    Counter.new(string, options)
  end

  def self.from_file(path, options = {})
    Counter.from_file(path, options)
  end
end
