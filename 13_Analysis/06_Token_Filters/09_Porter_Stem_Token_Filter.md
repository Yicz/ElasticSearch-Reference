## Porter Stem Token Filter

A token filter of type `porter_stem` that transforms the token stream as per the Porter stemming algorithm.

Note, the input to the stemming filter must already be in lower case, so you will need to use [Lower Case Token Filter](analysis-lowercase-tokenfilter.html) or [Lower Case Tokenizer](analysis-lowercase-tokenizer.html) farther down the Tokenizer chain in order for this to work properly!. For example, when using custom analyzer, make sure the `lowercase` filter comes before the `porter_stem` filter in the list of filters.
