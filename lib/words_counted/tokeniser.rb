# -*- encoding : utf-8 -*-
module WordsCounted
  class Tokeniser
    attr_reader :tokens

    # Default tokenisation strategy
    TOKEN_REGEXP = /[\p{Alpha}\-']+/

    # Takes a string and converts it into an array of tokens using a regular expression.
    # An optional regex can be passed to `pattern` to tokenise the string.
    #
    # Use `exclude` to remove tokens from the final list. `exclude` can be a string,
    # a regular expression, a lambda, or an array of one or more of those types.
    # This option provides a way to implement powerful and flexible tokenisation strategies.
    #
    # @example
    #  Tokeniser.new("Hello World!")
    #
    # @example With `pattern`
    #  Tokeniser.new("Hello world", pattern: /hello/)
    #
    # @example With `exclude` as a string
    #  Tokeniser.new("Hello world", exclude: "hello")
    #
    # @example With `exclude` as a regexp
    #  Tokeniser.new("Goodbye world", exclude: /hello/)
    #
    # @example With `exclude` as a lambda
    #  Tokeniser.new("Goodbye world", exclude: ->(token) { token.length < 7 })
    #
    # @example With `exclude` as an array of strings
    #  Tokeniser.new("Hello world", exclude: ["world"])
    #
    # @example With `exclude` as an array of regular expressions
    #  Tokeniser.new("Goodbye and hello world", exclude: [/goodbye/, /and/])
    #
    # @example With `exclude` as an array of lambdas
    #  Tokeniser.new("Goodbye and hello world", exclude: [->(t) { t.length > 5}, ->(t) { t.length < 5}])
    #
    # @example With `exclude` as a mixed array
    #  Tokeniser.new("Goodbye and hello world", exclude: [->(t) { t.length > 5}, /goodbye/, "hello"])
    #
    # @param [String] input                                                          The string to tokenise.
    # @param [Array<String, Regexp, Lambda>, String, Regexp, Lambda, nil] filter     The filter to apply.
    # @return [Proc]                                                                 The generated proc object.
    def initialize(input, pattern: TOKEN_REGEXP, exclude: nil)
      filter_proc = filter_as_proc(exclude)
      @tokens = input.scan(pattern).map(&:downcase).reject { |token| filter_proc.call(token) }
    end

  private

    # The `filter` arg can be a string, a regular expression, a proc, or an array of one
    # or more of those types.
    #
    # If `filter` is an array, each element is piped back to the method and a
    # proc is returned, resulting in an array of procs (elements of the original
    # array are converted to procs using recursion). Procs in this array are then
    # iterated over and called. If true is returned, the token is excluded.
    #
    # If `filter` is a proc, then the proc is simply called. If `filter` is a string,
    # the string is converted to an array, and a proc is send back that returns true
    # if the token is included in this array. If `filter` is a regexp, a `proc` is
    # returned that checks the token for a match.
    #
    # This method depends in `nil` responding `to_a` with an empty array, which
    # avoids us having to check if `exclude` was passed.
    #
    # See {Tokeniser.initialize}
    def filter_as_proc(filter)
      if filter.respond_to?(:to_a)
        filter_procs = Array(filter).map &method(:filter_as_proc)
        ->(token) {
          filter_procs.any? { |pro| pro.call(token) }
        }
      elsif filter.respond_to?(:to_str)
        normalized_exclusion_list = filter.split.map(&:downcase)
        ->(token) {
          normalized_exclusion_list.include?(token)
        }
      elsif regexp_filter = Regexp.try_convert(filter)
        ->(token) {
          token =~ regexp_filter
        }
      elsif filter.respond_to?(:to_proc)
        filter.to_proc
      else
        raise ArgumentError, "`filter` must be a `String`, `Regexp`, `lambda`, or an `Array` of any combination of those types"
      end
    end
  end
end
