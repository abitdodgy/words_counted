module WordsCounted
  class Counter
    attr_reader :words, :word_occurrences, :word_lengths, :char_count

    WORD_REGEXP = /[\p{Alpha}\-']+/

    def self.from_file(path, options = {})
      File.open(path) do |file|
        new file.read, options
      end
    end

    def initialize(string, options = {})
      @options = options
      exclude = filter_proc(options[:exclude])
      @words = string.scan(regexp).reject { |word| exclude.call(word) }
      @char_count = @words.join.size
      @word_occurrences = words.each_with_object(Hash.new(0)) { |word, hash| hash[word.downcase] += 1 }
      @word_lengths = words.each_with_object({}) { |word, hash| hash[word] ||= word.length }
    end

    def word_count
      words.size
    end

    def unique_word_count
      words.uniq.size
    end

    def average_chars_per_word(precision = 2)
      (char_count.to_f / word_count.to_f).round(precision)
    end

    def most_occurring_words
      highest_ranking word_occurrences
    end

    def longest_words
      highest_ranking word_lengths
    end

    def word_density(precision = 2)
      word_densities = word_occurrences.each_with_object({}) do |(word, occ), hash|
        hash[word] = (occ.to_f / word_count.to_f * 100).round(precision)
      end
      sort_by_descending_value word_densities
    end

    def sorted_word_occurrences
      sort_by_descending_value word_occurrences
    end

    def sorted_word_lengths
      sort_by_descending_value word_lengths
    end

  private

    def highest_ranking(entries)
      entries.group_by { |_, value| value }.sort.last.last
    end

    def sort_by_descending_value(entries)
      entries.sort_by { |_, value| value }.reverse
    end

    def regexp
      @options[:regexp] || WORD_REGEXP
    end

    def filter_proc(filter)
      if filter.respond_to?(:to_a)
        filter_procs = Array(filter).map(&method(:filter_proc))
        ->(word) {
          filter_procs.any? { |p| p.call(word) }
        }
      elsif filter.respond_to?(:to_str)
        exclusion_list = filter.split.collect(&:downcase)
        ->(word) {
          exclusion_list.include?(word.downcase)
        }
      elsif regexp_filter = Regexp.try_convert(filter)
        Proc.new { |word| word =~ regexp_filter }
      elsif filter.respond_to?(:to_proc)
        filter.to_proc
      else
        raise ArgumentError, "Filter must String, Array, Lambda, or Regexp"
      end
    end
  end
end
