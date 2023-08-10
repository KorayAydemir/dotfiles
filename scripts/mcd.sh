#!/bin/bash
echo "Existing code directories"
echo $(find ~/code -mindepth 2 -maxdepth 2 -type d) | tr ' ' '\n' | cut -d'/' -f4- | sort -u 

read -p "Enter the new nested code directory: " input

IFS=' ' read -ra words <<< "$input"

if [ ${#words[@]} -eq 3 ]; then
    word1="${words[0]}"
    word2="${words[1]}"
    word3="${words[2]}"
else
    echo "Please provide exactly 3 space-separated words."
fi

mkdir -p ~/code/$word1/$word2/$word3
cd ~/code/$word1/$word2/$word3

path="/foo/bar/baz"
result=$(echo "$path" | cut -d'/' -f4-)
