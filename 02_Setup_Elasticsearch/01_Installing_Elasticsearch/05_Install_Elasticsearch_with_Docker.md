## Install Elasticsearch with Docker

Elasticsearch is also available as a Docker image. The image is built with [X-Pack](https://www.elastic.co/guide/en/x-pack/5.4/index.html) and uses [centos:7](https://hub.docker.com/_/centos/) as the base image. The source code can be found on [GitHub](https://github.com/elastic/elasticsearch-docker/tree/5.4).

### Security note

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

[X-Pack](https://www.elastic.co/guide/en/x-pack/5.4/index.html) is preinstalled in this image. Please take a few minutes to familiarize yourself with [X-Pack Security](https://www.elastic.co/guide/en/x-pack/5.4/security-getting-started.html) and how to change default passwords. The default password for the `elastic` user is `changeme`.

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

X-Pack includes a trial license for 30 days. After that, you can obtain one of the [available subscriptions](https://www.elastic.co/subscriptions) or [disable Security](https://www.elastic.co/guide/en/x-pack/5.4/security-settings.html). The Basic license is free and includes the [Monitoring](https://www.elastic.co/products/x-pack/monitoring) extension.

Obtaining for Docker is as simple as issuing a `docker pull` command against the Elastic Docker registry.

The Docker image can be retrieved with the following command:
    
    
    docker pull docker.elastic.co/elasticsearch/elasticsearch:5.4.3

### Running Elasticsearch from the command line

#### Development mode

Elasticsearch can be quickly started for development or testing use with the following command:
    
    
    docker run -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:5.4.3

#### Production mode

![Important](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/important.png)

The `vm_max_map_count` kernel setting needs to be set to at least `262144` for production use. Depending on your platform:

  * Linux 

The `vm_map_max_count` setting should be set permanently in /etc/sysctl.conf:
    
        $ grep vm.max_map_count /etc/sysctl.conf
    vm.max_map_count=262144

To apply the setting on a live system type: `sysctl -w vm.max_map_count=262144`

  * OSX with [Docker for Mac](https://docs.docker.com/engine/installation/mac/#/docker-for-mac)

The `vm_max_map_count` setting must be set within the xhyve virtual machine:
    
        $ screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty

Log in with _root_ and no password. Then configure the `sysctl` setting as you would for Linux:
    
        sysctl -w vm.max_map_count=262144

  * OSX with [Docker Toolbox](https://docs.docker.com/engine/installation/mac/#docker-toolbox)

The `vm_max_map_count` setting must be set via docker-machine:
    
        docker-machine ssh
    sudo sysctl -w vm.max_map_count=262144




The following example brings up a cluster comprising two Elasticsearch nodes. To bring up the cluster, use the [`docker-compose.yml`](docker.html#docker-prod-cluster-composefile) and just type:
    
    
    docker-compose up

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

`docker-compose` is not pre-installed with Docker on Linux. Instructions for installing it can be found on the [docker-compose webpage](https://docs.docker.com/compose/install/#install-using-pip).

The node `elasticsearch1` listens on `localhost:9200` while `elasticsearch2` talks to `elasticsearch1` over a Docker network.

This example also uses [Docker named volumes](https://docs.docker.com/engine/tutorials/dockervolumes), called `esdata1` and `esdata2` which will be created if not already present.

`docker-compose.yml`:
    
    
    version: '2'
    services:
      elasticsearch1:
        image: docker.elastic.co/elasticsearch/elasticsearch:5.4.3
        container_name: elasticsearch1
        environment:
          - cluster.name=docker-cluster
          - bootstrap.memory_lock=true
          - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
        ulimits:
          memlock:
            soft: -1
            hard: -1
        mem_limit: 1g
        volumes:
          - esdata1:/usr/share/elasticsearch/data
        ports:
          - 9200:9200
        networks:
          - esnet
      elasticsearch2:
        image: docker.elastic.co/elasticsearch/elasticsearch:5.4.3
        environment:
          - cluster.name=docker-cluster
          - bootstrap.memory_lock=true
          - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
          - "discovery.zen.ping.unicast.hosts=elasticsearch1"
        ulimits:
          memlock:
            soft: -1
            hard: -1
        mem_limit: 1g
        volumes:
          - esdata2:/usr/share/elasticsearch/data
        networks:
          - esnet
    
    volumes:
      esdata1:
        driver: local
      esdata2:
        driver: local
    
    networks:
      esnet:

To stop the cluster, type `docker-compose down`. Data volumes will persist, so it’s possible to start the cluster again with the same data using `docker-compose up`. To destroy the cluster **and the data volumes** just type `docker-compose down -v`.

#### Inspect status of cluster:
    
    
    curl -u elastic http://127.0.0.1:9200/_cat/health
    Enter host password for user 'elastic':
    1472225929 15:38:49 docker-cluster green 2 2 4 2 0 0 0 0 - 100.0%

Log messages go to the console and are handled by the configured Docker logging driver. By default you can access logs with `docker logs`.

### Configuring Elasticsearch with Docker

Elasticsearch loads its configuration from files under `/usr/share/elasticsearch/config/`. These configuration files are documented in [_Configuring Elasticsearch_](settings.html) and [Setting JVM options](setting-system-settings.html#jvm-options).

The image offers several methods for configuring Elasticsearch settings with the conventional approach being to provide customized files, that is to say, `elasticsearch.yml`. It’s also possible to use environment variables to set options:

#### A. Present the parameters via Docker environment variables

For example, to define the cluster name with `docker run` you can pass `-e "cluster.name=mynewclustername"`. Double quotes are required.

#### B. Bind-mounted configuration

Create your custom config file and mount this over the image’s corresponding file. For example, bind-mounting a `custom_elasticsearch.yml` with `docker run` can be accomplished with the parameter:
    
    
    -v full_path_to/custom_elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml

![Important](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/important.png)

The container **runs Elasticsearch as user`elasticsearch` using uid:gid `1000:1000`**. Bind mounted host directories and files, such as `custom_elasticsearch.yml` above, **need to be accessible by this user**. For the [data and log dirs](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#path-settings), such as `/usr/share/elasticsearch/data`, write access is required as well.

#### C. Customized image

In some environments, it may make more sense to prepare a custom image containing your configuration. A `Dockerfile` to achieve this may be as simple as:
    
    
    FROM docker.elastic.co/elasticsearch/elasticsearch:5.4.3
    ADD elasticsearch.yml /usr/share/elasticsearch/config/
    USER root
    RUN chown elasticsearch:elasticsearch config/elasticsearch.yml
    USER elasticsearch

You could then build and try the image with something like:
    
    
    docker build --tag=elasticsearch-custom .
    docker run -ti -v /usr/share/elasticsearch/data elasticsearch-custom

#### D. Override the image’s default [CMD](https://docs.docker.com/engine/reference/run/#cmd-default-command-or-options)

Options can be passed as command-line options to the Elasticsearch process by overriding the default command for the image. For example:
    
    
    docker run <various parameters> bin/elasticsearch -Ecluster.name=mynewclustername

### Notes for production use and defaults

We have collected a number of best practices for production use.

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

Any Docker parameters mentioned below assume the use of `docker run`.

  1. Elasticsearch runs inside the container as user `elasticsearch` using uid:gid `1000:1000`. If you are bind-mounting a local directory or file, ensure it is readable by this user, while the [data and log dirs](important-settings.html#path-settings) additionally require write access. 
  2. It is important to ensure increased ulimits for [nofile](setting-system-settings.html) and [nproc](max-number-threads-check.html) are available for the Elasticsearch containers. Verify the [init system](https://github.com/moby/moby/tree/ea4d1243953e6b652082305a9c3cda8656edab26/contrib/init) for the Docker daemon is already setting those to acceptable values and, if needed, adjust them in the Daemon, or override them per container, for example using `docker run`: 
    
        --ulimit nofile=65536:65536

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

One way of checking the Docker daemon defaults for the aforementioned ulimits is by running:
    
        docker run --rm centos:7 /bin/bash -c 'ulimit -Hn && ulimit -Sn && ulimit -Hu && ulimit -Su'

  3. Swapping needs to be disabled for performance and node stability. This can be achieved through any of the methods mentioned in the [Elasticsearch docs](setup-configuration-memory.html). If you opt for the `bootstrap.memory_lock: true` approach, apart from defining it through any of the [configuration methods](docker.html#docker-configuration-methods), you will additionally need the `memlock: true` ulimit, either defined in the [Docker Daemon](https://docs.docker.com/engine/reference/commandline/dockerd/#default-ulimits) or specifically set for the container. This has been demonstrated earlier in the [docker-compose.yml](docker.html#docker-prod-cluster-composefile), or using `docker run`: 
    
        -e "bootstrap_memory_lock=true" --ulimit memlock=-1:-1

  4. The image [exposes](https://docs.docker.com/engine/reference/builder/#/expose) TCP ports 9200 and 9300. For clusters it is recommended to randomize the published ports with `--publish-all`, unless you are pinning one container per host. 
  5. Use the `ES_JAVA_OPTS` environment variable to set heap size. For example, to use 16GB, use `-e ES_JAVA_OPTS="-Xms16g -Xmx16g"` with `docker run`. It is also recommended to set a [memory limit](https://docs.docker.com/engine/reference/run/#user-memory-constraints) for the container. 
  6. Pin your deployments to a specific version of the Elasticsearch Docker image. For example, `docker.elastic.co/elasticsearch/elasticsearch:5.4.3`. 
  7. Always use a volume bound on `/usr/share/elasticsearch/data`, as shown in the [production example](docker.html#docker-cli-run-prod-mode), for the following reasons: 

    1. The data of your elasticsearch node won’t be lost if the container is 
    killed   
    2. Elasticsearch is I/O sensitive and the Docker storage driver is not ideal for fast I/O 
    3. It allows the use of advanced [Docker volume plugins](https://docs.docker.com/engine/extend/plugins/#volume-plugins)

  8. If you are using the devicemapper storage driver (default on at least RedHat (rpm) based distributions) make sure you are not using the default `loop-lvm` mode. Configure docker-engine to use [direct-lvm](https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/#configure-docker-with-devicemapper) instead. 
  9. Consider centralizing your logs by using a different [logging driver](https://docs.docker.com/engine/admin/logging/overview/). Also note that the default json-file logging driver is not ideally suited for production use. 



### 接下来

您现在已经设置了一个测试Elasticsearch环境。 在您开始认真开发或者使用Elasticsearch进行生产之前，您需要进行一些额外的设置：

  * [配置ES](settings.html). 
  * [配置ES重要的设置](important-settings.html). 
  * [配置系统设置](system-config.html). 

