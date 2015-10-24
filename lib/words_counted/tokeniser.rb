# -*- encoding : utf-8 -*-
module WordsCounted
  class Tokeniser
    # Takes a string and breaks it into an array of tokens.
    # Using `pattern` and `exclude` allows for powerful tokenisation strategies.
    #
    # @example
    #  tokeniser = WordsCounted::Tokeniser.new("We are all in the gutter, but some of us are looking at the stars.")
    #  tokeniser.tokenise(exclude: "We are all in the gutter")
    #  # => ['but', 'some', 'of', 'us', 'are', 'looking', 'at', 'the', 'stars']

    # Default tokenisation strategy
    TOKEN_REGEXP = /[\p{Alpha}\-']+/

    # Initialises state with a string that will be tokenised.
    #
    # @param [String] input   The string to tokenise.
    # @return [Tokeniser]
    def initialize(input)
      @input = input
    end

    # Converts a string into an array of tokens using a regular expression.
    # If a regexp is not provided a default one is used. See {Tokenizer.TOKEN_REGEXP}.
    #
    # Use `exclude` to remove tokens from the final list. `exclude` can be a string,
    # a regular expression, a lambda, a symbol, or an array of one or more of those types.
    # This allows for powerful and flexible tokenisation strategies.
    #
    # @example
    #  WordsCounted::Tokeniser.new("Hello World").tokenise
    #  # => ['hello', 'world']
    #
    # @example With `pattern`
    #  WordsCounted::Tokeniser.new("Hello-Mohamad").tokenise(pattern: /[^-]+/)
    #  # => ['hello', 'mohamad']
    #
    # @example With `exclude` as a string
    #  WordsCounted::Tokeniser.new("Hello Sami").tokenise(exclude: "hello")
    #  # => ['sami']
    #
    # @example With `exclude` as a regexp
    #  WordsCounted::Tokeniser.new("Hello Dani").tokenise(exclude: /hello/i)
    #  # => ['dani']
    #
    # @example With `exclude` as a lambda
    #  WordsCounted::Tokeniser.new("Goodbye Sami").tokenise(exclude: ->(token) { token.length > 6 })
    #  # => ['sami']
    #
    # @example With `exclude` as a symbol
    #  WordsCounted::Tokeniser.new("Hello محمد").tokenise(exclude: :ascii_only?)
    #  # => ['محمد']
    #
    # @example With `exclude` as an array of strings
    #  WordsCounted::Tokeniser.new("Goodbye Sami and hello Dani").tokenise(exclude: ["goodbye hello"])
    #  # => ['sami', 'and', dani']
    #
    # @example With `exclude` as an array of regular expressions
    #  WordsCounted::Tokeniser.new("Goodbye and hello Dani").tokenise(exclude: [/goodbye/i, /and/i])
    #  # => ['hello', 'dani']
    #
    # @example With `exclude` as an array of lambdas
    #  t = WordsCounted::Tokeniser.new("Special Agent 007")
    #  t.tokenise(exclude: [->(t) { t.to_i.odd? }, ->(t) { t.length > 5}])
    #  # => ['agent']
    #
    # @example With `exclude` as a mixed array
    #  t = WordsCounted::Tokeniser.new("Hello! اسماءنا هي محمد، كارولينا، سامي، وداني")
    #  t.tokenise(exclude: [:ascii_only?, /محمد/, ->(t) { t.length > 6}, "و"])
    #  # => ["هي", "سامي", "ودان"]
    #
    # @param [Regexp] pattern   The string to tokenise.
    # @param [Array<String, Regexp, Lambda, Symbol>, String, Regexp, Lambda, Symbol, nil] exclude     The filter to apply.
    # @return [Array] the array of filtered tokens.
    def tokenise(pattern: TOKEN_REGEXP, exclude: nil)
      filter_proc = filter_to_proc(exclude)
      @input.scan(pattern).map(&:downcase).reject { |token| filter_proc.call(token) }
    end

  private

    # This method converts any arguments into a callable object. The return value of this
    # is then used to determine whether a token should be excluded from the final list or not.
    #
    # `filter` can be a string, a regular expression, a lambda, a symbol, or an array
    # of any combination of those types.
    #
    # If `filter` is a string, see {Tokeniser#filter_proc_from_string}.
    # If `filter` is a an array, see {Tokeniser#filter_procs_from_array}.
    #
    # If `filter` is a proc, then the proc is simply called. If `filter` is a regexp, a `lambda`
    # is returned that checks the token for a match. If a symbol is passed, it is converted to
    # a proc.
    #
    # This method depends on `nil` responding `to_a` with an empty array, which
    # avoids having to check if `exclude` was passed.
    #
    # @api private
    def filter_to_proc(filter)
      if filter.respond_to?(:to_a)
        filter_procs_from_array(filter)
      elsif filter.respond_to?(:to_str)
        filter_proc_from_string(filter)
      elsif regexp_filter = Regexp.try_convert(filter)
        ->(token) {
          token =~ regexp_filter
        }
      elsif filter.respond_to?(:to_proc)
        filter.to_proc
      else
        raise ArgumentError,
          "`filter` must be a `String`, `Regexp`, `lambda`, `Symbol`, or an `Array` of any combination of those types"
      end
    end

    # Converts an array of `filters` to an array of lambdas, and returns a lambda that calls
    # each lambda in the resulting array. If any lambda returns true the token is excluded
    # from the final list.
    #
    # @api private
    def filter_procs_from_array(filter)
      filter_procs = Array(filter).map &method(:filter_to_proc)
      ->(token) {
        filter_procs.any? { |pro| pro.call(token) }
      }
    end

    # Converts a string `filter` to an array, and returns a lambda
    # that returns true if the token is included in the array.
    #
    # @api private
    def filter_proc_from_string(filter)
      normalized_exclusion_list = filter.split.map(&:downcase)
      ->(token) {
        normalized_exclusion_list.include?(token)
      }
    end
  end
end
