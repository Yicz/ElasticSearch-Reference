## Install Elasticsearch with RPM

The RPM for Elasticsearch can be [downloaded from our website](rpm.html#install-rpm) or from our [RPM repository](rpm.html#rpm-repo). It can be used to install Elasticsearch on any RPM-based system such as OpenSuSE, SLES, Centos, Red Hat, and Oracle Enterprise.

![Note](images/icons/note.png)

RPM install is not supported on distributions with old versions of RPM, such as SLES 11 and CentOS 5. Please see [Install Elasticsearch with `.zip` or `.tar.gz`](zip-targz.html) instead.

The latest stable version of Elasticsearch can be found on the [Download Elasticsearch](/downloads/elasticsearch) page. Other versions can be found on the [Past Releases page](/downloads/past-releases).

![Note](images/icons/note.png)

Elasticsearch requires Java 8 or later. Use the [official Oracle distribution](http://www.oracle.com/technetwork/java/javase/downloads/index.html) or an open-source distribution such as [OpenJDK](http://openjdk.java.net).

### Import the Elasticsearch PGP Key

We sign all of our packages with the Elasticsearch Signing Key (PGP key [D88E42B4](https://pgp.mit.edu/pks/lookup?op=vindex&search=0xD27D666CD88E42B4), available from <https://pgp.mit.edu>) with fingerprint:
    
    
    4609 5ACC 8548 582C 1A26 99A9 D27D 666C D88E 42B4

Download and install the public signing key:
    
    
    rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

### Installing from the RPM repository

Create a file called `elasticsearch.repo` in the `/etc/yum.repos.d/` directory for RedHat based distributions, or in the `/etc/zypp/repos.d/` directory for OpenSuSE based distributions, containing:
    
    
    [elasticsearch-5.x]
    name=Elasticsearch repository for 5.x packages
    baseurl=https://artifacts.elastic.co/packages/5.x/yum
    gpgcheck=1
    gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
    enabled=1
    autorefresh=1
    type=rpm-md

And your repository is ready for use. You can now install Elasticsearch with one of the following commands:
    
    
    sudo yum install elasticsearch ![](images/icons/callouts/1.png)
    sudo dnf install elasticsearch ![](images/icons/callouts/2.png)
    sudo zypper install elasticsearch ![](images/icons/callouts/3.png)

![](images/icons/callouts/1.png)

| 

Use `yum` on CentOS and older Red Hat based distributions.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Use `dnf` on Fedora and other newer Red Hat distributions.   
  
![](images/icons/callouts/3.png)

| 

Use `zypper` on OpenSUSE based distributions   
  
### Download and install the RPM manually

The RPM for Elasticsearch v5.4.3 can be downloaded from the website and installed as follows:
    
    
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.3.rpm
    sha1sum elasticsearch-5.4.3.rpm ![](images/icons/callouts/1.png)
    sudo rpm --install elasticsearch-5.4.3.rpm

![](images/icons/callouts/1.png)

| 

Compare the SHA produced by `sha1sum` or `shasum` with the [published SHA](https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.3.rpm.sha1).   
  
---|---  
  
![Note](images/icons/note.png)

On systemd-based distributions, the installation scripts will attempt to set kernel parameters (e.g., `vm.max_map_count`); you can skip this by setting the environment variable `ES_SKIP_SET_KERNEL_PARAMETERS` to `true`.

### SysV `init` vs `systemd`

Elasticsearch is not started automatically after installation. How to start and stop Elasticsearch depends on whether your system uses SysV `init` or `systemd` (used by newer distributions). You can tell which is being used by running this command:
    
    
    ps -p 1

### Running Elasticsearch with SysV `init`

Use the `chkconfig` command to configure Elasticsearch to start automatically when the system boots up:
    
    
    sudo chkconfig --add elasticsearch

Elasticsearch can be started and stopped using the `service` command:
    
    
    sudo -i service elasticsearch start
    sudo -i service elasticsearch stop

If Elasticsearch fails to start for any reason, it will print the reason for failure to STDOUT. Log files can be found in `/var/log/elasticsearch/`.

### Running Elasticsearch with `systemd`

To configure Elasticsearch to start automatically when the system boots up, run the following commands:
    
    
    sudo /bin/systemctl daemon-reload
    sudo /bin/systemctl enable elasticsearch.service

Elasticsearch can be started and stopped as follows:
    
    
    sudo systemctl start elasticsearch.service
    sudo systemctl stop elasticsearch.service

These commands provide no feedback as to whether Elasticsearch was started successfully or not. Instead, this information will be written in the log files located in `/var/log/elasticsearch/`.

By default the Elasticsearch service doesn’t log information in the `systemd` journal. To enable `journalctl` logging, the `--quiet` option must be removed from the `ExecStart` command line in the `elasticsearch.service` file.

When `systemd` logging is enabled, the logging information are available using the `journalctl` commands:

To tail the journal:
    
    
    sudo journalctl -f

To list journal entries for the elasticsearch service:
    
    
    sudo journalctl --unit elasticsearch

To list journal entries for the elasticsearch service starting from a given time:
    
    
    sudo journalctl --unit elasticsearch --since  "2016-10-30 18:17:16"

Check `man journalctl` or <https://www.freedesktop.org/software/systemd/man/journalctl.html> for more command line options.

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

### Configuring Elasticsearch

Elasticsearch loads its configuration from the `/etc/elasticsearch/elasticsearch.yml` file by default. The format of this config file is explained in [_Configuring Elasticsearch_](settings.html).

The RPM also has a system configuration file (`/etc/sysconfig/elasticsearch`), which allows you to set the following parameters:

`ES_USER`| The user to run as, defaults to `elasticsearch`.     
---|---    
`ES_GROUP`| The group to run as, defaults to `elasticsearch`.     
`JAVA_HOME`| Set a custom Java path to be used.     
`MAX_OPEN_FILES`| Maximum number of open files, defaults to `65536`.     
`MAX_LOCKED_MEMORY`| Maximum locked memory size. Set to `unlimited` if you use the `bootstrap.memory_lock` option in elasticsearch.yml.     
`MAX_MAP_COUNT`| 

Maximum number of memory map areas a process may have. If you use `mmapfs` as index store type, make sure this is set to a high value. For more information, check the [linux kernel documentation](https://github.com/torvalds/linux/blob/master/Documentation/sysctl/vm.txt) about `max_map_count`. This is set via `sysctl` before starting elasticsearch. Defaults to `262144`.   
  
`LOG_DIR`| Log directory, defaults to `/var/log/elasticsearch`.     
`DATA_DIR`| Data directory, defaults to `/var/lib/elasticsearch`.     
`CONF_DIR`| Configuration file directory (which needs to include `elasticsearch.yml` and `log4j2.properties` files), defaults to `/etc/elasticsearch`.     
`ES_JAVA_OPTS`| Any additional JVM system properties you may want to apply.     
`RESTART_ON_UPGRADE`| 
Configure restart on package upgrade, defaults to `false`. This means you will have to restart your elasticsearch instance after installing a package manually. The reason for this is to ensure, that upgrades in a cluster do not result in a continuous shard reallocation resulting in high network traffic and reducing the response times of your cluster.   
  
![Note](images/icons/note.png)

Distributions that use `systemd` require that system resource limits be configured via `systemd` rather than via the `/etc/sysconfig/elasticsearch` file. See [Systemd configuration](setting-system-settings.html#systemd) for more information.

### Directory layout of RPM

The RPM places config files, logs, and the data directory in the appropriate locations for an RPM-based system:

Type |  Description |  Default Location |  Setting  
---|---|---|---     
**home**| Elasticsearch home directory or `$ES_HOME`| `/usr/share/elasticsearch`|      
**bin**| Binary scripts including `elasticsearch` to start a node and `elasticsearch-plugin` to install plugins| `/usr/share/elasticsearch/bin`|      
**conf**| Configuration files including `elasticsearch.yml`| `/etc/elasticsearch`| `path.conf`     
**conf**| Environment variables including heap size, file descriptors.| `/etc/sysconfig/elasticsearch`|      
**data**| The location of the data files of each index / shard allocated on the node. Can hold multiple locations.| `/var/lib/elasticsearch`| `path.data`     
**logs**| Log files location.| `/var/log/elasticsearch`| `path.logs`     
**plugins**| Plugin files location. Each plugin will be contained in a subdirectory.| `/usr/share/elasticsearch/plugins`| ``     
**repo**| Shared file system repository locations. Can hold multiple locations. A file system repository can be placed in to any subdirectory of any directory specified here.| Not configured| `path.repo`     
**script**| Location of script files.| `/etc/elasticsearch/scripts`| `path.scripts`  
  
### Next steps

You now have a test Elasticsearch environment set up. Before you start serious development or go into production with Elasticsearch, you will need to do some additional setup:

  * Learn how to [configure Elasticsearch](settings.html). 
  * Configure [important Elasticsearch settings](important-settings.html). 
  * Configure [important system settings](system-config.html). 


