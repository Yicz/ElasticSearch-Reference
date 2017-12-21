## 安全设置


有些设置是敏感的，依靠文件系统权限来保护它们的值是不够的。对于这个用例，elasticsearch提供了一个可以用密码保护的keystore，以及用来管理keystore中的设置的`elasticsearch-keystore`工具。

这里的所有命令都应该以运行elasticsearch的用户身份运行。（非root用户）


只有一些设置被设计为从密钥库中读取。请参阅每个设置的文档，以查看它是否作为密钥库的一部分受支持。

### Creating the keystore

为了创建`elasticsearch.keystore`, 使用`create`命令:
    
    bin/elasticsearch-keystore create

elasticsearch.keystore文件将与elasticsearch.yml在一起。

### Listing settings in the keystore


使用`list`命令可以获得密钥库中的设置列表：    
    
    bin/elasticsearch-keystore list

### Adding string settings

敏感字符串设置，例如云插件的身份验证凭据，可以使用“add”命令添加：    
    
    bin/elasticsearch-keystore add the.setting.name.to.set

该工具将提示输入设置的值。要通过stdin传递值，请使用`--stdin`标志：    
    
    cat /file/containing/setting/value | bin/elasticsearch-keystore add --stdin the.setting.name.to.set

### Removing settings

要从密钥库中删除设置，请使用`remove`命令：    
    
    bin/elasticsearch-keystore remove the.setting.name.to.remove
