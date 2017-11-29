## 检查系统调用过滤器（System call filter）


ES根据不同的平台安装发不一样的系统调用过滤器（如：在Linux上使用的是seccomp）。安装这些系统调用过滤器是为了防止执行与子进程（forking）相关的系统调用的能力，作为抵御Elasticsearch上的任意代码执行攻击的防御机制。系统调用过滤器检查确保如果系统调用过滤器被启用，则成功安装它们。 要通过系统调用过滤器检查，您必须修复系统中阻止系统调用过滤器安装（检查日志）的任何配置错误，或者通过将bootstrap.system_call_filter设置为false来禁用系统调用过滤器，您必须自行承担禁用过滤器系统调用检查带来的风险。

elasticsearch.yaml


    bootstrap.system_call_filter: false