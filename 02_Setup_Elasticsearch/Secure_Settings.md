# 安全设置
有些设置是敏感的，依靠文件系统权限来保护它们的值是不够的。 对于这个用例，elasticsearch提供了一个keystore，它可以是密码保护的，elasticsearch-keystore工具可以管理keystore中的设置。
> 所有命令应该运行在非root用户下运行。

## 创建密钥
要创建elasticsearch.keystore，请使用create命令：

```sh
bin/elasticsearch-keystore create
```
创建的elasticsearch.keystore文件将与elasticsearch.yml同文件夹下
## 列出密钥
使用list命令可以使用密钥库中的设置列表：

```sh
bin/elasticsearch-keystore list
```
## 添加设置
可以使用add命令添加敏感的字符串设置，例如云插件的身份验证凭据：

```sh
bin/elasticsearch-keystore add the.setting.name.to.set
```

该工具将提示输入设置的值。 要通过stdin传递值，请使用--stdin标志：

```sh
cat /file/containing/setting/value | bin/elasticsearch-keystore add --stdin the.setting.name.to.set
```
## 移除设置
要从密钥库中删除设置，使用remove命令：

```sh
bin/elasticsearch-keystore remove the.setting.name.to.remove
```