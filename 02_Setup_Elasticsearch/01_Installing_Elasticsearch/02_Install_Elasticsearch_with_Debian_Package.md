## 使用`deb`包进行安装 Install Elasticsearch with Debian Package

`deb`包可以使用在debian系列的操作系统上，如：Debian和Ubuntu.安装包可以到[下载下面下载]((deb
.html#install-deb))或者使用[API 仓库](deb.html#deb-repo)。

ES的最新版本可以在[下载页面](/downloads/elasticsearch)直接找到,旧版本可以到[过去发布版本]
(/downloads/past-releases)进行查找.

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

ES要求使用Java8+的环境,可以使用[Oracle 官方 JDK](http://www.oracle
.com/technetwork/java/javase/downloads/index.html) 或者[OpenJDK](http://openjdk
.java.net).

### 导入ES PGP密钥 Import the Elasticsearch PGP Key

安装包签属了(PGP 密钥 [D88E42B4](https://pgp.mit
.edu/pks/lookup?op=vindex&search=0xD27D666CD88E42B4), 从 <https://pgp.mit
.edu>)获取可用的指纹:
    
    4609 5ACC 8548 582C 1A26 99A9 D27D 666C D88E 42B4

下载并安装公钥:
```sh
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
```

### 从APT仓库安装

在进行使用`deb`包安装前,首先要安装`apt-transport-https`包:
    
    sudo apt-get install apt-transport-https

在源文件中定义仓库: `/etc/apt/sources.list.d/elastic-5.x.list`:
    
    echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

这些步骤不使用`add-apt-repository` 命令的理由:

  1. `add-apt-repository`直接操作`/etc/apt/sources.list` 文件, 而`/etc/apt/sources.list.d`文件夹保留不对系统造成坏的影响.
  2. `add-apt-repository`不是许多发行版默认安装的一部分，需要一些非默认的依赖关系。 
  3. 旧版本的`add-apt-repository`总是添加一个`deb-src`条目，这会导致错误，因为我们不提供源代码包。 如果添加了`deb-src`项，直到删除`deb-src`这一行前，你将看到如下的错误：
    
       无法在发布文件中找到预期的条目“main/source/Sources”（错误的sources.list条目或格式错误的文件）

您可以安装Elasticsearch Debian软件包：
        
    sudo apt-get update && sudo apt-get install elasticsearch

![Warning](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/warning.png)

如果同一个Elasticsearch存储库中存在两个条目，则在`apt-get update`中会看到类似这样的错误：    
    
    `Duplicate sources.list entry https://artifacts.elastic.co/packages/5.x/apt/ ...`

检查 `/etc/apt/sources.list.d/elasticsearch-5.x.list` 是否在 `/etc/apt/sources.list.d/` 和 `/etc/apt/sources.list` 文件存在多个.

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

在基于systemd的发行系统上，安装脚本将尝试设置内核参数（例如`vm.max_map_count`）; 您可以通过将环境变量`ES_SKIP_SET_KERNEL_PARAMETERS`设置为`true`来跳过此操作。

### 下载并手动安装Debian软件包

Elasticsearch v5.4.3的Debian软件包可以从网站下载并安装如下：
```sh 
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.3.deb
sha1sum elasticsearch-5.4.3.deb 
sudo dpkg -i elasticsearch-5.4.3.deb
```    
  
### SysV `init` vs `systemd`

Elasticsearch安装后不会自动启动。 如何启动和停止Elasticsearch取决于您的系统是否使用SysV`init`或`systemd`（由更新的发行版使用）服务管理。 你可以通过运行这个命令来判断使用的服务管理：
    
    ps -p 1

### 使用 SysV `init` 运行ES

使用`update-rc.d`命令将ES配置为在系统启动时自启动：    
    
    sudo update-rc.d elasticsearch defaults 95 10

可以使用`service`命令启动和停止ES：    
    
    sudo -i service elasticsearch start
    sudo -i service elasticsearch stop

如果Elasticsearch由于任何原因而无法启动，将会打印失败的原因。 日志文件可以在 `/var/log/elasticsearch/`中找到。

### 使用`systemd`运行ES

要将Elasticsearch配置为在系统启动时自启动，请运行以下命令：    
    
    sudo /bin/systemctl daemon-reload
    sudo /bin/systemctl enable elasticsearch.service

可以使用如下命令启动和停止ES：     
    
    sudo systemctl start elasticsearch.service
    sudo systemctl stop elasticsearch.service

这些命令没有提供有关Elasticsearch是否成功启动的反馈。 但是, 日志文件可以在 `/var/log/elasticsearch/`中找到

默认情况下，Elasticsearch服务不会在“systemd”日志中记录信息。 为了启用`journalctl`日志记录，必须从`elasticsearch.service`文件的`ExecStart`命令行中删除`--quiet`选项。

当`systemd`日志被启用时，日志信息可以使用'journalctl`命令：

从后查看日志:
    
    
    sudo journalctl -f

只列出elasticsearch服务的日志：    
    
    sudo journalctl --unit elasticsearch


指定定时间开始列出elasticsearch服务的日志，请执行以下操作：    
    
    sudo journalctl --unit elasticsearch --since  "2016-10-30 18:17:16"

查看 `man journalctl` or <https://www.freedesktop.org/software/systemd/man/journalctl.html> 获取合金信息

### 查检ES的运行状态

你可以通过发送一个HTTP请求到`localhost`上的端口`9200`来测试你的Elasticsearch节点是否正在运行：    
    
    GET /

可能得到的响应:    
    
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

### 配置ES

ES默认从`/etc/elasticsearch/elasticsearch.yml`文件加载配置,配置的格式详情可以在[_Configuring Elasticsearch_](settings.html)查阅.

Debian软件包也有一个系统配置文件（`/ etc / default / elasticsearch`），它允许你设置下列参数：

`ES_USER`| ES的运行用户,默认是: `elasticsearch`.    
---|--- 
`ES_GROUP`| ES的运行用户组,默认是: `elasticsearch`.     
`JAVA_HOME`| 自定义JAVA环境.     
`MAX_OPEN_FILES`| 文件打开数数,默认是: `65536`.     
`MAX_LOCKED_MEMORY`|最大内存锁大小.  如果配置了使用内存锁`bootstrap.memory_lock`,可以配置`unlimited`让最大锁内存为无限.   
`MAX_MAP_COUNT`| 进程可能具有的最大内存映射区域数量。 如果使用`mmapfs`作为索引存储类型，请确保将其设置为较高的值。 有关更多信息，请查看关于`max_map_count`的[linux内核文档](https://github.com/torvalds/linux/blob/master/Documentation/sysctl/vm.txt)。 在启动elasticsearch之前，这是通过`sysctl`设置的。 默认为“262144”。
`LOG_DIR`| 日志存放目录,默认: `/var/log/elasticsearch`.     
`DATA_DIR`| 日志存放目录,默认: `/var/lib/elasticsearch`.     
`CONF_DIR`| 配置文件存放目录 (必须包含 `elasticsearch.yml` 和 `log4j2.properties` 文件), 默认: `/etc/elasticsearch`.     
`ES_JAVA_OPTS`| JVM的额外运行优化参数  
`RESTART_ON_UPGRADE`| 配置软件包升级重启，默认为“false”。 这意味着您必须在手动安装包后重新启动elasticsearch实例。 其原因是为了确保集群中的升级不会导致连续的碎片重新分配，从而导致高网络流量并缩短集群的响应时间。
  
![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

使用`systemd`的分发需要通过`systemd`而不是`/etc/sysconfig/elasticsearch`文件来配置系统资源限制。 有关更多信息，请参阅[Systemd配置](setting-system-settings.html#systemd).

### `deb`包的安装结构

Debian软件包将配置文件，日志和数据目录放置在基于Debian的系统的适当位置：

类型| 说明| 默认位置| 设置
:---:|:---|:---|:---
**home**| ES的主目录 `$ES_HOME`| `/usr/share/elasticsearch`|      
**bin**| 二进制脚本包括`elasticsearch`启动节点，`elasticsearch-plugin`安装插件| `/usr/share/elasticsearch/bin`|      
**conf**| 配置文件包括`elasticsearch.yml`和 `log4j2.properties`| `/etc/elasticsearch`| `path.conf`     
**conf**|环境变量包括堆大小，文件描述符|  ***`/etc/default/elasticsearch`***|      
**data**| 在节点上分配的每个索引/分片的数据文件的位置。 可以容纳多个地点.| `/var/lib/elasticsearch`| `path.data`     
**logs**| 日志文件存放位置.| `/var/log/elasticsearch`| `path.logs`     
**plugins**| 插件安装位置,每个插件都会是一个子目录.| `/usr/share/elasticsearch/plugins`| ``     
**repo**| 共享文件系统存储库位置。 可以容纳多个地点。 文件系统存储库可以放置在此处指定的任何目录的任何子目录中.|没有配置| `path.repo`     
**script**| 脚本文件存放目录.| `/etc/elasticsearch/scripts`| `path.scripts`  
  
### 接下来

您现在已经设置了一个测试Elasticsearch环境。 在您开始认真开发或者使用Elasticsearch进行生产之前，您需要进行一些额外的设置：

  * [配置ES](settings.html). 
  * [配置ES重要的设置](important-settings.html). 
  * [配置系统设置](system-config.html). 


