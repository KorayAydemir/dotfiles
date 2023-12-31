#!/usr/bin/env python3

import subprocess
import time

# get current volume
isItAd = 0
currVolume = 0

while 1:
    time.sleep(1)
    if subprocess.run("playerctl --player spotify metadata --format '{{volume}}'", stdout=subprocess.PIPE, shell=True).stdout.decode('utf-8').rstrip("\n") != "0.0":
        currVolume = subprocess.run("playerctl --player spotify metadata --format '{{volume}}'", stdout=subprocess.PIPE, shell=True).stdout.decode('utf-8').rstrip("\n")

# get if an ad is running right now
    isItAd = subprocess.run("playerctl --player spotify metadata --format '{{mpris:trackid}}' | grep '/ad'", stdout=subprocess.PIPE, shell=True).stdout.decode()

# if an ad is running:
    if isItAd:
        # set volume to 0
        subprocess.run("playerctl --player spotify volume 0", shell=True)
# if an ad is not running:
    else:
        # set volume to itself
        # isItAd:
        subprocess.run(f"playerctl --player spotify volume {currVolume}", shell=True)
