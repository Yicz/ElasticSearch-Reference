## Analyzers

Elasticsearch ships with a wide range of built-in analyzers, which can be used in any index without further configuration:

[Standard Analyzer](analysis-standard-analyzer.html)
     The `standard` analyzer divides text into terms on word boundaries, as defined by the Unicode Text Segmentation algorithm. It removes most punctuation, lowercases terms, and supports removing stop words. 
[Simple Analyzer](analysis-simple-analyzer.html)
     The `simple` analyzer divides text into terms whenever it encounters a character which is not a letter. It lowercases all terms. 
[Whitespace Analyzer](analysis-whitespace-analyzer.html)
     The `whitespace` analyzer divides text into terms whenever it encounters any whitespace character. It does not lowercase terms. 
[Stop Analyzer](analysis-stop-analyzer.html)
     The `stop` analyzer is like the `simple` analyzer, but also supports removal of stop words. 
[Keyword Analyzer](analysis-keyword-analyzer.html)
     The `keyword` analyzer is a “noop” analyzer that accepts whatever text it is given and outputs the exact same text as a single term. 
[Pattern Analyzer](analysis-pattern-analyzer.html)
     The `pattern` analyzer uses a regular expression to split the text into terms. It supports lower-casing and stop words. 
[Language Analyzers](analysis-lang-analyzer.html)
     Elasticsearch provides many language-specific analyzers like `english` or `french`. 
[Fingerprint Analyzer](analysis-fingerprint-analyzer.html)
     The `fingerprint` analyzer is a specialist analyzer which creates a fingerprint which can be used for duplicate detection. 

### Custom analyzers

If you do not find an analyzer suitable for your needs, you can create a [`custom`](analysis-custom-analyzer.html) analyzer which combines the appropriate [character filters](analysis-charfilters.html), [tokenizer](analysis-tokenizers.html), and [token filters](analysis-tokenfilters.html).
