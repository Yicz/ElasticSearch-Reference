#!/bin/sh

dirNames=(Index_Shard_Allocation
Store
)
files=(Analysis.md
Index_Shard_Allocation/Shard_Allocation_Filtering.md
Index_Shard_Allocation/Delaying_allocation_when_a_node_leaves.md
Index_Shard_Allocation/Index_recovery_prioritization.md
Index_Shard_Allocation/Total_Shards_Per_Node.md
Index_Shard_Allocation/Index_Shard_Allocation.md
Mapper.md
Merge.md
Similarity_module.md
Slow_Log.md
Store/Pre-loading_data_into_the_file_system_cache.md
Store/Store.md
Translog.md
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
