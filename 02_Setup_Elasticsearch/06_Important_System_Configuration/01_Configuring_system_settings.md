## Configuring system settings

Where to configure systems settings depends on which package you have used to install Elasticsearch, and which operating system you are using.

When using the `.zip` or `.tar.gz` packages, system settings can be configured:

  * temporarily with [`ulimit`](setting-system-settings.html#ulimit "ulimit"), or 
  * permanently in [`/etc/security/limits.conf`](setting-system-settings.html#limits.conf "/etc/security/limits.conf"). 



When using the RPM or Debian packages, most system settings are set in the [system configuration file](setting-system-settings.html#sysconfig "Sysconfig file"). However, systems which use systemd require that system limits are specified in a [systemd configuration file](setting-system-settings.html#systemd "Systemd configuration").

### `ulimit`

On Linux systems, `ulimit` can be used to change resource limits on a temporary basis. Limits usually need to be set as `root` before switching to the user that will run Elasticsearch. For example, to set the number of open file handles (`ulimit -n`) to 65,536, you can do the following:
    
    
    sudo su  ![](images/icons/callouts/1.png)
    ulimit -n 65536 ![](images/icons/callouts/2.png)
    su elasticsearch ![](images/icons/callouts/3.png)

![](images/icons/callouts/1.png)

| 

Become `root`.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Change the max number of open files.   
  
![](images/icons/callouts/3.png)

| 

Become the `elasticsearch` user in order to start Elasticsearch.   
  
The new limit is only applied during the current session.

You can consult all currently applied limits with `ulimit -a`.

### `/etc/security/limits.conf`

On Linux systems, persistent limits can be set for a particular user by editing the `/etc/security/limits.conf` file. To set the maximum number of open files for the `elasticsearch` user to 65,536, add the following line to the `limits.conf` file:
    
    
    elasticsearch  -  nofile  65536

This change will only take effect the next time the `elasticsearch` user opens a new session.

![Note](images/icons/note.png)

### Ubuntu and `limits.conf`

Ubuntu ignores the `limits.conf` file for processes started by `init.d`. To enable the `limits.conf` file, edit `/etc/pam.d/su` and uncomment the following line:
    
    
    # session    required   pam_limits.so

### Sysconfig file

When using the RPM or Debian packages, system settings and environment variables can be specified in the system configuration file, which is located in:

RPM 

| 

`/etc/sysconfig/elasticsearch`  
  
---|---  
  
Debian 

| 

`/etc/default/elasticsearch`  
  
However, for systems which uses `systemd`, system limits need to be specified via [systemd](setting-system-settings.html#systemd "Systemd configuration").

### Systemd configuration

When using the RPM or Debian packages on systems that use [systemd](https://en.wikipedia.org/wiki/Systemd), system limits must be specified via systemd.

The systemd service file (`/usr/lib/systemd/system/elasticsearch.service`) contains the limits that are applied by default.

To override these, add a file called `/etc/systemd/system/elasticsearch.service.d/elasticsearch.conf` and specify any changes in that file, such as:
    
    
    [Service]
    LimitMEMLOCK=infinity

### Setting JVM options

The preferred method of setting Java Virtual Machine options (including system properties and JVM flags) is via the `jvm.options` configuration file. The default location of this file is `config/jvm.options` (when installing from the tar or zip distributions) and `/etc/elasticsearch/jvm.options` (when installing from the Debian or RPM packages). This file contains a line-delimited list of JVM arguments, which must begin with `-`. You can add custom JVM flags to this file and check this configuration into your version control system.

An alternative mechanism for setting Java Virtual Machine options is via the `ES_JAVA_OPTS` environment variable. For instance:
    
    
    export ES_JAVA_OPTS="$ES_JAVA_OPTS -Djava.io.tmpdir=/path/to/temp/dir"
    ./bin/elasticsearch

When using the RPM or Debian packages, `ES_JAVA_OPTS` can be specified in the [system configuration file](setting-system-settings.html#sysconfig "Sysconfig file").
