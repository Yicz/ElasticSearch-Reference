## 重要的系统设置

设置系统设置取决于你使用什么平台系统和安装ES使用的方式。

当你使用`.zpi`或`.tar.gz`包进行安装的时候，可以使用如下的方式进行配置：

  * 使用 [`ulimit`](setting-system-settings.html#ulimit)命令进行临时设置,  
  * 在系统的配置文件[`/etc/security/limits.conf`](setting-system-settings.html#limits.conf) 进行永久地变更. 


当你使用`RPM`或`Deb`包进行安装的进修，大部分的系统设置在[系统配置文件](setting-system-settings.html#sysconfig)中，如果系统使用提是`systemd`，将要在[`systemd`配置文件]中指定 `system ulimit`.

### `ulimit`
在Linux平台，`ulimit`命令可以用于临时变更资源限制（resource limits）,命令的执行要使用`root`用户，例如，修改打开文件的数量`ulimint -n 65536`，修改打开文件数到65536，你要执行如下命令：
```sh
    sudo su  # 切换到root用户
    ulimit -n 65536 # 执行修改打开文件数的大小
    su elasticsearch # 切换回elasticsearch用户
```
  
新的资源限制只会应用到当前的会话状态。

你可以使用`ulimit -a`查看所有的配置情况。

### `/etc/security/limits.conf`

在Linux平台，永久地变更`limits`可以修改配置文件`/etc/security/limits.conf`,只修改elasticsearch用户的资源限制可以使用如下的配置：
    
    elasticsearch  -  nofile  65536

这个只修改影响到`elasticsearch`新打开的会话。

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

### Ubuntu系统与`limits.conf`

Ubuntu系统会忽略`limits.conf`文件，转而使用`init.d`,要启用`limits.conf`,要编辑`/etc/pam.d/su`,取消如下的注释内容：
    
    # session    required   pam_limits.so

### 系统配置文件 Sysconfig file


当使用`RPM`或`deb`的安装方式的时候，系统配置和环境变量可以在系统的配置文件中指定，配置文件位于：

RPM | `/etc/sysconfig/elasticsearch`  
  
---|---  
  
Debian | `/etc/default/elasticsearch`  
  

然后，使用`systemd`的系统，要使用[`systemd`](setting-system-settings.html#systemd)进行修改

### `Systemd` 配置

如果使用`RPM`或`deb`包安装的平台使用[`systemd`](https://en.wikipedia.org/wiki/Systemd),系统资源将由`sytemd`进行指定。

系统服务文件(`/usr/lib/systemd/system/elasticsearch.service`) 包含了`limits`配置，会被默认应用 

要覆盖默认配置，可以添加一个文件`/etc/systemd/system/elasticsearch.service.d/elasticsearch.conf`并在文件中指定如下内容：
    
    [Service]
    LimitMEMLOCK=infinity

###  JVM 配置

配置JVM虚拟机选项最优的方式是通过`jvm.options`配置文件，默认的文件位置是`$ES_HOME/config/jvm.options`(使用`.zip`或`.tar.gz`方式安装)，或`/etc/elasticsearch/jvm.options`(使用`RPM`或`deb`方式安装)，这个配置文件使用了以`-`开头（**必须**）的的JVM选项。您可以将自定义JVM标志添加到此文件，并将此配置检入到您的版本控制系统中。



另一种设置Java虚拟机选项的机制是通过`ES_JAVA_OPTS`环境变量。 例如：
```sh    
    export ES_JAVA_OPTS="$ES_JAVA_OPTS -Djava.io.tmpdir=/path/to/temp/dir"
    ./bin/elasticsearch
```
当使用`RPM`或`deb`包进行安装时，可以在[系统配置文件](setting-system-settings.html#sysconfig)中指定`ES_JAVA_OPTS`环境变量。
