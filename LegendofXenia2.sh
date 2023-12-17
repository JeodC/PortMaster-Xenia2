#!/bin/bash
if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source "$controlfolder/control.txt"

get_controls

$ESUDO chmod 666 /dev/tty0
$ESUDO chmod 666 /dev/tty1
printf "\033c" > /dev/tty0
printf "\033c" > /dev/tty1

GAMEDIR="/$directory/ports/LegendofXenia2"
if [ -f "/etc/os-release" ]; then
  source "/etc/os-release"
fi 

if [ "$OS_NAME" != "JELOS" ]; then
  export LD_LIBRARY_PATH="/usr/lib:/usr/lib32:/$directory/ports/LegendofXenia2/lib"
fi
 
cd "$GAMEDIR"


export GMLOADER_DEPTH_DISABLE=1
export GMLOADER_SAVEDIR="$GAMEDIR/gamedata/"
export SPA_PLUGIN_DIR="/usr/lib32/spa-0.2"
export PIPEWIRE_MODULE_DIR="/usr/lib32/pipewire-0.3/"

mv gamedata/data.win gamedata/game.droid

$ESUDO chmod 666 /dev/uinput
$GPTOKEYB "gmloader" -c "./xenia2.gptk" &
echo "Loading, please wait... " > /dev/tty0

$ESUDO chmod +x "$GAMEDIR/gmloader"

./gmloader Xenia2.apk |& tee log.txt /dev/tty0

$ESUDO kill -9 "$(pidof gptokeyb)"
$ESUDO systemctl restart oga_events &
printf "\033c" >> /dev/tty1
printf "\033c" > /dev/tty0
