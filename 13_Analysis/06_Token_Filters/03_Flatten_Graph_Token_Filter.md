## Flatten Graph Token Filter

![Warning](/images/icons/warning.png)

This functionality is experimental and may be changed or removed completely in a future release. Elastic will take a best effort approach to fix any issues, but experimental features are not subject to the support SLA of official GA features.

The `flatten_graph` token filter accepts an arbitrary graph token stream, such as that produced by [Synonym Graph Token Filter](analysis-synonym-graph-tokenfilter.html), and flattens it into a single linear chain of tokens suitable for indexing.

This is a lossy process, as separate side paths are squashed on top of one another, but it is necessary if you use a graph token stream during indexing because a Lucene index cannot currently represent a graph. For this reason, it’s best to apply graph analyzers only at search time because that preserves the full graph structure and gives correct matches for proximity queries.

For more information on this topic and its various complexities, please read the [Lucene’s TokenStreams are actually graphs](http://blog.mikemccandless.com/2012/04/lucenes-tokenstreams-are-actually.html) blog post.
