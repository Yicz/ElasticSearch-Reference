## OnError and OnOutOfMemoryError checks

如果JVM遇到致命错误（“OnError”）或“OutOfMemoryError”（“OnOutOfMemoryError”），则JVM选项“OnError”和“OnOutOfMemoryError”可以执行任意命令。 但是，默认情况下，Elasticsearch系统调用筛选器（seccomp）已启用，并且这些筛选器可防止分叉。 因此，使用`OnError`或`OnOutOfMemoryError`和系统调用过滤器是不兼容的。 如果使用了这些JVM选项中的任何一个，并启用了系统调用过滤器，则“OnError”和“OnOutOfMemoryError”检查将阻止启动Elasticsearch。 此检查始终执行。 要通过这个检查，不要启用“OnError”或者“OnOutOfMemoryError”。 相反，升级到Java 8u92并使用JVM标志“ExitOnOutOfMemoryError”。 虽然这不具备“OnError”和“OnOutOfMemoryError”的全部功能，但启用seccomp时将不支持任意分叉。

