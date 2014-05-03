# Words Counted

Words Counted is a Ruby word (or anything--see custom regexp) counter and string analyser. It includes some handy utility methods that go beyond word counting. You can use this gem to get word desnity, words and their number of occurrences, the highest occurring words, and few more things.

You can also pass in your custom criteria for splitting strings in the form of a custom regexp, which affords you a great deal of flexibility, whether you want to count words, numbers, or special characters.

### Features

1. Count the number of words in a string.
2. Get a hash map of words and the number of times they occur.
3. Get a hash map of words and their lengthes.
4. Get the most occurring word(s) and its number of occurrences.
5. Get the longest word(s) and its length.
6. Ability to filter out words from the count. Useful if you don't want to count `a`, `the`, etc...
7. Filters special characters but respects hyphens and apostrophes.
8. Plays nicely with diacritics (utf and unicode characters): "São Paulo" is treated as `["São", "Paulo"]` and not `["S", "", "o", "Paulo"]`
9. Customisable criteria. Pass in your own regexp rules to split strings if you prefer.
10. Get `char_count` and `average_chars_per_word`.
11. Get unique word count.

See usage instructions for details on each feature.

## Installation

Add this line to your application's Gemfile:

    gem 'words_counted'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install words_counted

## Usage

Create an instance of `Counter` and pass in a string and an optional filter and/or regexp.

```ruby
counter = WordsCounted::Counter.new(
	"We are all in the gutter, but some of us are looking at the stars."
)
```

### API

#### `.word_count`

Returns the word count of a given string. The word count includes only alpha characters. Hyphenated and words with apostrophes are considered a single word. You can pass in your own regexp if this is not desired behaviour.

```ruby
counter.word_count #=> 15
```

#### `.word_occurrences`

Returns a hash map of words and their number of occurrences. Uppercase and lowercase words are counted as the same word.

```ruby
counter.word_occurrences
#
#  {
#    "we" => 1,
#    "are" => 2,
#    "all" => 1,
#    "in" => 1,
#    "the" => 2,
#    "gutter" => 1,
#    "but" => 1,
#    "some" => 1,
#    "of" => 1,
#    "us" => 1,
#    "looking" => 1,
#    "at" => 1,
#    "stars" => 1
#  }
#
```

#### `.most_occurring_words`

Returns a two dimensional array of the most occurring word and its number of occurrences. In case there is a tie all tied words are returned.

```ruby
counter.most_occurring_words
#
#  [
#    ["are", 2],
#    ["the", 2]
#  ]
#
```

#### `.word_lengths`

Returns a hash of words and their lengths.

```ruby
counter.word_lengths
#
#  {
#    "We" => 2,
#    "are" => 3,
#    "all" => 3,
#    "in" => 2,
#    "the" => 3,
#    "gutter" => 6,
#    "but" => 3,
#    "some" => 4,
#    "of" => 2,
#    "us" => 2,
#    "looking" => 7,
#    "at" => 2,
#    "stars" => 5
#  }
#
```

#### `.longest_word`

Returns a two dimensional array of the longest word and its length. In case there is a tie all tied words are returned.

```ruby
counter.longest_words
#
#  [
#    ["looking", 7]
#  ]
#
```

#### `.words`

Returns an array of words resulting from the string passed into the initialize method.

```ruby
counter.words
#=> ["We", "are", "all", "in", "the", "gutter", "but", "some", "of", "us", "are", "looking", "at", "the", "stars"]
```

#### `.word_density`

Returns a two-dimentional array of words and their density.

```ruby
counter.word_density
#
#  [
#    ["are", 13.33],
#    ["the", 13.33],
#    ["but", 6.67],
#    ["us", 6.67],
#    ["of", 6.67],
#    ["some", 6.67],
#    ["looking", 6.67],
#    ["gutter", 6.67],
#    ["at", 6.67],
#    ["in", 6.67],
#    ["all", 6.67],
#    ["stars", 6.67],
#    ["we", 6.67]
#  ]
#
```

## Filtering

You can pass in a *space-delimited* word list to filter words that you don't want to count. The filter will remove both uppercase and lowercase variants of the word.

```ruby
WordsCounted::Counter.new(
  "Magnificent! That was magnificent, Trevor.", filter: "was magnificent"
)
counter.words
#=> ["That", "Trevor"]
```

## Passing in a Custom Regexp

Defining words is tricky business. Out of the box, the default regexp accounts for letters, hyphenated words, and apostrophes. This means `twenty-one` is treated as one word. So is `Mohamad's`.

```ruby
/[\p{Alpha}\-']+/
```

But maybe you don't want to count words? Well, count anything you want. What you count is only limited by your knowledge of regular expressions. Pass in your own criteria in the form of a Ruby regexp to split your string as desired.

For example, if you wanted to count numbers as words, you could pass the following regex instead of the default one.

```ruby
counter = WordsCounted::Counter.new("I am 007.", regex: /[\p{Alnum}\-']+/)
counter.words
#=> ["I", "am", "007"]
```

## Gotchas

A hyphen used in leu of an *em* or *en* dash will form part of the word and throw off the `word_occurences` algorithm.

```ruby
counter = WordsCounted::Counter.new("How do you do?-you are well, I see.")
#<WordsCounted::Counter:0x007fd494252518 @words=["How", "do", "you", "do", "-you", "are", "well", "I", "see"]>

counter.word_occurrences
#
#  {
#    "how" => 1,
#    "do" => 2,
#    "you" => 1,
#    "-you" => 1, # WTF, mate!
#    "are" => 1,
#    "very" => 1,
#    "well" => 1,
#    "i" => 1,
#    "see" => 1
#  }
#
```

In this example, `-you` and `you` are counted as separate words. Writers should use the correct dash element, but this is not always the case.

Another gotcha is that the default criteria does not count numbers as words. Remember that you can pass in your own regexp if the default solution does not fit your needs.

## Road Map

1. Add ability to open files or URLs.
2. Add paragraph, sentence, average words per sentence, and average sentence chars counters.

#### Ability to open files or urls

Maybe I can some class methods to open the file and init the counter class.

```ruby
def self.count_from_url
  new # open url and send string here after removing html
end

def self.from_file
  new # open file and send string here.
end
```

## But wait... wait a minute...

#### Isn't it better to write this in JavaScript?

![Picard face-palm](http://stream1.gifsoup.com/view3/1290449/picard-facepalm-o.gif "Picard face-palm")

## About

Originally I wrote this program for a code challenge. My initial implementation was decent, but it could have been better. Thanks to [Dave Yarwood](http://codereview.stackexchange.com/a/47515/1563) for helping me improve my code. Some of this code is based on his recommendations. You can find the original implementation as well as the code review on [Code Review](http://codereview.stackexchange.com/questions/46105/a-ruby-string-analyser).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
