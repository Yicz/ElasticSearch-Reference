## 查看模板 cat templates

`templates`命令提供有关现有模板的信息。    
    
    % curl 'localhost:9200/_cat/templates?v=true'
    name      template order version
    template0 te*      0
    template1 tea*     1
    template2 teak*    2     7

输出显示有三个现有模板，其中template2具有版本值。

端点还支持在url中给出模板名称或模式来过滤结果，例如`/_cat/templates/template*`或`/_cat/templates/template0`。
