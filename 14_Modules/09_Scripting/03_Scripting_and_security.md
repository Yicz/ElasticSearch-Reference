## Scripting and security

While Elasticsearch contributors make every effort to prevent scripts from running amok, security is something best done in [layers](https://en.wikipedia.org/wiki/Defense_in_depth_\(computing\)) because all software has bugs and it is important to minimize the risk of failure in any security layer. Find below rules of thumb for how to keep Elasticsearch from being a vulnerability.

### Do not run as root

First and foremost, never run Elasticsearch as the `root` user as this would allow any successful effort to circumvent the other security layers to do **anything** on your server. Elasticsearch will refuse to start if it detects that it is running as `root` but this is so important that it is worth double and triple checking.

### Do not expose Elasticsearch directly to users

Do not expose Elasticsearch directly to users, instead have an application make requests on behalf of users. If this is not possible, have an application to sanitize requests from users. If **that** is not possible then have some mechanism to track which users did what. Understand that it is quite possible to write a [`_search`](search.html "Search APIs") that overwhelms Elasticsearch and brings down the cluster. All such searches should be considered bugs and the Elasticsearch contributors make an effort to prevent this but they are still possible.

### Do not expose Elasticsearch directly to the Internet

Do not expose Elasticsearch to the Internet, instead have an application make requests on behalf of the Internet. Do not entertain the thought of having an application "sanitize" requests to Elasticsearch. Understand that it is possible for a sufficiently determined malicious user to write searches that overwhelm the Elasticsearch cluster and bring it down. For example:

Good: * Users type text into a search box and the text is sent directly to a [Match Query](query-dsl-match-query.html "Match Query"), [Match Phrase Query](query-dsl-match-query-phrase.html "Match Phrase Query"), [Simple Query String Query](query-dsl-simple-query-string-query.html "Simple Query String Query"), or any of the [_Suggesters_](search-suggesters.html "Suggesters"). * Running a script with any of the above queries that was written as part of the application development process. * Running a script with `params` provided by users. * User actions makes documents with a fixed structure.

Bad: * Users can write arbitrary scripts, queries, `_search` requests. * User actions make documents with structure defined by users.

### Do not weaken script security settings

By default Elasticsearch will run inline, stored, and filesystem scripts for sandboxed languages, namely the scripting language Painless, the template language Mustache, and the expression language Expressions. These **ought** to be safe to expose to trusted users and to your application servers because they have strong security sandboxes. By default Elasticsearch will only run filesystem scripts for non-sandboxed languages and enabling them is a poor choice because: 1\. This drops a layer of security, leaving only Elasticsearch’s builtin [security layers](modules-scripting-security.html#modules-scripting-other-layers "Other security layersedit"). 2\. Non-sandboxed scripts have unchecked access to Elasticsearch’s internals and can cause all kinds of trouble if misused.

### Other security layers

In addition to user privileges and script sandboxing Elasticsearch uses the [Java Security Manager](http://www.oracle.com/technetwork/java/seccodeguide-139067.html) and native security tools as additional layers of security.

As part of its startup sequence Elasticsearch enables the Java Security Manager which limits the actions that can be taken by portions of the code. Painless uses this to limit the actions that generated Painless scripts can take, preventing them from being able to do things like write files and listen to sockets.

Elasticsearch uses [seccomp](https://en.wikipedia.org/wiki/Seccomp) in Linux, [Seatbelt](https://www.chromium.org/developers/design-documents/sandbox/osx-sandboxing-design) in macOS, and [ActiveProcessLimit](https://msdn.microsoft.com/en-us/library/windows/desktop/ms684147) on Windows to prevent Elasticsearch from forking or executing other processes.

Below this we describe the security settings for scripts and how you can change from the defaults described above. You should be very, very careful when allowing more than the defaults. Any extra permissions weakens the total security of the Elasticsearch deployment.

### Script source settings

Which scripts Elasticsearch will execute where is controlled by settings starting with `scripts.`. The simplest settings allow scripts to be enabled or disabled based on where they are stored. For example:
    
    
    script.inline: false  ![](images/icons/callouts/1.png)
    script.stored: false  ![](images/icons/callouts/2.png)
    script.file:   true   ![](images/icons/callouts/3.png)

![](images/icons/callouts/1.png)

| 

Refuse to run scripts provided inline in the API.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Refuse to run scripts stored using the API.   
  
![](images/icons/callouts/3.png)

| 

Run scripts found on the filesystem in `/etc/elasticsearch/scripts` (rpm or deb) or `config/scripts` (zip or tar).   
  
![Note](images/icons/note.png)

These settings override the defaults mentioned [above](modules-scripting-security.html#modules-scripting-security-do-no-weaken "Do not weaken script security settingsedit"). Recreating the defaults requires more fine grained settings described [below](modules-scripting-security.html#security-script-fine "Fine-grained script settingsedit").

### Script context settings

Scripting may also be enabled or disabled in different contexts in the Elasticsearch API. The supported contexts are:

`aggs`

| 

Aggregations   
  
---|---  
  
`search`

| 

Search api, Percolator API and Suggester API   
  
`update`

| 

Update api   
  
`plugin`

| 

Any plugin that makes use of scripts under the generic `plugin` category   
  
Plugins can also define custom operations that they use scripts for instead of using the generic `plugin` category. Those operations can be referred to in the following form: `${pluginName}_${operation}`.

The following example disables scripting for `update` and `plugin` operations, regardless of the script source or language. Scripts can still be executed from sandboxed languages as part of `aggregations`, `search` and plugins execution though, as the above defaults still get applied.
    
    
    script.update: false
    script.plugin: false

### Fine-grained script settings

First, the high-level script settings described above are applied in order (context settings have precedence over source settings). Then fine-grained settings which include the script language take precedence over any high-level settings. They have two forms:
    
    
    script.engine.{lang}.{inline|file|stored}.{context}: true|false

And
    
    
    script.engine.{lang}.{inline|file|stored}: true|false

For example:
    
    
    script.inline: false ![](images/icons/callouts/1.png)
    script.stored: false ![](images/icons/callouts/2.png)
    script.file:   false ![](images/icons/callouts/3.png)
    
    script.engine.painless.inline:          true ![](images/icons/callouts/4.png)
    script.engine.painless.stored.search:   true ![](images/icons/callouts/5.png)
    script.engine.painless.stored.aggs:     true ![](images/icons/callouts/6.png)
    
    script.engine.mustache.stored.search:   true ![](images/icons/callouts/7.png)

![](images/icons/callouts/1.png) ![](images/icons/callouts/2.png) ![](images/icons/callouts/3.png)

| 

Disable all scripting from any source.   
  
---|---  
  
![](images/icons/callouts/4.png)

| 

Allow inline Painless scripts for all operations.   
  
![](images/icons/callouts/5.png) ![](images/icons/callouts/6.png)

| 

Allow stored Painless scripts to be used for search and aggregations.   
  
![](images/icons/callouts/7.png)

| 

Allow stored Mustache templates to be used for search.   
  
### Java Security Manager

As mentioned above, Elasticsearch runs with the [Java Security Manager](https://docs.oracle.com/javase/tutorial/essential/environment/security.html) enabled by default. The security policy in Elasticsearch locks down the permissions granted to each class to the bare minimum required to operate. The benefit of doing this is that it severely limits the attack vectors available to a hacker.

Restricting permissions is particularly important for non-sandboxed scripting languages like Groovy and Javascript which are designed to do anything that can be done in Java itself, including writing to the file system, opening sockets to remote servers, etc.

### Script Classloader Whitelist

Groovy makes an effort to prevent loading classes which do not appear in a hardcoded whitelist that can be found in [`org.elasticsearch.script.ClassPermission`](https://github.com/elastic/elasticsearch/blob/5.4/core/src/main/java/org/elasticsearch/script/ClassPermission.java).

In a script, attempting to load a class that does not appear in the whitelist _may_ result in a `ClassNotFoundException`, for instance this script:
    
    
    GET _search
    {
      "script_fields": {
        "the_hour": {
          "script": "use(java.math.BigInteger); new BigInteger(1)"
        }
      }
    }

will return the following exception:
    
    
    {
      "reason": {
        "type": "script_exception",
        "reason": "failed to run inline script [use(java.math.BigInteger); new BigInteger(1)] using lang [groovy]",
        "caused_by": {
          "type": "no_class_def_found_error",
          "reason": "java/math/BigInteger",
          "caused_by": {
            "type": "class_not_found_exception",
            "reason": "java.math.BigInteger"
          }
        }
      }
    }

However, classloader issues may also result in more difficult to interpret exceptions. For instance, this script:
    
    
    use(groovy.time.TimeCategory); new Date(123456789).format('HH')

Returns the following exception:
    
    
    {
      "reason": {
        "type": "script_exception",
        "reason": "failed to run inline script [use(groovy.time.TimeCategory); new Date(123456789).format('HH')] using lang [groovy]",
        "caused_by": {
          "type": "missing_property_exception",
          "reason": "No such property: groovy for class: 8d45f5c1a07a1ab5dda953234863e283a7586240"
        }
      }
    }

## Dealing with Java Security Manager issues

If you encounter issues with the Java Security Manager, you have two options for resolving these issues:

### Fix the security problem

The safest and most secure long term solution is to change the code causing the security issue. We recognise that this may take time to do correctly and so we provide the following two alternatives.

### Customising the classloader whitelist

The classloader whitelist can be customised by tweaking the local Java Security Policy either:

  * system wide: `$JAVA_HOME/lib/security/java.policy`, 
  * for just the `elasticsearch` user: `/home/elasticsearch/.java.policy`
  * by adding a system property to the [jvm.options](setting-system-settings.html#jvm-options "Setting JVM options") configuration: `-Djava.security.policy=someURL`, or 
  * via the `ES_JAVA_OPTS` environment variable with `-Djava.security.policy=someURL`: 
    
        export ES_JAVA_OPTS="${ES_JAVA_OPTS} -Djava.security.policy=file:///path/to/my.policy`
    ./bin/elasticsearch




Permissions may be granted at the class, package, or global level. For instance:
    
    
    grant {
        permission org.elasticsearch.script.ClassPermission "java.util.Base64"; // allow class
        permission org.elasticsearch.script.ClassPermission "java.util.*"; // allow package
        permission org.elasticsearch.script.ClassPermission "*"; // allow all (disables filtering basically)
    };

Here is an example of how to enable the `groovy.time.TimeCategory` class:
    
    
    grant {
        permission org.elasticsearch.script.ClassPermission "java.lang.Class";
        permission org.elasticsearch.script.ClassPermission "groovy.time.TimeCategory";
    };

![Tip](images/icons/tip.png)

Before adding classes to the whitelist, consider the security impact that it will have on Elasticsearch. Do you really need an extra class or can your code be rewritten in a more secure way?

It is quite possible that we have not whitelisted a generically useful and safe class. If you have a class that you think should be whitelisted by default, please open an issue on GitHub and we will consider the impact of doing so.

See <http://docs.oracle.com/javase/7/docs/technotes/guides/security/PolicyFiles.html> for more information.
