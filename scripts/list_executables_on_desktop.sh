#!/bin/bash
#ls /usr/share/applications | grep -wvE "/*"
ls /usr/share/applications && ls /usr/local/bin && ls /home/koray/.local/appimages | cat | grep -wvE "/*"
#ls /usr/share/applications < ls /usr/local/bin | grep -wvE "/*" ---- this was working wtf happened
