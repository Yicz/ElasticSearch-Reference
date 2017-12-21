#!/bin/bash

find .  -name '*.md' -type f|xargs sed -i '' 's/{{{/{ { {/g'
find .  -name '*.md' -type f|xargs sed -i '' 's/{{/{ {/g'
find .  -name '*.md' -type f|xargs sed -i '' 's/{{/{ {/g'
find .  -name '*.md' -type f|xargs sed -i '' 's/}}}/} } }/g'
find .  -name '*.md' -type f|xargs sed -i '' 's/}}/} }/g'
find .  -name '*.md' -type f|xargs sed -i '' 's/}}/} }/g'
