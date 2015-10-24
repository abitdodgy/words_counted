# -*- encoding : utf-8 -*-
module WordsCounted
  module Deprecated
    # @deprecated use `Counter#token_count`
    def word_count
      warn "`Counter#word_count` is deprecated, please use `Counter#token_count`"
      token_count
    end

    # @deprecated use `Counter#uniq_token_count`
    def unique_word_count
      warn "`Counter#unique_word_count` is deprecated, please use `Counter#uniq_token_count`"
      uniq_token_count
    end

    # @deprecated use `Counter#token_frequency`
    def word_occurrences
      warn "`Counter#word_occurrences` is deprecated, please use `Counter#token_frequency`"
      warn "`Counter#token_frequency` returns a sorted array of arrays, not a hash. Call `token_frequency.to_h` for old behaviour"
      token_frequency.to_h
    end

    # @deprecated use `Counter#token_lengths`
    def word_lengths
      warn "`Counter#word_lengths` is deprecated, please use `Counter#token_lengths`"
      warn "`Counter#token_lengths` returns a sorted array of arrays, not a hash. Call `token_lengths.to_h` for old behaviour"
      token_lengths.to_h
    end

    # @deprecated use `Counter#token_density`
    def word_density(precision = 2)
      warn "`Counter#word_density` is deprecated, please use `Counter#token_density`"
      warn "`Counter#token_density` returns density as decimal and not percent"

      token_density(precision: precision * 2).map { |tuple| [tuple.first, (tuple.last * 100).round(precision)] }
    end

    # @deprecated use `Counter#token_frequency`
    def sorted_word_occurrences
      warn "`Counter#sorted_word_occurrences` is deprecated, please use `Counter#token_frequency`"
      token_frequency
    end

    # @deprecated use `Counter#token_lengths`
    def sorted_word_lengths
      warn "`Counter#sorted_word_lengths` is deprecated, please use `Counter#token_lengths`"
      token_lengths
    end

    # @deprecated use `Counter#most_frequent_tokens`
    def most_occurring_words
      warn "`Counter#most_occurring_words` is deprecated, please use `Counter#most_frequent_tokens`"
      warn "`Counter#most_frequent_tokens` returns a hash, not an array. Call `most_frequent_tokens.to_h` for old behaviour."
      most_frequent_tokens.to_a
    end

    # @deprecated use `Counter#longest_tokens`
    def longest_words
      warn "`Counter#longest_words` is deprecated, please use `Counter#longest_tokens`"
      warn "`Counter#longest_tokens` returns a hash, not an array. Call `longest_tokens.to_h` for old behaviour."
      longest_tokens.to_a
    end

    # @deprecated use `Counter#average_chars_per_token`
    def average_chars_per_word(precision = 2)
      warn "`Counter#average_chars_per_word` is deprecated, please use `Counter#average_chars_per_token`"
      average_chars_per_token(precision: precision)
    end

    # @deprecated use `Counter#average_chars_per_token`
    def count(token)
      warn "`Counter#count` is deprecated, please use `Array#count`"
      tokens.count(token.downcase)
    end
  end
end
