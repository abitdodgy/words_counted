module WordsCounted

  # Represents a Counter object.
  #
  class Counter
    # @!words [Array] an array of words resulting from the string passed to the initializer.
    # @!word_occurrences [Hash] an hash of words as keys and their occurrences as values.
    # @!word_lengths [Hash] an hash of words as keys and their lengths as values.
    attr_reader :words, :word_occurrences, :word_lengths

    # This is the criteria for defining words.
    #
    # Words are alpha characters and can include hyphens and apostrophes.
    #
    WORD_REGEX = /[\p{Alpha}\-']+/

    # Initializes an instance of Counter and splits a given string into an array of words.
    #
    # ## @words
    # This is the array of words that results from the string passed in. For example:
    #
    #    Counter.new("Bad, bad, piggy!")
    #    => #<WordsCounted::Counter:0x007fd49429bfb0 @words=["Bad", "bad", "piggy"]>
    #
    # @param string [String] the string to act on.
    # @param options [Hash] a hash of options that includes `filter` and `regex`
    #
    #   ## `filter`
    #   This a list of words to filter from the string. Useful if you want to remove *a*, **you**, and other common words.
    #   Any words included in the filter must be **lowercase**.
    #   defaults to an empty string
    #
    #   ## `regex`
    #   The criteria used to split a string. It defaults to `/[^\p{Alpha}\-']+/`.
    #
    #
    # @word_occurrences
    # This is a hash of words and their occurrences. Occurrences count is not case sensitive.
    #
    # ## Example
    #
    #    "Hello hello" #=> { "hello" => 2 }
    #
    # @return [Hash] a hash map of words as keys and their occurrences as values.
    #
    #
    # ## @word_lengths
    # This is a hash of words and their lengths.
    #
    # ## Example
    #
    #    "Hello sir" #=> { "hello" => 5, "sir" => 3 }
    #
    # @return [Hash] a hash map of words as keys and their lengths as values.
    #
    def initialize(string, options = {})
      @options = options

      @words = string.scan(regex).reject { |word| filter.split.include? word.downcase }

      @word_occurrences = words.each_with_object(Hash.new(0)) do |word, result|
        result[word.downcase] += 1
      end

      @word_lengths = words.each_with_object({}) do |word, result|
        result[word] ||= word.length
      end
    end

    # Returns the total word count.
    #
    # @return [Integer] total word count from `words` array size.
    #
    def word_count
      words.size
    end

    # Returns a  two dimensional array of the most occuring word(s)
    # and its number of occurrences.
    #
    # In the event of a tie, all tied words are returned.
    #
    # @return [Array] see {#highest_ranking}
    #
    def most_occurring_words
      highest_ranking word_occurrences
    end

    # Returns a  two dimensional array of the longest word(s) and
    # its length. In the event of a tie, all tied words are returned.
    #
    # @return [Array] see {#highest_ranking}
    #
    def longest_words
      highest_ranking word_lengths
    end

    # Returns a hash of word and their word density in percent.
    #
    # @returns [Hash] a hash map of words as keys and their density as values in percent.
    #
    def word_density
      word_occurrences.each_with_object({}) do |(word, occ), hash|
        hash[word] = percent_of_n(occ)
      end.sort_by { |_, v| v }.reverse
    end

    private

    # Takes a hashmap of the form {"foo" => 1, "bar" => 2} and returns an array
    # containing the entries (as an array) with the highest number as a value.
    #
    # @param entries [Hash] a hash of entries to analyse
    # @return [Array] a two dimentional array where each consists of a word its rank
    #
    # {http://codereview.stackexchange.com/a/47515/1563 See here}.
    #
    def highest_ranking(entries)
      entries.group_by { |word, occurrence| occurrence }.sort.last.last
    end

    # Calculates the percentege of a word.
    #
    # @param n [Integer] the divisor.
    # @returns [Float] a percentege of n based on {#word_count} rounded to two decimal places.
    #
    def percent_of_n(n)
      ((n.to_f / word_count.to_f) * 100.0).round(2)
    end

    def regex
      @options[:regex] || WORD_REGEX
    end

    def filter
      @options[:filter] || String.new
    end
  end
end
