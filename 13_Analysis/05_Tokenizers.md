## Tokenizers

A _tokenizer_ receives a stream of characters, breaks it up into individual _tokens_ (usually individual words), and outputs a stream of _tokens_. For instance, a [`whitespace`](analysis-whitespace-tokenizer.html) tokenizer breaks text into tokens whenever it sees any whitespace. It would convert the text `"Quick brown fox!"` into the terms `[Quick, brown, fox!]`.

The tokenizer is also responsible for recording the order or _position_ of each term (used for phrase and word proximity queries) and the start and end _character offsets_ of the original word which the term represents (used for highlighting search snippets).

Elasticsearch has a number of built in tokenizers which can be used to build [custom analyzers](analysis-custom-analyzer.html).

### Word Oriented Tokenizers

The following tokenizers are usually used for tokenizing full text into individual words:

[Standard Tokenizer](analysis-standard-tokenizer.html)
     The `standard` tokenizer divides text into terms on word boundaries, as defined by the Unicode Text Segmentation algorithm. It removes most punctuation symbols. It is the best choice for most languages. 
[Letter Tokenizer](analysis-letter-tokenizer.html)
     The `letter` tokenizer divides text into terms whenever it encounters a character which is not a letter. 
[Lowercase Tokenizer](analysis-lowercase-tokenizer.html)
     The `lowercase` tokenizer, like the `letter` tokenizer, divides text into terms whenever it encounters a character which is not a letter, but it also lowercases all terms. 
[Whitespace Tokenizer](analysis-whitespace-tokenizer.html)
     The `whitespace` tokenizer divides text into terms whenever it encounters any whitespace character. 
[UAX URL Email Tokenizer](analysis-uaxurlemail-tokenizer.html)
     The `uax_url_email` tokenizer is like the `standard` tokenizer except that it recognises URLs and email addresses as single tokens. 
[Classic Tokenizer](analysis-classic-tokenizer.html)
     The `classic` tokenizer is a grammar based tokenizer for the English Language. 
[Thai Tokenizer](analysis-thai-tokenizer.html)
     The `thai` tokenizer segments Thai text into words. 

### Partial Word Tokenizers

These tokenizers break up text or words into small fragments, for partial word matching:

[N-Gram Tokenizer](analysis-ngram-tokenizer.html)
     The `ngram` tokenizer can break up text into words when it encounters any of a list of specified characters (e.g. whitespace or punctuation), then it returns n-grams of each word: a sliding window of continuous letters, e.g. `quick` → `[qu, ui, ic, ck]`. 
[Edge N-Gram Tokenizer](analysis-edgengram-tokenizer.html)
     The `edge_ngram` tokenizer can break up text into words when it encounters any of a list of specified characters (e.g. whitespace or punctuation), then it returns n-grams of each word which are anchored to the start of the word, e.g. `quick` → `[q, qu, qui, quic, quick]`. 

### Structured Text Tokenizers

The following tokenizers are usually used with structured text like identifiers, email addresses, zip codes, and paths, rather than with full text:

[Keyword Tokenizer](analysis-keyword-tokenizer.html)
     The `keyword` tokenizer is a “noop” tokenizer that accepts whatever text it is given and outputs the exact same text as a single term. It can be combined with token filters like [`lowercase`](analysis-lowercase-tokenfilter.html) to normalise the analysed terms. 
[Pattern Tokenizer](analysis-pattern-tokenizer.html)
     The `pattern` tokenizer uses a regular expression to either split text into terms whenever it matches a word separator, or to capture matching text as terms. 
[Path Tokenizer](analysis-pathhierarchy-tokenizer.html)
     The `path_hierarchy` tokenizer takes a hierarchical value like a filesystem path, splits on the path separator, and emits a term for each component in the tree, e.g. `/foo/bar/baz` → `[/foo, /foo/bar, /foo/bar/baz ]`. 
