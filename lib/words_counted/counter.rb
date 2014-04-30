module WordsCounted

  # Represents a counter object.
  #
  class Counter
    # @!words [Array] an array of words resulting from the string passed to the initializer.
    attr_reader :words

    # This is the criteria for defining words.
    #
    # Words are alpha characters and can include hyphens and apostrophes.
    #
    WORD_REGEX = /[^\p{Alpha}\-']+/

    # Initializes an instance of Counter and splits a given string into an array of words.
    #
    #    Counter.new("Bad, bad, piggy!")
    #    => #<WordsCounted::Counter:0x007fd49429bfb0 @words=["Bad", "bad", "piggy"]>
    #
    # @param string [String] the string to act on.
    # @param filter [String] a string of words to filter from the string to act on.
    #
    def initialize(string, filter = String.new)
      @words = string.split(WORD_REGEX).reject { |word| filter.split.include? word.downcase }
    end

    # Returns the total word count.
    #
    # @return [Integer] total word count from `words` array size.
    #
    def word_count
      words.size
    end

    # Returns a hash of words and their occurrences.
    # Occurrences count is not case sensitive:
    #
    # ## Example
    #
    #    "Hello hello" #=> { "hello" => 2 }
    #
    # @return [Hash] a hash map of words as keys and their occurrences as values.
    #
    def word_occurrences
      @occurrences ||= words.each_with_object(Hash.new(0)) { |word, result| result[word.downcase] += 1 }
    end

    # Returns a hash of words and their lengths.
    #
    # ## Example
    #
    #    "Hello sir" #=> { "hello" => 5, "sir" => 3 }
    #
    # @return [Hash] a hash map of words as keys and their lengths as values.
    #
    def word_lengths
      @lengths ||= words.each_with_object({}) { |word, result| result[word] ||= word.length }
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
  end
end
