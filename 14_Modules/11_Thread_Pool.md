## 线程池 Thread Pool

一个节点拥有多个线程池，以改善线程内存消耗在节点内的管理方式。 这些线程池中还有关联队列，这些队列允许请求挂起被保留而不是丢弃。

线程池有许多种，但下面是重要：
`generic`

    用于普通的操作（如：后台节点的发现），线程池的类型是`scaling`可伸缩的。
`index`

    用于`index/delete`操作，线程池的类型是根据可用处理器的大小进行设置的（`fixed 固定`）,队列的大小是`200`,最大是`1 + # of available processors`. （处理器数量+1）
`search`
    
    用于`count/search/suggest`操作，线程池的类型是根据可用处理器的大小进行设置的（`fixed 固定`），转换公式为``int((# of available_processors * 3) / 2) + 1``,队列的大小是`1000`
`get`
    
     用于`get`操作，线程池的类型是根据可用处理器的大小进行设置的（`fixed 固定`），转换公式为``int(# of available_processors )``,队列的大小是`1000`
`bulk`

     用于`bulk`操作，线程池的类型是根据可用处理器的大小进行设置的（`fixed 固定`），转换公式为``int(# of available_processors )``,队列的大小是`200`,最大是`1 + # of available processors`（处理器数量+1）
`snapshot`

     用于`snapshot/restore`操作，线程池的类型是可拓展的（`scaling`）并会至少保留5分钟到最大`min(5, (# of available processors)/2)`。
`warmer`

     用于`segment warm-up（段预处理）`操作，线程池的类型是可拓展的（`scaling`）并会至少保留5分钟到最大`min(5, (# of available processors)/2)`。
`refresh`

    用于`refresh`操作，线程池的类型是可拓展的（`scaling`）并会至少保留5分钟到最大`min(10, (# of available processors)/2)`。
`listener`

   当线程监听被设置为true时，主要为java客户端执行行为时监听，线程池的类型是可拓展的（`scaling`）并会至少保留5分钟到最大`min(10, (# of available processors)/2)`。

修改一个指定类型的线程池大小可以在yaml文件中进行指定相关的参数，例如，修改`index`类型的线程池并设置更多的线程
    
    thread_pool:
        index:
            size: 30

###  线程池类型 Thread pool types

下面列举了相关的线程池类型和它们相关的参数:

#### 固定 `fixed`

固定类型的线程池数量是一定的

“固定”线程池保存固定大小的线程，以处理具有队列（可选地绑定）的请求，用于没有线程服务它们的未决请求。

`size`是控制线程数量的大小，默认是处理核心数*5.

`queue_size`保存没有进行处理的线程正在在排队的请求的数量。默认地当队列满的时候还有请求，该请求会被丢弃。`-1`值代表不设置上限。

    thread_pool:
        index:
            size: 30
            queue_size: 1000

#### 可以拓展 `scaling`

“可以拓展”线程池包含一个动态数量的线程。 这个数字与工作量成正比，并且在`core`和`max`参数的值之间变化。

`keep_alive`参数决定一个线程应该在没有任务处理的情况下，线程池中保留多久。    
    
    thread_pool:
        warmer:
            core: 1
            max: 8
            keep_alive: 2m

### 处理器设置 Processors setting

处理器的数量被自动检测，线程池的设置是根据它自动设置的。 在某些情况下，可以重写检测到的处理器数量。 这可以通过明确设置“processors”设置来完成。

    processors: 2

有几个用于显式覆盖`processors`设置的用例：

  1. 如果您在同一主机上运行Elasticsearch的多个实例，但希望Elasticsearch调整其线程池的大小，就好像它只有CPU的一小部分一样，您应该将`processors`设置覆盖到所需的分数（例如，如果您 在16核机器上运行Elasticsearch的两个实例，将“processors”设置为8）。 请注意，这是一个专家级的用例，除了设置“处理器”设置之外，还有更多的参与，因为还有其他一些考虑因素，例如更改垃圾回收器线程数，将进程锁定到内核等。
  2.默认情况下，处理器的数量为32个。这意味着在拥有32个以上处理器的系统上，Elasticsearch将调整线程池的大小，就好像只有32个处理器一样。 这个限制是为了避免在没有正确调整最大进程数的`ulimit`的系统上创建太多的线程。 如果您已经适当调整了`ulimit`，则可以通过明确设置`processors`设置来覆盖此边界。
  3.有时处理器的数量被错误地检测到，在这种情况下，明确地设置“processors”设置将会解决这些问题。



为了检查检测到的处理器的数量，使用具有`os`参数节点信息API。