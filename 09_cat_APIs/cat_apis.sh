#!/bin/sh
dirNames=()
files=(cat_aliases.md cat_allocation.md cat_count.md cat_fielddata.md cat_health.md cat_indices.md cat_master.md cat_nodeattrs.md cat_nodes.md cat_pending_tasks.md cat_plugins.md cat_recovery.md cat_repositories.md cat_thread_pool.md cat_shards.md cat_segments.md cat_snapshots.md cat_templates.md )



for dirName in ${dirNames[@]}
do
		mkdir ${dirName}
done

for file in ${files[@]}
do 
		touch ${file}
		echo "To be Continued!">>${file}
done
