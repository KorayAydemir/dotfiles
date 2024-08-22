#!/bin/bash

languages=$(echo "c cpp typescript golang rust python bash node" | tr " " "\n")
core_utils=$(echo "find xargs sed awk" | tr " " "\n")
networking=$(echo "curl wget" | tr " " "\n")
devops=$(echo "git docker" | tr " " "\n")
selected=$(echo -e "$languages\n$core_utils\n$networking\n$devops" | fzf)


read -p "Enter search query: " query

#curled=$(curl cht.sh/$selected/$(echo "$query" | tr " " "+") 2>/dev/null)
#echo $curled

if echo "$languages" | grep -qs $selected; then
    kitty @ launch --title Output

    kitty @ send-text --match 'title:^Output' curl cht.sh/$selected/$(echo "$query" | tr " " "+") '\r'
else
    curl cht.sh/$selected~$query
fi
