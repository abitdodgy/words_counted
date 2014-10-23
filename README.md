# Words Counted

Words Counted is a highly customisable Ruby string analyser. It includes many handy utility methods that go beyond word counting. You can use this gem to get word density, words and the number of times they occur, the highest occurring words, and few more things.

I use *word* loosely since you can pass the program any string you want: words, numbers, characters, etc...

Pass your own regular expression to customise the criteria for splitting strings. This makes Words Counted very flexible, whether you want to count words, numbers, or special characters.

### Features

* Get the following data from any string or readable file:
    * Word count
    * Unique word count
    * Word density
    * Character count
    * Average characters per word
    * A hash map of words and the number of times they occur
    * A hash map of words and their lengths
    * The longest word(s) and its length
    * The most occurring word(s) and its number of occurrences.
* A flexible way to exclude words (or anything) from the count. You can pass a **string**, a **regexp**, an **array**, or a **lambda**.
* Customisable criteria. Pass your own regexp rules to split strings if you prefer. The default regexp has two features:
  * Filters special characters but respects hyphens and apostrophes.
  * Plays nicely with diacritics (UTF and unicode characters): "São Paulo" is treated as `["São", "Paulo"]` and not `["S", "", "o", "Paulo"]`.
* Pass in a file path or a url instead of a string. Words Counted opens and reads files.

See usage instructions for details on each feature.

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
counter = WordsCounted.from_file("path/to/my/file.txt")
```

### API

#### `.word_count`

Returns the word count of a given string. The word count includes only alpha characters. Hyphenated and words with apostrophes are considered a single word. You can pass in your own regular expression if this is not desired behaviour.

```ruby
counter.word_count #=> 15
```

#### `.word_occurrences`

Returns an unsorted hash map of words and their number of occurrences. Uppercase and lowercase words are counted as the same word.

```ruby
counter.word_occurrences

{
  "we"      => 1,
  "are"     => 2,
  "all"     => 1,
  "in"      => 1,
  "the"     => 2,
  "gutter"  => 1,
  "but"     => 1,
  "some"    => 1,
  "of"      => 1,
  "us"      => 1,
  "looking" => 1,
  "at"      => 1,
  "stars"   => 1
}
```

#### `.sorted_word_occurrences`

Returns a two dimentional array of words and their number of occurrences sorted in descending order. Uppercase and lowercase words are counted as the same word.

```ruby
counter.sorted_word_occurrences

[
  ["the", 2],
  ["are", 2],
  ["we",  1],
  # ...
  ["all", 1]
]
```

#### `.most_occurring_words`

Returns a two dimensional array of the most occurring word and its number of occurrences. In case there is a tie all tied words are returned.

```ruby
counter.most_occurring_words

[ ["are", 2], ["the", 2] ]
```

#### `.word_lengths`

Returns an unsorted hash of words and their lengths.

```ruby
counter.word_lengths

{
  "We"      => 2,
  "are"     => 3,
  "all"     => 3,
  "in"      => 2,
  "the"     => 3,
  "gutter"  => 6,
  "but"     => 3,
  "some"    => 4,
  "of"      => 2,
  "us"      => 2,
  "looking" => 7,
  "at"      => 2,
  "stars"   => 5
}
```

#### `.sorted_word_lengths`

Returns a two dimentional array of words and their lengths sorted in descending order.

```ruby
counter.sorted_word_lengths

[
  ["looking", 7],
  ["gutter",  6],
  ["stars",   5],
  # ...
  ["in",      2]
]
```

#### `.longest_word`

Returns a two dimensional array of the longest word and its length. In case there is a tie all tied words are returned.

```ruby
counter.longest_words

[ ["looking", 7] ]
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

