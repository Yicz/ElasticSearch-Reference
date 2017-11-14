#!/bin/sh

dirNames=(Ingest_APIs
Processors
)
files=(Pipeline_Definition.md
Ingest_APIs/Put_Pipeline_API.md
Ingest_APIs/Get_Pipeline_API.md
Ingest_APIs/Delete_Pipeline_API.md
Ingest_APIs/Simulate_Pipeline_API.md
Ingest_APIs/Ingest_APIs.md
Accessing_Data_in_Pipelines.md
Handling_Failures_in_Pipelines.md
Processors/Append_Processor.md
Processors/Convert_Processor.md
Processors/Date_Processor.md
Processors/Date_Index_Name_Processor.md
Processors/Fail_Processor.md
Processors/Foreach_Processor.md
Processors/Grok_Processor.md
Processors/Gsub_Processor.md
Processors/Join_Processor.md
Processors/JSON_Processor.md
Processors/KV_Processor.md
Processors/Lowercase_Processor.md
Processors/Remove_Processor.md
Processors/Rename_Processor.md
Processors/Script_Processor.md
Processors/Set_Processor.md
Processors/Split_Processor.md
Processors/Sort_Processor.md
Processors/Trim_Processor.md
Processors/Uppercase_Processor.md
Processors/Dot_Expander_Processor.md
Processors/Processors.md
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
