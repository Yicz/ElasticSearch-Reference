# 以zip/tar.gz的方式进行安装

Elasticsearch 提供了zip/tar.gz的安装方式，可以使用这种方式在任何被支持的系统中进行安装。

最新的版本可以到[Download Elasticsearch](https://www.elastic.co/downloads/elasticsearch)下载，发布的版可以[Past Release Page](https://www.elastic.co/downloads/past-releases)查找下载

## 下载安装包

这里使用粟子为5.4.3.。符合本文档的调性。

```sh
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.3.zip
# 计算hash值
sha1sum elasticsearch-5.4.3.zip 
# 解压
unzip elasticsearch-5.4.3.zip
# 进入$ES_HOME(默认设置)
cd elasticsearch-5.4.3/ 
```

## 通过控制台运行ES

```sh
./bin/elasticsearch
```

默认作为前台程序运行，会在控制台输出日志，通过ctrl+c 进行停止项目。

## 检查ES的运行状态
可以直接请求默认端口（9200），查看他的响应内容

```sh
curl -XGET 'localhost:9200/?pretty'
## 返回响应
{
  "name" : "Cp8oag6",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "AT69_T_DTp-1qgIJlatQqA",
  "version" : {
    "number" : "5.4.3",
    "build_hash" : "f27399d",
    "build_date" : "2016-03-30T09:51:41.449Z",
    "build_snapshot" : false,
    "lucene_version" : "6.5.0"
  },
  "tagline" : "You Know, for Search"
}
```

## 后台

```sh
# -d  后台（daemon）运行
# -p  指定pid
./bin/elasticsearch -d -p pid
```

## 可配置参数运行
默认$ES_HOME/config/elasticsearch.yml文件会在ES启动的时候进行加载，该文件的详细说明在[这里](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/settings.html)

ES 使用命令行启动的时候，可以动态的配置参数进行运行，使用的语法为 -Ekey=value,如：

```sh
./bin/elasticsearch -d -Ecluster.name=my_cluster -Enode.name=node_1
```

> ### tips
> 通常,任何集群范围的设置(如cluster.name)应该添加到elasticsearch.yml配置文件,而任何特定于节点的设置,如node.name可以在命令行上指定。

## $ES_HOME文件布局说明

.zip/.tar.gz包完全是独立的。 默认情况下，所有文件和目录都包含在$ES_HOME中 - 解压档案时创建的目录。

这非常方便，因为您不必创建任何目录来开始使用Elasticsearch，卸载Elasticsearch就像移除$ ES_HOME目录一样简单。 但是，建议更改config目录，data目录和log目录的默认位置，以便稍后不会删除重要数据。

| 类型 | 说明/描述 | 默认位置 | 配置说明（elasticsearch.yml）|
|:---:|:---:|:---:|:---:|
| home| Elasticsearch的主目录叫做$ES_HOME|elasticsearch文件的位置||
|bin|二进制文件的位置，包含elasticsearch（主程序）和elasticsearch-plugin(插件安装)|$ES_HOME/bin||
|conf|包含elasticsearch.yml|$ES_HOME/config|path.conf|
|data|索引文件存放的位置|$ES_HOME/data|path.data|
|logs|日志存放位置|$ES_HOME/logs|path.log|
|plugins|插件安装位置|$ES_HOME/plugins||
|repo|共享文件系统存储库位置。 可以容纳多个地点。 文件系统存储库可以放置在此处指定的任何目录的任何子目录中。||path.repo|
|scripts|脚本文件的位置。|$ES_HOME/scripts|path.scripts|

# 下一步
你已经初步测试一个一个Elasticsearch应用过程，但在你进行实际应用的时候，你还需要学习如下的内容：

* 学习如何去[配置](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/settings.html)
* 配置[重要的设置](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/important-settings.html)
* 配置[系统参数](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/system-config.html)