[
  ["are",     13.33],
  ["the",     13.33],
  ["but",     6.67],
  ["us",      6.67],
  ["of",      6.67],
  ["some",    6.67],
  ["looking", 6.67],
  ["gutter",  6.67],
  ["at",      6.67],
  ["in",      6.67],
  ["all",     6.67],
  ["stars",   6.67],
  ["we",      6.67]
]
```

#### `.char_count`

Returns the string's character count.

```ruby
counter.char_count              #=> 76
```

#### `.average_chars_per_word`

Returns the average character count per word.

```ruby
counter.average_chars_per_word  #=> 4
```

#### `.unique_word_count`

Returns the count of unique words in the string.

```ruby
counter.unique_word_count       #=> 13
```

## Excluding words from the analyser

You can exclude anything you want from the string you want to analyse by passing in the `exclude` option. The exclude option accepts a variety of filters.

1. A *space-delimited* list of candidates. The filter will remove both uppercase and lowercase variants of the candidate when applicable. Useful for excluding *the*, *a*, and so on.
2. An array of string candidates. For example: `['a', 'the']`.
3. A regular expression.
4. A lambda.

#### Using a string
```ruby
WordsCounted.count(
  "Magnificent! That was magnificent, Trevor.", exclude: "was magnificent"
)
counter.words
#=> ["That", "Trevor"]
```

#### Using an array
```ruby
WordsCounted.count("1 2 3 4 5 6", regexp: /[0-9]/, exclude: ['1', '2', '3'])
counter.words
#=> ["4", "5", "6"]
```

#### Using a regular expression
```ruby
WordsCounted.count("Hello Beirut", exclude: /Beirut/)
counter.words
#=> ["Hello"]
```

#### Using a lambda
```ruby
WordsCounted.count("1 2 3 4 5 6", regexp: /[0-9]/, exclude: ->(w) { w.to_i.even? })
counter.words
#=> ["1", "3", "5"]
```

## Passing in a Custom Regexp

Defining words is tricky. The default regexp accounts for letters, hyphenated words, and apostrophes. This means *twenty-one* is treated as one word. So is *Mohamad's*.

```ruby
/[\p{Alpha}\-']+/
```

But maybe you don't want to count words?&ndash;Well, analyse anything you want. What you analyse is only limited by your knowledge of regular expressions. Pass your own criteria as a Ruby regular expression to split your string as desired.

For example, if you wanted to include numbers in your analysis, you can override the regular expression:

```ruby
counter = WordsCounted.count("Numbers 1, 2, and 3", regexp: /[\p{Alnum}\-']+/)
counter.words
#=> ["Numbers", "1", "2", "and", "3"]
```

## Opening and Reading Files

Use the `from_file` method to open files. `from_file` accepts the same options as `count`. The file path can be a URL.

```ruby
counter = WordsCounted.from_file("url/or/path/to/file.text")
```

## Gotchas

A hyphen used in leu of an *em* or *en* dash will form part of the word. This affects the `word_occurences` algorithm.

```ruby
counter = WordsCounted.count("How do you do?-you are well, I see.")
counter.word_occurrences

{
  "how"   => 1,
  "do"    => 2,
  "you"   => 1,
  "-you"  => 1, # WTF, mate!
  "are"   => 1,
  "very"  => 1,
  "well"  => 1,
  "i"     => 1,
  "see"   => 1
}
```

In this example `-you` and `you` are counted as separate words. Writers should use the correct dash element, but this is not always true.

Another gotcha is that the default criteria does not include numbers in its analysis. Remember that you can pass your own regular expression if the default behaviour does not fit your needs.

## Road Map

1. Add ability to open URLs.
2. Add paragraph, sentence, average words per sentence, and average sentence chars counters.

#### Ability to open URLs

Something like...

```ruby
def self.count_from_url
  # open url and send string here after removing html
end
```

## But wait... wait a minute...

#### Isn't it better to write this in JavaScript?

![Picard face-palm](http://stream1.gifsoup.com/view3/1290449/picard-facepalm-o.gif "Picard face-palm")

## About

Originally I wrote this program for a code challenge on Treehouse. You can find the original implementation on [Code Review][1].

## Contributers

Thanks to Dave Yarwood for helping me improve my code. Some of my code is based on his recommendations. You can find the original program implementation, as well as Dave's code review, on [Code Review][1].

Thanks to [Wayne Conrad][2] for providing [an excellent code review][3], and improving the filter feature to well beyond what I can come up with.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


  [1]: http://codereview.stackexchange.com/questions/46105/a-ruby-string-analyser
  [2]: https://github.com/wconrad
  [3]: http://codereview.stackexchange.com/a/49476/1563
