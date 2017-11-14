# 安装Elasticsearch

Elasticsearch 提供了如下几种安装方式：

* zip/tar.gz  
    zip/tar.gz 安装包是最适合安装到任何系统的，并且是最容易入门elasticsearch的方式。  
    [使用zip/tar.gz的方式安装](Install_Elasticsearch_with_.zip_or_.tar.gz.md) 或 [在windows 系统中安装](Install_Elasticsearch_on_Windows.md)
* deb  
    deb 安装包是只适合Debian,Ubuntut和其它Debian系列的系统  
    [使用deb 包安装](Install_Elasticsearch_with_Debian_Package.md)
* rpm  
    rpm 包适合 RPM系列的系统，如RED Hat,Centos,SLES,OpenSuSE  
    [使用rpm包安装](Install_Elasticsearch_with_RPM.md)
* docker
    Elasticsearch 提供了运行在docker中的镜像。并且它预先安装了[X-Pack](),可以直接在Elastic Docker 注册中心中获取。  
    [使用docker安装](Install_Elasticsearch_with_Docker.md)

# 配置管理工具
    
我们同时提供了下面的配置管理工具给开发者，这些工具能有效地帮助他们进行管理

* [Puppet](https://github.com/elastic/puppet-elasticsearch)
* [Chef](https://github.com/elastic/cookbook-elasticsearch)
* [Ansible](https://github.com/elastic/ansible-elasticsearch)