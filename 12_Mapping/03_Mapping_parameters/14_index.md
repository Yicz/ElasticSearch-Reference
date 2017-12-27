## `index`

The `index` option controls whether field values are indexed. It accepts `true` or `false`. Fields that are not indexed are not queryable.

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

For the legacy mapping type [`string`](string.html) the `index` option only accepts legacy values `analyzed` (default, treat as full-text field), `not_analyzed` (treat as keyword field) and `no`.
