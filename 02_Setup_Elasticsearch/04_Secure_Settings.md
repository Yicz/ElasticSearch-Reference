## Secure Settings

Some settings are sensitive, and relying on filesystem permissions to protect their values is not sufficient. For this use case, elasticsearch provides a keystore, which may be password protected, and the `elasticsearch-keystore` tool to manage the settings in the keystore.

![Note](images/icons/note.png)

All commands here should be run as the user which will run elasticsearch.

![Note](images/icons/note.png)

Only some settings are designed to be read from the keystore. See documentation for each setting to see if it is supported as part of the keystore.

### Creating the keystore

To create the `elasticsearch.keystore`, use the `create` command:
    
    
    bin/elasticsearch-keystore create

The file `elasticsearch.keystore` will be created alongside `elasticsearch.yml`.

### Listing settings in the keystore

A list of the settings in the keystore is available with the `list` command:
    
    
    bin/elasticsearch-keystore list

### Adding string settings

Sensitive string settings, like authentication credentials for cloud plugins, can be added using the `add` command:
    
    
    bin/elasticsearch-keystore add the.setting.name.to.set

The tool will prompt for the value of the setting. To pass the value through stdin, use the `--stdin` flag:
    
    
    cat /file/containing/setting/value | bin/elasticsearch-keystore add --stdin the.setting.name.to.set

### Removing settings

To remove a setting from the keystore, use the `remove` command:
    
    
    bin/elasticsearch-keystore remove the.setting.name.to.remove
