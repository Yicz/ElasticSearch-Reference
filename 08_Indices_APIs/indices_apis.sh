#!/bin/sh

dirNames=(Analyze Shadow_replica_indices Flush )
files=(Create_Index.md Delete_Index.md Get_Index.md Indices_Exists.md Open_/_Close_Index_API.md Shrink_Index.md Rollover_Index.md Put_Mapping.md Get_Mapping.md Get_Field_Mapping.md Types_Exists.md Index_Aliases.md Update_Indices_Settings.md Get_Settings.md Analyze/Explain_Analyze.md Analyze/Analyze.md Index_Templates.md Shadow_replica_indices/Node_level_settings_related_to_shadow_replicas.md Shadow_replica_indices/Shadow_replica_indices.md Indices_Stats.md Indices_Segments.md Indices_Recovery.md Indices_Shard_Stores.md Clear_Cache.md Flush/Synced_Flush.md Flush/Flush.md Refresh.md Force_Merge.md )



for dirName in ${dirNames[@]}
do
		mkdir ${dirName}
done

for file in ${files[@]}
do 
		touch ${file}
		echo "To be Continued!">>${file}
done
