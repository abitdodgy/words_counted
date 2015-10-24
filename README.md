# WordsCounted

WordsCounted is a Ruby NLP (natural language processor). WordsCounted lets you implement powerful tokensation strategies with a very flexible tokeniser class. [Consult the documentation][2] for more information.

<a href="http://badge.fury.io/rb/words_counted">
  <img src="https://badge.fury.io/rb/words_counted@2x.png" alt="Gem Version" height="18">
</a>

### Demo

Visit [this website][4] for an example of what the gem can do.

### Features

* Out of the box, get the following data from any string or readable file, or URL:
    * Token count and unique token count
    * Token densities, frequencies, and lengths
    * Char count and average chars per token
    * The longest tokens and their lengths
    * The most frequent tokens and their frequencies.
* A flexible way to exclude tokens from the tokeniser. You can pass a **string**, **regexp**, **symbol**, **lambda**, or an **array** of any combination of those types for powerful tokenisation strategies.
* Pass your own regexp rules to the tokeniser if you prefer. The default regexp filters special characters but keeps hyphens and apostrophes. It also plays nicely with diacritics (UTF and unicode characters): *Bayrūt* is treated as `["Bayrūt"]` and not `["Bayr", "ū", "t"]`, for example.
* Opens and reads files. Pass in a file path or a url instead of a string.

See usage instructions for more details.

## Installation

Add this line to your application's Gemfile:

    gem 'words_counted'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install words_counted

## Usage

Pass in a string or a file path, and an optional filter and/or regexp.

```ruby
counter = WordsCounted.count(
  "We are all in the gutter, but some of us are looking at the stars."
)

# Using a file
counter = WordsCounted.from_file("path/or/url/to/my/file.txt")
```

`.count` and `.from_file` are convenience methods that take an input, tokenise it, and return an instance of `Counter` initialized with the tokens. The `Tokeniser` and `Counter` classes can be used alone, however.

## API

**`WordsCounted.count(input, options = {})`**

Tokenises input and initializes a `Counter` object with the resulting tokens.

```ruby
counter = WordsCounted.count("Hello Beirut!")
````

Accepts two options: `exclude` and `regexp`. See [Excluding tokens from the analyser][5] and [Passing in a custom regexp][6] respectively.

**`WordsCounted.from_file(path, options = {})`**

Reads and tokenises a file, and initializes a `Counter` object with the resulting tokens.

```ruby
counter = WordsCounted.count("hello_beirut.txt")
````

Accepts the same options as `.count`.

### Tokeniser

The tokeniser allows you to tokenise text in a variety of ways. You can pass in your own rules for tokenisation, and apply a powerful filter with any combination of rules as long as they can boil down into a lambda.

Out of the box the tokeniser includes only alpha chars. Hyphenated tokens and tokens with apostrophes are considered a single token.

**`#tokenise([pattern: TOKEN_REGEXP, exclude: nil])`**

```ruby
tokeniser = Tokeniser.new("Hello Beirut!").tokenise

# With `exclude`
tokeniser = Tokeniser.new("Hello Beirut!").tokenise(exclude: "hello")

# With `pattern`
tokeniser = Tokeniser.new("I <3 Beirut!").tokenise(pattern: /[a-z]/i)
```

See [Excluding tokens from the analyser][5] and [Passing in a custom regexp][6] for more information.

### Counter

The `Counter` class allows you to collect various statistics from an array of tokens.

**`#token_count`**

Returns the token count of a given string.

```ruby
counter.token_count #=> 15
```

**`#token_frequency`**

Returns a sorted (unstable) two-dimensional array where each element is a token and its frequency. The array is sorted by frequency in descending order.

```
counter.token_frequency

[
  ["the", 2],
  ["are", 2],
  ["we",  1],
  # ...
  ["all", 1]
]
```

**`#most_frequent_tokens`**

Returns a hash where each key-value pair is a token and its frequency.

```ruby
counter.most_frequent_tokens

{ "are" => 2, "the" => 2 }
```

**`#token_lengths`**

Returns a sorted (unstable) two-dimentional array where each element contains a token and its length. The array is sorted by length in descending order.

```ruby
counter.token_lengths

[
  ["looking", 7],
  ["gutter",  6],
  ["stars",   5],
  # ...
  ["in",      2]
]
```

**`#longest_tokens`**

Returns a hash where each key-value pair is a token and its length.


```ruby
counter.longest_tokens

{ "looking" => 7 }
```

**`#token_density([ precision: 2 ])`**

