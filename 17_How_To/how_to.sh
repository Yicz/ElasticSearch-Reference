#!/bin/sh

dirNames=()
files=(General_recommendations.md Recipes.md Tune_for_indexing_speed.md Tune_for_search_speed.md Tune_for_disk_usage.md )



for dirName in ${dirNames[@]}
do
		mkdir ${dirName}
done

for file in ${files[@]}
do 
		touch ${file}
		echo "To be Continued!">>${file}
done
