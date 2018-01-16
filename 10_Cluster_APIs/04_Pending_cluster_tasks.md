## 查询正在执行的任务 Pending cluster tasks

正在执行群集任务API返回尚未执行的任何群集级别更改（例如，创建索引，更新映射，分配或失败分片）的列表。


![Note](/images/icons/note.png)

此API返回群集状态的任何挂起更新的列表。 这些与[任务管理API](tasks.html)展示的任务不同，后者包括由用户发起的周期性任务和任务，例如节点状态，搜索查询或创建索引请求。 但是，如果用户启动的任务（如create index命令）导致集群状态更新，则此任务的活动可能由任务API和待处理集群任务API报告。
    
    
    $ curl -XGET 'http://localhost:9200/_cluster/pending_tasks'

通常会返回一个空的列表，因为集群状态的修改是非常地快速的。但是，如果有任务排队，输出将如下所示：
    
    
    {
       "tasks": [
          {
             "insert_order": 101,
             "priority": "URGENT",
             "source": "create-index [foo_9], cause [api]",
             "time_in_queue_millis": 86,
             "time_in_queue": "86ms"
          },
          {
             "insert_order": 46,
             "priority": "HIGH",
             "source": "shard-started ([foo_2][1], node[tMTocMvQQgGCkj7QDHl3OA], [P], s[INITIALIZING]), reason [after recovery from shard_store]",
             "time_in_queue_millis": 842,
             "time_in_queue": "842ms"
          },
          {
             "insert_order": 45,
             "priority": "HIGH",
             "source": "shard-started ([foo_2][0], node[tMTocMvQQgGCkj7QDHl3OA], [P], s[INITIALIZING]), reason [after recovery from shard_store]",
             "time_in_queue_millis": 858,
             "time_in_queue": "858ms"
          }
      ]
    }
