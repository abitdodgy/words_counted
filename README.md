# Words Counted

This Ruby gem is a word counter that includes some handy utility methods. It lets you send in a string of text and count the number of words, get the words sorted by number occurrences, get the highest occurring words, and few more things.

### Features

1. Count the number of words in a string.
2. Get a hash map of words and the number of times they occur.
3. Get a hash map of words and their lengthes.
4. Get the most occurring word(s) and its number of occurrences.
5. Get the longest word(s) and its length.
6. Ability to filter out words from the count. Useful if you don't want to count `a`, `the`, etc...
7. Filters special characters but respects hyphens and apostrophes.

See usage instructions for details on each feature.

## Installation

Add this line to your application's Gemfile:

    gem 'words_counted'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install words_counted

## Usage

Create an instance of `Counter` and pass in a string and an optional filter string.

```ruby
counter = WordsCounted::Counter.new(
	"We are all in the gutter, but some of us are looking at the stars."
)
```

#### `.word_count`

Returns the word count of a given string. The word count includes only alpha characters. Hyphenated and words with apostrophes are considered a single word.

```ruby
counter.word_count #=> 15
```

#### `.word_occurrences`

Returns a hash map of words and their number of occurrences. Uppercase and lowercase words are counted as the same word.

```ruby
counter.word_occurrences
#=> {
  "we"=>1,
  "are"=>2,
  "all"=>1,
  "in"=>1,
  "the"=>2,
  "gutter"=>1,
  "but"=>1,
  "some"=>1,
  "of"=>1,
  "us"=>1,
  "looking"=>1,
  "at"=>1,
  "stars"=>1
}
```

#### `.most_occurring_words`

Returns a two dimensional array of the most occurring word and its number of occurrences. In case there is a tie all tied words are returned.

```ruby
counter.most_occurring_words
#=>
  [
    ["are", 2],
    ["the", 2]
  ]
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
#=>
#  [
#    ["looking", 7]
#  ]
```

#### `.words`

Returns an array of words resulting from the string passed into the initialize method.

```ruby
counter.words
#=> ["We", "are", "all", "in", "the", "gutter", "but", "some", "of", "us", "are", "looking", "at", "the", "stars"]
```

## Filtering

You can pass in a space-delimited word list to filter words that you don't want to count. Filter words should be *lowercase*. The filter will remove both uppercase and lowercase variants of the word.

```ruby
WordsCounted::Counter.new("Magnificent! That was magnificent, Trevor.", "was magnificent")
#<WordsCounted::Counter:0x007fd4949f99d8 @words=["That", "Trevor"]>
```

## Gotchas

A hyphen use in leu of an *em* or *en* dash will form part of the word and throw off the `word_occurences` algorithm.

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

## About

Originally I wrote this program for a code challenge. My initial implementation was decent, but it could have been better. Thanks to [Dave Yarwood](http://codereview.stackexchange.com/a/47515/1563) for helping me improve my code. Some of this code is based on his recommendations. You can find the original implementation as well as the code review on [Code Review](http://codereview.stackexchange.com/questions/46105/a-ruby-string-analyser).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
