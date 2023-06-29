#!/bin/python3

isLiked = subprocess.run("playerctl --player spotify metadata --format '{{title}}'", stdout=subprocess.PIPE, shell=True).stdout.decode('utf-8').rstrip("\n")
 
