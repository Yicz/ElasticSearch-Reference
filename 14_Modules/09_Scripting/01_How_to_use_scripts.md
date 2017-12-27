## How to use scripts

Wherever scripting is supported in the Elasticsearch API, the syntax follows the same pattern:
    
    
      "script": {
        "lang":   "...",  #1
        "inline" | "stored" | "file": "...", #2
        "params": { ... } #3
      }

#1| The language the script is written in, which defaults to `painless`.     
---|---    
#2| The script itself which may be specified as `inline`, `stored`, or `file`.     
#3| Any named parameters that should be passed into the script.   
  
For example, the following script is used in a search request to return a [scripted field](search-request-script-fields.html):
    
    
    PUT my_index/my_type/1
    {
      "my_field": 5
    }
    
    GET my_index/_search
    {
      "script_fields": {
        "my_doubled_field": {
          "script": {
            "lang":   "expression",
            "inline": "doc['my_field'] * multiplier",
            "params": {
              "multiplier": 2
            }
          }
        }
      }
    }

### Script Parameters

`lang`
     Specifies the language the script is written in. Defaults to `painless` but may be set to any of languages listed in [_Scripting_](modules-scripting.html). The default language may be changed in the `elasticsearch.yml` config file by setting `script.default_lang` to the appropriate language. 
`inline`, `stored`, `file`
    

Specifies the source of the script. An `inline` script is specified `inline` as in the example above, a `stored` script is specified `stored` and is retrieved from the cluster state (see [Stored Scripts](modules-scripting-using.html#modules-scripting-stored-scripts)), and a `file` script is retrieved from a file in the `config/scripts` directory (see [File Scripts](modules-scripting-using.html#modules-scripting-file-scripts)). 

While languages like `expression` and `painless` can be used out of the box as inline or stored scripts, other languages like `groovy` can only be specified as `file` unless you first adjust the default [scripting security settings](modules-scripting-security.html).

`params`
     Specifies any named parameters that are passed into the script as variables. 

![Important](images/icons/important.png)

### Prefer parameters

The first time Elasticsearch sees a new script, it compiles it and stores the compiled version in a cache. Compilation can be a heavy process.

If you need to pass variables into the script, you should pass them in as named `params` instead of hard-coding values into the script itself. For example, if you want to be able to multiply a field value by different multipliers, don’t hard-code the multiplier into the script:
    
    
      "inline": "doc['my_field'] * 2"

Instead, pass it in as a named parameter:
    
    
      "inline": "doc['my_field'] * multiplier",
      "params": {
        "multiplier": 2
      }

The first version has to be recompiled every time the multiplier changes. The second version is only compiled once.

If you compile too many unique scripts within a small amount of time, Elasticsearch will reject the new dynamic scripts with a `circuit_breaking_exception` error. By default, up to 15 inline scripts per minute will be compiled. You can change this setting dynamically by setting `script.max_compilations_per_minute`.

### File-based Scripts

To increase security, non-sandboxed languages can only be specified in script files stored on every node in the cluster. File scripts must be saved in the `scripts` directory whose default location depends on whether you use the [`zip`/`tar.gz`](zip-targz.html#zip-targz-layout) (`$ES_HOME/config/scripts/`), [RPM](rpm.html#rpm-layout), or [Debian](deb.html#deb-layout) package. The default may be changed with the `path.scripts` setting.

The languages which are assumed to be safe by default are: `painless`, `expression`, and `mustache` (used for search and query templates).

Any files placed in the `scripts` directory will be compiled automatically when the node starts up and then [every 60 seconds thereafter](modules-scripting-using.html#reload-scripts).

The file should be named as follows: `{script-name}.{lang}`. For instance, the following example creates a Groovy script called `calculate-score`:
    
    
    echo "Math.log(_score * 2) + params.my_modifier" > config/scripts/calculate_score.painless

This script can be used as follows:
    
    
    GET my_index/_search
    {
      "query": {
        "script": {
          "script": {
            "lang":   "painless", #1
            "file":   "calculate_score", #2
            "params": {
              "my_modifier": 2
            }
          }
        }
      }
    }

#1| The language of the script, which should correspond with the script file suffix.     
---|---    
#2| The name of the script, which should be the name of the file.   
  
The `script` directory may contain sub-directories, in which case the hierarchy of directories is flattened and concatenated with underscores. A script in `group1/group2/my_script.groovy` should use `group1_group2_myscript` as the `file` name.

#### Automatic script reloading

The `scripts` directory will be rescanned every `60s` (configurable with the `resource.reload.interval` setting) and new, changed, or removed scripts will be compiled, updated, or deleted from the script cache.

Script reloading can be completely disabled by setting `script.auto_reload_enabled` to `false`.

### Stored Scripts

Scripts may be stored in and retrieved from the cluster state using the `_scripts` end-point.

### Deprecated Namespace

The namespace for stored scripts using both `lang` and `id` as a unique identifier has been deprecated. The new namespace for stored scripts will only use `id`. Stored scripts with the same `id`, but different `lang`'s will no longer be allowed in 6.0. To comply with the new namespace for stored scripts, existing stored scripts should be deleted and put again. Any scripts that share an `id` but have different `lang`s will need to be re-named. For example, take the following:

"id": "example", "lang": "painless" "id": "example", "lang": "expressions"

The above scripts will conflict under the new namespace since the id’s are the same. At least one will have to be re-named to comply with the new namespace of only `id`.

As a final caveat, stored search templates and stored scripts share the same namespace, so if a search template has the same `id` as a stored script, one of the two will have to be re-named as well using delete and put requests.

### Request Examples

The following are examples of using a stored script that lives at `/_scripts/{id}`.

First, create the script called `calculate-score` in the cluster state:
    
    
    POST _scripts/calculate-score
    {
      "script": {
        "lang": "painless",
        "code": "Math.log(_score * 2) + params.my_modifier"
      }
    }

This same script can be retrieved with:
    
    
    GET _scripts/calculate-score

Stored scripts can be used by specifying the `stored` parameters as follows:
    
    
    GET _search
    {
      "query": {
        "script": {
          "script": {
            "stored": "calculate-score",
            "params": {
              "my_modifier": 2
            }
          }
        }
      }
    }

And deleted with:
    
    
    DELETE _scripts/calculate-score

### Script Caching

All scripts are cached by default so that they only need to be recompiled when updates occur. File scripts keep a static cache and will always reside in memory. Both inline and stored scripts are stored in a cache that can evict residing scripts. By default, scripts do not have a time-based expiration, but you can change this behavior by using the `script.cache.expire` setting. You can configure the size of this cache by using the `script.cache.max_size` setting. By default, the cache size is `100`.

![Note](images/icons/note.png)

The size of stored scripts is limited to 65,535 bytes. This can be changed by setting `script.max_size_in_bytes` setting to increase that soft limit, but if scripts are really large then alternatives like [native](modules-scripting-native.html) scripts should be considered instead.
