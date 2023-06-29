#!/bin/python3
import subprocess

currSong = subprocess.run("playerctl --player spotify metadata --format '{{title}}'", stdout=subprocess.PIPE, shell=True).stdout.decode('utf-8').rstrip("\n")

with open("/home/koray/.config/polybar/isSongLiked.txt", "r") as f:
    lines = f.readlines()

try:
    isSongLiked = lines[0].rstrip("\n")
except:
    isSongLiked = "no"

try:
    prevSong = lines[1].rstrip("\n")
except:
    prevSong = ""

if isSongLiked == "yes":
    print("")
    if prevSong == currSong:
    #write_f.write(currSong)
        pass
    else:
        with open("/home/koray/.config/polybar/isSongLiked.txt", "w") as f:
            f.write(f"no\n{currSong}\n")
        prevSong = currSong
else:
    print("")
    if prevSong == currSong:
    #write_f.write(currSong)
        pass
    else:
        with open("/home/koray/.config/polybar/isSongLiked.txt", "w") as f:
            f.write(f"no\n{currSong}\n")
        prevSong = currSong




