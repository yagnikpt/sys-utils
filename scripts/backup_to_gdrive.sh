#!/bin/bash

declare -A SOURCE_PATHS=(
    ["$HOME/Documents"]="/"
    ["$HOME/Pictures"]="/"
    ["$HOME/scripts"]="/"
    ["$HOME/.zshrc"]="/"
    ["$HOME/.config/ulauncher"]="/.config"
    ["$HOME/.config/zed"]="/.config"
    ["$HOME/.config/ghostty"]="/.config"
    ["$HOME/.config/fastfetch"]="/.config"
    ["$HOME/codes/dsa"]="/"
)

GDRIVE_MOUNT="/run/user/$UID/gvfs/google-drive:host=gmail.com,user=yagnik.pt"
DEST_FOLDER="$GDRIVE_MOUNT/0AOmWqynKdFWIUk9PVA/1iVs1hakvdkoTiUguLCZ0FcECi7-KF5df"
gio mount google-drive://yagnik.pt@gmail.com/
sleep 5

if [ ! -d "$DEST_FOLDER" ]; then
    exit 1
fi

for PATH in "${!SOURCE_PATHS[@]}"; do
    if [ -d "$PATH" ] || [ -f "$PATH" ]; then
    	if [ $1 == "-v" ]; then
	    /usr/bin/rsync -rv --partial --delete --update "$PATH" "${DEST_FOLDER}${SOURCE_PATHS[$PATH]}"
	else
            /usr/bin/rsync -r --partial --delete --update "$PATH" "${DEST_FOLDER}${SOURCE_PATHS[$PATH]}"
	fi
    fi
done

/usr/bin/notify-send "Files are synced :)" -a "Backup" -e
