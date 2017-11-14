#!/bin/sh

dirNames=()
files=(Cluster_Health.md Cluster_State.md Cluster_Stats.md Pending_cluster_tasks.md Cluster_Reroute.md Cluster_Update_Settings.md Nodes_Stats.md Nodes_Info.md Remote_Cluster_Info.md Task_Management_API.md Nodes_hot_threads.md Cluster_Allocation_Explain_API.md )



for dirName in ${dirNames[@]}
do
		mkdir ${dirName}
done

for file in ${files[@]}
do 
		touch ${file}
		echo "To be Continued!">>${file}
done
