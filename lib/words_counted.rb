# -*- encoding : utf-8 -*-
require "refinements/hash_refinements"

require "words_counted/deprecated"

require "words_counted/tokeniser"
require "words_counted/counter"
require "words_counted/version"

begin
  require "pry"
rescue LoadError
end

module WordsCounted
  # Takes a string, tokenises it, and returns an instance of Counter
  # with the resulting tokens.
  #
  # @see Tokeniser.tokenise
  # @see Counter.initialize
  #
  # @param [String] input   The input to be tokenised.
  # @param [Hash] options   The options to pass onto `Counter`.
  def self.count(input, options = {})
    tokens = Tokeniser.new(input).tokenise(options)
    Counter.new(tokens)
  end

  # Takes a file path, reads the file and tokenises its contents,
  # and returns an instance of Counter with the resulting tokens.
  #
  # @see Tokeniser.tokenise
  # @see Counter.initialize
  #
  # @param [String] path    The file to be read and tokenised.
  # @param [Hash] options   The options to pass onto `Counter`.
  def self.from_file(path, options = {})
    tokens = File.open(path) do |file|
      Tokeniser.new(file.read).tokenise(options)
    end
    Counter.new(tokens)
  end
end
