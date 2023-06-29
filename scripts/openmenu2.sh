#!/bin/sh

mycache=~/scripts/executables.cache

choice=`cat $mycache | \
  dmenu -i -f \
  -fn 1 \
  -nf white -nb '#171817' -sf '#181926' -sb '#f4dbd6'\
  -p 'What the fuck do you want?'`

if [ "$?" = "0" ]; then
  if [[ $choice == *.AppImage ]]; then
    chmod +x "$choice"
    "$choice"
  else
    gtk-launch "$choice"
  fi
fi

~/scripts/list_executables_on_desktop.sh > $mycache

