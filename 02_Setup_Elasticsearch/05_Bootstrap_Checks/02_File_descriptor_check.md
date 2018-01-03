## 文件描述符检查（linux 下打开文件数的大小） File descriptor check

文件描述符是用于跟踪打开“文件”的Unix结构。 在Unix中，[一切都是文件](https://en.wikipedia.org/wiki/Everything_is_a_file)。 例如，“文件”可以是物理文件，虚拟文件（例如`/ proc / loadavg`）或网络套接字(socket)。 Elasticsearch需要大量的文件描述符（例如，每个分片由多个段和其他文件组成，加上到其他节点的连接等）。 此引导程序检查（boostrap check）强制在OS X和Linux上执行。 要通过文件描述符检查，可能需要配置[文件描述符](file-descriptors.html“文件描述符”)
