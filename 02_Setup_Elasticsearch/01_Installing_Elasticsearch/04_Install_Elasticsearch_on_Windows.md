## Install Elasticsearch on Windows

Elasticsearch can be installed on Windows using the `.zip` package. This comes with a `elasticsearch-service.bat` command which will setup Elasticsearch to run as a service.

The latest stable version of Elasticsearch can be found on the [Download Elasticsearch](/downloads/elasticsearch) page. Other versions can be found on the [Past Releases page](/downloads/past-releases).

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

Elasticsearch requires Java 8 or later. Use the [official Oracle distribution](http://www.oracle.com/technetwork/java/javase/downloads/index.html) or an open-source distribution such as [OpenJDK](http://openjdk.java.net).

### Download and install the `.zip` package

Download the `.zip` archive for Elasticsearch v5.4.3 from: <https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.3.zip>

Unzip it with your favourite unzip tool. This will create a folder called `elasticsearch-5.4.3`, which we will refer to as `%ES_HOME%`. In a terminal window, `cd` to the `%ES_HOME%` directory, for instance:
    
    
    cd c:\elasticsearch-5.4.3

### Running Elasticsearch from the command line

Elasticsearch can be started from the command line as follows:
    
    
    .\bin\elasticsearch.bat

By default, Elasticsearch runs in the foreground, prints its logs to `STDOUT`, and can be stopped by pressing `Ctrl-C`.

### Configuring Elasticsearch on the command line

Elasticsearch loads its configuration from the `%ES_HOME%\config\elasticsearch.yml` file by default. The format of this config file is explained in [_Configuring Elasticsearch_](settings.html).

Any settings that can be specified in the config file can also be specified on the command line, using the `-E` syntax as follows:
    
    
    .\bin\elasticsearch.bat -Ecluster.name=my_cluster -Enode.name=node_1

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

Values that contain spaces must be surrounded with quotes. For instance `-Epath.logs="C:\My Logs\logs"`.

![Tip](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/tip.png)

Typically, any cluster-wide settings (like `cluster.name`) should be added to the `elasticsearch.yml` config file, while any node-specific settings such as `node.name` could be specified on the command line.

### Checking that Elasticsearch is running

You can test that your Elasticsearch node is running by sending an HTTP request to port `9200` on `localhost`:
    
    
    GET /

which should give you a response something like this:
    
    
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

### Installing Elasticsearch as a Service on Windows

Elasticsearch can be installed as a service to run in the background or start automatically at boot time without any user interaction. This can be achieved through the `elasticsearch-service.bat` script in the `bin\` folder which allows one to install, remove, manage or configure the service and potentially start and stop the service, all from the command-line.
    
    
    c:\elasticsearch-5.4.3\bin>elasticsearch-service
    
    Usage: elasticsearch-service.bat install|remove|start|stop|manager [SERVICE_ID]

The script requires one parameter (the command to execute) followed by an optional one indicating the service id (useful when installing multiple Elasticsearch services).

The commands available are:

`install`| Install Elasticsearch as a service     ---|---    
`remove`| Remove the installed Elasticsearch service (and stop the service if started)     
`start`| Start the Elasticsearch service (if installed)     
`stop`| Stop the Elasticsearch service (if started)     
`manager`| 

Start a GUI for managing the installed service   
  
Based on the architecture of the available JDK/JRE (set through `JAVA_HOME`), the appropriate 64-bit(x64) or 32-bit(x86) service will be installed. This information is made available during install:
    
    
    c:\elasticsearch-5.4.3\bin>elasticsearch-service install
    Installing service      :  "elasticsearch-service-x64"
    Using JAVA_HOME (64-bit):  "c:\jvm\jdk1.8"
    The service 'elasticsearch-service-x64' has been installed.

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

While a JRE can be used for the Elasticsearch service, due to its use of a client VM (as opposed to a server JVM which offers better performance for long-running applications) its usage is discouraged and a warning will be issued.

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

The system environment variable `JAVA_HOME` should be set to the path to the JDK installation that you want the service to use. If you upgrade the JDK, you are not required to the reinstall the service but you must set the value of the system environment variable `JAVA_HOME` to the path to the new JDK installation. However, upgrading across JVM types (e.g. JRE versus SE) is not supported, and does require the service to be reinstalled.

### Customizing service settings

The Elasticsearch service can be configured prior to installation by setting the following environment variables (either using the [set command](https://technet.microsoft.com/en-us/library/cc754250\(v=ws.10\).aspx) from the command line, or through the `System Properties->Environment Variables` GUI).

`SERVICE_ID`| A unique identifier for the service. Useful if installing multiple instances on the same machine. Defaults to `elasticsearch-service-x86` (on 32-bit Windows) or `elasticsearch-service-x64` (on 64-bit Windows).     ---|---    
`SERVICE_USERNAME`| The user to run as, defaults to the local system account.     
`SERVICE_PASSWORD`| The password for the user specified in `%SERVICE_USERNAME%`.     
`SERVICE_DISPLAY_NAME`| The name of the service. Defaults to `Elasticsearch <version> %SERVICE_ID%`.     
`SERVICE_DESCRIPTION`| The description of the service. Defaults to `Elasticsearch <version> Windows Service - https://elastic.co`.     
`JAVA_HOME`| The installation directory of the desired JVM to run the service under.     
`LOG_DIR`| Log directory, defaults to `%ES_HOME%\logs`.     
`DATA_DIR`| Data directory, defaults to `%ES_HOME%\data`.     
`CONF_DIR`| Configuration file directory (which needs to include `elasticsearch.yml` and `log4j2.properties` files), defaults to `%ES_HOME%\conf`.     
`ES_JAVA_OPTS`| Any additional JVM system properties you may want to apply.     
`ES_START_TYPE`| Startup mode for the service. Can be either `auto` or `manual` (default).     
`ES_STOP_TIMEOUT`| 

The timeout in seconds that procrun waits for service to exit gracefully. Defaults to `0`.   
  
![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

At its core, `elasticsearch-service.bat` relies on [Apache Commons Daemon](http://commons.apache.org/proper/commons-daemon/) project to install the service. Environment variables set prior to the service installation are copied and will be used during the service lifecycle. This means any changes made to them after the installation will not be picked up unless the service is reinstalled.

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

On Windows, the [heap size](heap-size.html) can be configured as for any other Elasticsearch installation when running Elasticsearch from the command line, or when installing Elasticsearch as a service for the first time. To adjust the heap size for an already installed service, use the service manager: `bin\elasticsearch-service.bat manager`.

Using the Manager GUI 
     It is also possible to configure the service after it’s been installed using the manager GUI (`elasticsearch-service-mgr.exe`), which offers insight into the installed service, including its status, startup type, JVM, start and stop settings amongst other things. Simply invoking `elasticsearch-service.bat manager` from the command-line will open up the manager window: 

![Windows Service Manager GUI](images/service-manager-win.png)

Most changes (like JVM settings) made through the manager GUI will require a restart of the service in order to take affect.

### Directory layout of `.zip` archive

The `.zip` package is entirely self-contained. All files and directories are, by default, contained within `%ES_HOME%` — the directory created when unpacking the archive.

This is very convenient because you don’t have to create any directories to start using Elasticsearch, and uninstalling Elasticsearch is as easy as removing the `%ES_HOME%` directory. However, it is advisable to change the default locations of the config directory, the data directory, and the logs directory so that you do not delete important data later on.


RPM软件包将配置文件，日志和数据目录放置在基于RPM的系统的适当位置：

类型| 说明| 默认位置| 设置
:---:|:---|:---|:---
**home**| ES的主目录 `%ES_HOME%`| 解压文件夹的所有位置|      
**bin**| 二进制脚本包括`elasticsearch`启动节点，`elasticsearch-plugin`安装插件| ***`%ES_HOME%\bin`***|      
**conf**| 配置文件包括`elasticsearch.yml`和 `log4j2.properties`| ***`%ES_HOME%\conf`***| `path.conf`     
**data**| 在节点上分配的每个索引/分片的数据文件的位置。 可以容纳多个地点.| ***`%ES_HOME%\data`***| `path.data`     
**logs**| 日志文件存放位置.| ***`%ES_HOME/logs%`***| `path.logs`     
**plugins**| 插件安装位置,每个插件都会是一个子目录.|  ***`%ES_HOME%\plugins`***| ``     
**repo**| 共享文件系统存储库位置。 可以容纳多个地点。 文件系统存储库可以放置在此处指定的任何目录的任何子目录中.|没有配置| `path.repo`     
**script**| 脚本文件存放目录.| ***`%ES_HOME%\scripts`***| `path.scripts`  

  
### Next steps

### 接下来

您现在已经设置了一个测试Elasticsearch环境。 在您开始认真开发或者使用Elasticsearch进行生产之前，您需要进行一些额外的设置：

  * [配置ES](settings.html). 
  * [配置ES重要的设置](important-settings.html). 
  * [配置系统设置](system-config.html). 
