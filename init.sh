declare -a arr=("Getting_Started"
"Setup_Elasticsearch"
"Breaking_changes"
"API_Conventions"
"Document_APIs"
"Search_APIs"
"Aggregations"
"Indices_APIs"
"cat_APIs"
"Cluster_APIs"
"Query_DSL"
"Mapping"
"Analysis"
"Modules"
"Index_Modules"
"Ingest_Node"
"How_To"
"Testing"
"Glossary_of_terms"
"Release_Notes")
index=1
for i in "${arr[@]}"
do
	dirName=''
	if [ ${#index} = 1 ] 
	then
		dirName="0${index}_$i"
	else
		dirName="${index}_$i"
	fi
 #    mkdir $dirName
 #    touch "$dirName/$i.md"
    # echo  "To be continued">>"$dirName/$i.md"
    echo "$dirName/$i.md"
    let index+=1
   # or do whatever with individual element of the array
done

