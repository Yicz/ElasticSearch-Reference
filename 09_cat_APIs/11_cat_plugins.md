## cat plugins

The `plugins` command provides a view per node of running plugins. This information **spans nodes**.
    
    
    GET /_cat/plugins?v&s=component&h=name,component,version,description

Might look like:
    
    
    name    component               version   description
    U7321H6 analysis-icu            5.4.3 The ICU Analysis plugin integrates Lucene ICU module into elasticsearch, adding ICU relates analysis components.
    U7321H6 analysis-kuromoji       5.4.3 The Japanese (kuromoji) Analysis plugin integrates Lucene kuromoji analysis module into elasticsearch.
    U7321H6 analysis-phonetic       5.4.3 The Phonetic Analysis plugin integrates phonetic token filter analysis with elasticsearch.
    U7321H6 analysis-smartcn        5.4.3 Smart Chinese Analysis plugin integrates Lucene Smart Chinese analysis module into elasticsearch.
    U7321H6 analysis-stempel        5.4.3 The Stempel (Polish) Analysis plugin integrates Lucene stempel (polish) analysis module into elasticsearch.
    U7321H6 analysis-ukrainian        5.4.3 The Ukrainian Analysis plugin integrates the Lucene UkrainianMorfologikAnalyzer into elasticsearch.
    U7321H6 discovery-azure-classic 5.4.3 The Azure Classic Discovery plugin allows to use Azure Classic API for the unicast discovery mechanism
    U7321H6 discovery-ec2           5.4.3 The EC2 discovery plugin allows to use AWS API for the unicast discovery mechanism.
    U7321H6 discovery-file          5.4.3 Discovery file plugin enables unicast discovery from hosts stored in a file.
    U7321H6 discovery-gce           5.4.3 The Google Compute Engine (GCE) Discovery plugin allows to use GCE API for the unicast discovery mechanism.
    U7321H6 ingest-attachment       5.4.3 Ingest processor that uses Apache Tika to extract contents
    U7321H6 ingest-geoip            5.4.3 Ingest processor that uses looksup geo data based on ip adresses using the Maxmind geo database
    U7321H6 ingest-user-agent       5.4.3 Ingest processor that extracts information from a user agent
    U7321H6 jvm-example             5.4.3 Demonstrates all the pluggable Java entry points in Elasticsearch
    U7321H6 lang-javascript         5.4.3 The JavaScript language plugin allows to have javascript as the language of scripts to execute.
    U7321H6 lang-python             5.4.3 The Python language plugin allows to have python as the language of scripts to execute.
    U7321H6 mapper-attachments      5.4.3 The mapper attachments plugin adds the attachment type to Elasticsearch using Apache Tika.
    U7321H6 mapper-murmur3          5.4.3 The Mapper Murmur3 plugin allows to compute hashes of a field's values at index-time and to store them in the index.
    U7321H6 mapper-size             5.4.3 The Mapper Size plugin allows document to record their uncompressed size at index time.
    U7321H6 store-smb               5.4.3 The Store SMB plugin adds support for SMB stores.

We can tell quickly how many plugins per node we have and which versions.
