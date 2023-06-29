#!/bin/bash
isLiked=`cat ~/.config/polybar/isSongLiked.txt | awk '{print $1;}'`
read word _ <<< "$isLiked"

# spaces are REQUIRED inside [] bash is retarded
if [[ $word == "yes" ]]; then
  sed -i "1s/.*/no/" ~/.config/polybar/isSongLiked.txt
  spotirec -sr
fi

if [[ $word == "no" ]]; then
  sed -i "1s/.*/yes/" ~/.config/polybar/isSongLiked.txt
  spotirec -s
fi