Returns a sorted (unstable) two-dimentional array where each element contains a token and its density as a float, rounded to a precision of two. The array is sorted by density in descending order. It accepts a `precision` argument, which must be a float.

```ruby
counter.token_density

[
  ["are",     0.13],
  ["the",     0.13],
  ["but",     0.07 ],
  # ...
  ["we",      0.07 ]
]
```

**`#char_count`**

Returns the char count of tokens.

```ruby
counter.char_count #=> 76
```

**`#average_chars_per_token([ precision: 2 ])`**

Returns the average char count per token rounded to two decimal places. Accepts a precision argument which defaults to two. Precision must be a float.

```ruby
counter.average_chars_per_token #=> 4
```

**`#unique_token_count`**

Returns the number unique tokens.

```ruby
counter.unique_token_count #=> 13
```

## Excluding tokens from the tokeniser

You can exclude anything you want from the input by passing the `exclude` option. The exclude option accepts a variety of filters and is extremely flexible.

1. A *space-delimited* string. The filter will normalise the string.
2. A regular expression.
3. A lambda.
4. A symbol that is convertible to a proc.  For example `:odd?`.
5. An array of any combination of the above.

```ruby
tokeniser =
  WordsCounted::Tokeniser.new(
    "Magnificent! That was magnificent, Trevor.", exclude: "was magnificent"
  )

# Using a string
tokeniser.tokenise(exclude: "was magnificent")
tokeniser.tokens
# => ["that", "trevor"]

# Using a regular expression
tokeniser.tokenise(exclude: /Trevor/)
counter.tokens
# => ["that", "was", "magnificent"]

# Using a lambda
tokeniser.tokenise(exclude: ->(t) { t.length < 4 })
counter.tokens
# => ["magnificent", "trevor"]

# Using symbol
tokeniser = WordsCounted::Tokeniser.new("Hello! محمد")
t.tokenise(exclude: :ascii_only?)
# => ["محمد"]

# Using an array
tokeniser = WordsCounted::Tokeniser.new(
  "Hello! اسماءنا هي محمد، كارولينا، سامي، وداني"
)
tokeniser.tokenise(
  exclude: [:ascii_only?, /محمد/, ->(t) { t.length > 6}, "و"]
)
# => ["هي", "سامي", "ودان"]
```

## Passing in a Custom Regexp

The default regexp accounts for letters, hyphenated tokens, and apostrophes. This means *twenty-one* is treated as one token. So is *Mohamad's*.

```ruby
/[\p{Alpha}\-']+/
```

You can pass your own criteria as a Ruby regular expression to split your string as desired.

For example, if you wanted to include numbers, you can override the regular expression:

```ruby
counter = WordsCounted.count("Numbers 1, 2, and 3", regexp: /[\p{Alnum}\-']+/)
counter.tokens
#=> ["Numbers", "1", "2", "and", "3"]
```

## Opening and Reading Files

Use the `from_file` method to open files. `from_file` accepts the same options as `.count`. The file path can be a URL.

```ruby
counter = WordsCounted.from_file("url/or/path/to/file.text")
```

## Gotchas

A hyphen used in leu of an *em* or *en* dash will form part of the token. This affects the tokeniser algorithm.

```ruby
counter = WordsCounted.count("How do you do?-you are well, I see.")
counter.token_frequency

[
  ["do",   2],
  ["how",  1],
  ["you",  1],
  ["-you", 1], # WTF, mate!
  ["are",  1],
  # ...
]
```

In this example `-you` and `you` are separate tokens. Also, the tokeniser does not include numbers by default. Remember that you can pass your own regular expression if the default behaviour does not fit your needs.

### A note on case sensitivity

The program will normalise (downcase) all incoming strings for consistency and filters.

## Road Map

1. Add ability to open URLs.
2. Add Ngram support.

#### Ability to read URLs

Something like...

```ruby
def self.from_url
  # open url and send string here after removing html
end
```

## About

Originally I wrote this program for a code challenge on Treehouse. You can find the original implementation on [Code Review][1].

## Contributors

See [contributors][3]. Not listed there is [Dave Yarwood][1].

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


  [1]: http://codereview.stackexchange.com/questions/46105/a-ruby-string-analyser
  [2]: http://www.rubydoc.info/gems/words_counted
  [3]: https://github.com/abitdodgy/words_counted/graphs/contributors
  [4]: http://rubywordcount.com
  [5]: https://github.com/abitdodgy/words_counted#excluding-tokens-from-the-analyser
  [6]: https://github.com/abitdodgy/words_counted#passing-in-a-custom-regexp
