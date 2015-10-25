# -*- encoding : utf-8 -*-
module WordsCounted
  using Refinements::HashRefinements

  class Counter
    include Deprecated

    attr_reader :tokens

    def initialize(tokens)
      @tokens = tokens
    end

    # Returns the number of tokens.
    #
    # @example
    #  Counter.new(%w[one two two three three three]).token_count
    #  # => 6
    #
    # @return [Integer]   The number of tokens.
    def token_count
      tokens.size
    end

    # Returns the number of unique tokens.
    #
    # @example
    #  Counter.new(%w[one two two three three three]).uniq_token_count
    #  # => 3
    #
    # @return [Integer]   The number of unique tokens.
    def uniq_token_count
      tokens.uniq.size
    end

    # Returns the character count of all tokens.
    #
    # @example
    #  Counter.new(%w[one two]).char_count
    #  # => 6
    #
    # @return [Integer]   The total char count of tokens.
    def char_count
      tokens.join.size
    end

    # Returns a sorted two-dimensional array where each member array is a token and its frequency.
    # The array is sorted by frequency in descending order.
    #
    # @example
    #  Counter.new(%w[one two two three three three]).token_frequency
    #  # => [ ['three', 3], ['two', 2], ['one', 1] ]
    #
    # @return [Array<Array<String, Integer>>]
    def token_frequency
      tokens.each_with_object(Hash.new(0)) { |token, hash| hash[token] += 1 }.sort_by_value_desc
    end

    # Returns a sorted two-dimensional array where each member array is a token and its length.
    # The array is sorted by length in descending order.
    #
    # @example
    #  Counter.new(%w[one two three four five]).token_lenghts
    #  # => [ ['three', 5], ['four', 4], ['five', 4], ['one', 3], ['two', 3] ]
    #
    # @return [Array<Array<String, Integer>>]
    def token_lengths
      tokens.uniq.each_with_object({}) { |token, hash| hash[token] = token.length }.sort_by_value_desc
    end

    # Returns a sorted two-dimensional array where each member array is a token and its density
    # as a float, rounded to a precision of two decimal places. It accepts a precision argument
    # which defaults to `2`.
    #
    # @example
    #  Counter.new(%w[Maj. Major Major Major]).token_density
    #  # => [ ['major', .75], ['maj', .25] ]
    #
    # @example with `precision`
    #  Counter.new(%w[Maj. Major Major Major]).token_density(precision: 4)
    #  # => [ ['major', .7500], ['maj', .2500] ]
    #
    # @param [Integer] precision              The number of decimal places to round density to.
    # @return [Array<Array<String, Float>>]
    def token_density(precision: 2)
      token_frequency.each_with_object({}) { |(token, freq), hash|
        hash[token] = (freq / token_count.to_f).round(precision)
      }.sort_by_value_desc
    end

    # Returns a hash of tokens and their frequencies for tokens with the highest frequency.
    #
    # @example
    #  Counter.new(%w[one once two two twice twice]).most_frequent_tokens
    #  # => { 'two' => 2, 'twice' => 2 }
    #
    # @return [Hash<String, Integer>]
    def most_frequent_tokens
      token_frequency.group_by(&:last).max.last.to_h
    end

    # Returns a hash of tokens and their lengths for tokens with the highest length.
    #
    # @example
    #  Counter.new(%w[one three five seven]).longest_tokens
    #  # => { 'three' => 5, 'seven' => 5 }
    #
    # @return [Hash<String, Integer>]
    def longest_tokens
      token_lengths.group_by(&:last).max.last.to_h
    end

    # Returns the average char count per token rounded to a precision of two decimal places.
    # Accepts a `precision` argument.
    #
    # @example
    #  Counter.new(%w[one three five seven]).average_chars_per_token
    #  # => 4.25
    #
    # @return [Float]   The average char count per token.
    def average_chars_per_token(precision: 2)
      (char_count / token_count.to_f).round(precision)
    end
  end
end
