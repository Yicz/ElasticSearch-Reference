# 摄取节点 Ingest Node

您可以使用摄取节点在实际索引之前进行文档的预处理。 此预处理由会拦截bulk和index请求的摄取节点进行，应用并转换，然后将文档传递回index或bulk API。

您可以启用任何节点上的功能工陟，甚至有专门的摄取节点。 在所有节点上默认启用摄取节点。 要在节点上禁用摄取节点，请在`elasticsearch.yml`文件中配置以下设置：
    
    node.ingest: false

为了在索引之前预处理文档，您要定义一个[管道 pipeline]（pipeline.html），指定一系列[处理器 processors ](ingest-processors.html)。 每个处理器都以某种方式转换文档。 例如，您可能有一个管道由一个处理器组成，该处理器从文档中删除一个字段，然后是另一个处理器，用于重命名字段。

要使用管道，只需在索引或批量请求中指定`pipeline`参数，以告知采集节点要使用哪个管道。 例如：
    
    PUT my-index/my-type/my-id?pipeline=my_pipeline_id
    {
      "foo": "bar"
    }

有关创建，添加和删除管道的更多信息，请参见[ingest API])ingest-apis.html)。