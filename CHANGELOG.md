## Version 1.0

This version brings lots of improvements to code organisation. The tokeniser has been extracted into its own class. All methods in `Counter` have either renamed or deprecated. Deprecated methods and their tests have moved into their own modules. Using them will trigger warnings with upgrade instructions outlined below.

1. Extracted tokenisation behaviour from `Counter` into a `Tokeniser` class.
2. Deprecated all methods that have `word` in their name. Most are renamed such that `word` became `token`. They will be removed in version 1.1.
  - Deprecated `word_count` in favor of `token_count`
  - Deprecated `unique_word_count` in favor of `unique_token_count`
  - Deprecated `word_occurrences` and `sorted_word_occurrences` in favor of `token_frequency`
  - Deprecated `word_lengths` and `sorted_word_lengths` in favor of `token_lenghts`
  - Deprecated `word_density` in favor of `token_density`
  - Deprecated `most_occurring_words` in favor of `most_frequent_tokens`
  - Deprecated `longest_words` in favor of `longest_tokens`
  - Deprecated `average_chars_per_word` in favor of `average_chars_per_token`
  - Deprecated `count`. Use `Array#count` instead.
3. `token_lengths`, which replaces `word_lengths` returns a sorted two-dimensional array instead of a hash. It behaves exactly like `sorted_word_lengths` which has been deprecated. Use `token_lengths.to_h` for old behaviour.
4. `token_frequency`, which replaces `word_occurences` returns a sorted two-dimensional array instead of a hash. It behaves like `sorted_word_occurrences` which has been deprecated. Use `token_frequency.to_h` for old behaviour.
5. `token_density`, which replaces `word_density`, returns a decimal with a precision of 2, not a percent. Use `token_density * 100` for old behaviour.
6. Add a refinement to Hash under `lib/refinements/hash_refinements.rb` to quickly sort by descending value.
7. Extracted all deprecated methods to their own module, and their tests to their own spec file.
8. Added a base `words_counted_spec.rb` and moved `.from_file` test to the new file.
9. Added Travis continuous integration.
10. Add documentation to the code.

## Version 0.1.5

1. Removed `to_f` from the dividend in `average_chars_per_word` and `word_densities`. The divisor is a float, and dividing by a float returns a float.
2. Added `# -*- encoding : utf-8 -*-` to all files. See [pull request][1].
3. Added this changelog.

  [1]: https://github.com/abitdodgy/words_counted/pull/12
