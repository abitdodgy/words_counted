# -*- encoding : utf-8 -*-
require "refinements/hash_refinements"

require "words_counted/tokeniser"
require "words_counted/counter"
require "words_counted/version"

begin
  require "pry"
rescue LoadError
end

module WordsCounted
  def self.count(string, options = {})
    tokens = Tokeniser.new(string).tokenise(options)
    Counter.new(tokens)
  end

  def self.from_file(path, options = {})
    tokens = File.open(path) do |file|
      Tokeniser.new(file.read).tokenise(options)
    end
    Counter.new(tokens)
  end
end
