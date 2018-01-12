##  通用建议 General recommendations

### 不要返回大的结果集 Don’t return large result sets

Elasticsearch被设计为一个搜索引擎，这使得它能够很好地找回匹配查询的顶级文档。 但是，对于落入数据库领域的工作负载来说，这并不是一件好事，例如检索与特定查询匹配的所有文档。 如果您需要这样做，请确保使用[Scroll](search-request-scroll.html)API。

### 避免大文档 Avoid large documents

默认设置了 [`http.max_context_length`](modules-http.html)为100Mb,ES会拒绝大过这个设置的文档。你可以修改这个值，会内部Lucene对文档的最大限制是2GB


Even without considering hard limits, large documents are usually not practical. Large documents put more stress on network, memory usage and disk, even for search requests that do not request the `_source` since Elasticsearch needs to fetch the `_id` of the document in all cases, and the cost of getting this field is bigger for large documents due to how the filesystem cache works. Indexing this document can use an amount of memory that is a multiplier of the original size of the document. Proximity search (phrase queries for instance) and [highlighting](search-request-highlighting.html) also become more expensive since their cost directly depends on the size of the original document.

It is sometimes useful to reconsider what the unit of information should be. For instance, the fact you want to make books searchable doesn’t necesarily mean that a document should consist of a whole book. It might be a better idea to use chapters or even paragraphs as documents, and then have a property in these documents that identifies which book they belong to. This does not only avoid the issues with large documents, it also makes the search experience better. For instance if a user searches for two words `foo` and `bar`, a match across different chapters is probably very poor, while a match within the same paragraph is likely good.

### 避免稀疏 Avoid sparsity

The data-structures behind Lucene, which Elasticsearch relies on in order to index and store data, work best with dense data, ie. when all documents have the same fields. This is especially true for fields that have norms enabled (which is the case for `text` fields by default) or doc values enabled (which is the case for numerics, `date`, `ip` and `keyword` by default).

The reason is that Lucene internally identifies documents with so-called doc ids, which are integers between 0 and the total number of documents in the index. These doc ids are used for communication between the internal APIs of Lucene: for instance searching on a term with a `match` query produces an iterator of doc ids, and these doc ids are then used to retrieve the value of the `norm` in order to compute a score for these documents. The way this `norm` lookup is implemented currently is by reserving one byte for each document. The `norm` value for a given doc id can then be retrieved by reading the byte at index `doc_id`. While this is very efficient and helps Lucene quickly have access to the `norm` values of every document, this has the drawback that documents that do not have a value will also require one byte of storage.

In practice, this means that if an index has `M` documents, norms will require `M` bytes of storage **per field** , even for fields that only appear in a small fraction of the documents of the index. Although slightly more complex with doc values due to the fact that doc values have multiple ways that they can be encoded depending on the type of field and on the actual data that the field stores, the problem is very similar. In case you wonder: `fielddata`, which was used in Elasticsearch pre-2.0 before being replaced with doc values, also suffered from this issue, except that the impact was only on the memory footprint since `fielddata` was not explicitly materialized on disk.

Note that even though the most notable impact of sparsity is on storage requirements, it also has an impact on indexing speed and search speed since these bytes for documents that do not have a field still need to be written at index time and skipped over at search time.

It is totally fine to have a minority of sparse fields in an index. But beware that if sparsity becomes the rule rather than the exception, then the index will not be as efficient as it could be.

This div mostly focused on `norms` and `doc values` because those are the two features that are most affected by sparsity. Sparsity also affect the efficiency of the inverted index (used to index `text`/`keyword` fields) and dimensional points (used to index `geo_point` and numerics) but to a lesser extent.

Here are some recommendations that can help avoid sparsity:

#### 避免在同一个索引中设置不相关的数据 Avoid putting unrelated data in the same index

您应该避免将具有完全不同结构的文档放在同一个索引中，以避免稀疏。 将这些文档放入不同的索引通常会更好，您也可以考虑给这些较小的索引分配更少的分片，因为它们将包含更少的文档。

请注意，如果您需要在文档之间使用父/子关系，则此建议不适用，因为此功能仅支持位于同一索引中的文档。

#### 规范化文档结构 Normalize document structures

即使你真的需要把不同类型的文件放在同一个索引中，也许有机会减少稀疏性。 例如，如果索引中的所有文档都有一个timestamp字段，但有一些叫做timestamp，而另外一些叫`creation_date`，那么它将有助于重命名它，以便所有文档对于相同的数据具有相同的字段名称。

#### 避免单个索引有多个类型 Avoid types

多类型可能听起来像是将多个租户存储在单个索引中的好方法。 它们不是：由于类型将所有内容都存储在单个索引中，因此在单个索引中具有不同字段的多个类型也会由于稀疏性而导致问题，如上所述。 如果你的类型没有非常相似的映射，你可能要考虑将它们移动到一个专门的索引。


#### 在稀疏字段上禁用`norms`和`doc_values` Disable `norms` and `doc_values` on sparse fields

如果以上建议都不适用于您的情况，那么您可能需要检查您的稀疏字段是否确实需要`norms`和`doc_values`。 如果字段上不需要生成分数，则可以禁用`norms`，对于仅用于过滤的字段，这通常是正确的。 对于既不用于排序也不用于聚合的字段，可以禁用`doc_values`。 请注意，这个决定不应该轻易做出来，因为这些参数不能在实时索引中更改，所以如果您意识到需要`norms`或'doc_values`，则必须重新索引。
