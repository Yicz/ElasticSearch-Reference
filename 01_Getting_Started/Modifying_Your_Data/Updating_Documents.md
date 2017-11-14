# 更新文档

除了可以建立和替换文档，我们还可以更新一个文档。 请注意，Elasticsearch实际上并没有在原地进行更新。 而是在我们进行更新的时候，Elasticsearch都会将旧文档标记为删除状态，然后索引一个新文档，一次性应用更新。

此示例显示如何通过将名称字段更改为“Jane Doe”来更新以前的文档（ID为1）：

```sh
POST /customer/external/1/_update?pretty
{
  "doc": { "name": "Jane Doe" }
}
```

这个例子展示了如何通过改变名称字段为“Jane Doe”来更新我们以前的文档（ID为1），同时为其添加一个年龄字段：

```sh
POST /customer/external/1/_update?pretty
{
  "doc": { "name": "Jane Doe", "age": 20 }
}
```
更新也可以通过使用简单的脚本来执行。 此示例使用脚本将年龄增加5：

```sh
POST /customer/external/1/_update?pretty
{
  "script" : "ctx._source.age += 5"
}
```

在上面的例子中，ctx._source引用了即将被更新的当前源文档。

***请注意，在撰写本文时，更新一次只能在单个文档上执行。 将来，Elasticsearch可以提供在给定查询条件（如SQL UPDATE-WHERE语句）的情况下更新多个文档的能力。***