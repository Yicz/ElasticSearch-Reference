#!/bin/sh

dirNames=(Cluster
'Discovery'
'Indices'
'Scripting'
)
files=(Cluster/Cluster_Level_Shard_Allocation.md
'Cluster/Disk-based_Shard_Allocation.md'
'Cluster/Shard_Allocation_Awareness.md'
'Cluster/Shard_Allocation_Filtering.md'
'Cluster/Miscellaneous_cluster_settings.md'
'Cluster/Cluster.md'
'Discovery/Azure_Classic_Discovery.md'
'Discovery/EC2_Discovery.md'
'Discovery/Google_Compute_Engine_Discovery.md'
'Discovery/Zen_Discovery.md'
'Discovery/Discovery.md'
'Local_Gateway.md'
'HTTP.md'
'Indices/Circuit_Breaker.md'
'Indices/Fielddata.md'
'Indices/Node_Query_Cache.md'
'Indices/Indexing_Buffer.md'
'Indices/Shard_request_cache.md'
'Indices/Indices_Recovery.md'
'Indices/Indices.md'
'Network_Settings.md'
'Node.md'
'Plugins.md'
'Scripting/How_to_use_scripts.md'
'Scripting/Accessing_document_fields_and_special_variables.md'
'Scripting/Scripting_and_security.md'
'Scripting/Groovy_Scripting_Language.md'
'Scripting/Painless_Scripting_Language.md'
'Scripting/Painless_Syntax.md'
'Scripting/Painless_Debugging.md'
'Scripting/Lucene_Expressions_Language.md'
'Scripting/Native_(Java)_Scripts.md'
'Scripting/Advanced_text_scoring_in_scripts.md'
'Scripting/Scripting.md'
'Snapshot_And_Restore.md'
'Thread_Pool.md'
'Transport.md'
'Tribe_node.md'
'Cross_Cluster_Search.md'
)




for dirName in ${dirNames[@]}
do
		mkdir ${dirName}
done

for file in ${files[@]}
do 
		touch ${file}
		echo "To be Continued!">>${file}
done
