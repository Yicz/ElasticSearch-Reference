## 最大线程线检查 Maximum number of threads check

Elasticsearch通过将请求分成几个阶段执行请求，并将这些阶段交给不同的线程池执行。 对于Elasticsearch中的各种任务，有不同的[线程池执行器（thread pool executors）](modules-threadpool.html“Thread Pool”)。 因此，Elasticsearch需要创建大量线程的能力。 线程检查的最大数量确保Elasticsearch进程有权在正常使用情况下创建足够的线程。 此检查仅在Linux上执行。 如果你在Linux上，为了传递最大数量的线程检查，你必须配置你的系统让Elasticsearch进程能够创建至少**2048个线程**。 这可以通过使用`nproc`设置`/etc/security/limits.conf`来完成（注意，你可能还必须增加root用户的限制）。
