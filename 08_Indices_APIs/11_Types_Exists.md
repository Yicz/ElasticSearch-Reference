## 类型存在 Types Exists

检查index/types是否存在，可以使用：
    
    HEAD twitter/_mapping/tweet

HTTP状态码指示类型是否存在。 `404`表示不存在，`200`表示存在。