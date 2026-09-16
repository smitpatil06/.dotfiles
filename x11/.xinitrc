#!/bin/sh

# Force Qt to use the qt5ct/qt6ct configuration tool
export QT_QPA_PLATFORMTHEME=qt5ct

# Fix scaling for High DPI monitors
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_ENABLE_HIGHDPI_SCALING=1

# Optional: If you use a dark theme, sometimes this helps
export QT_STYLE_OVERRIDE=kvantum

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f $userresources ]; then
    xrdb -merge $userresources
fi

if [ -f $usermodmap ]; then
    xmodmap $usermodmap
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
fi
# Custom
# Define Output Names


# Connect Intel iGPU to NVIDIA GPU
xrandr --setprovideroutputsource modesetting NVIDIA-0 

# Function to extract Resolution and FPS
get_mode_and_rate() {
    local out="$1"
    xrandr --query | awk -v out="$out" '
        $0 ~ "^"out" connected" { grab=1; next }
        /^[A-Za-z0-9_-]+ (connected|disconnected)/ { grab=0 }
        grab && $1 ~ /^[0-9]+x[0-9]+$/ && !res {
            res=$1; max=0
            for (i=2; i<=NF; i++) {
                val=$i; gsub(/[*+]/,"",val)
                if (val+0 > max) max=val+0
            }
            print res, max
            exit
        }
    '
}

EXT=$(xrandr | grep " connected" | grep -i -v "edp" | head -n 1 | awk '{print $1}')
INT=$(xrandr | grep " connected" | grep -i "edp" | head -n 1 | awk '{print $1}')

# Clean up any existing picom instances BEFORE setup
killall -q picom
killall -q slstatus
killall -q dunst


if [ -n "$EXT" ] && [ -n "$INT" ]; then
    read -r RES_EXT FPS_EXT <<< "$(get_mode_and_rate "$EXT")"
    read -r RES_INT FPS_INT <<< "$(get_mode_and_rate "$INT")"

    # nvidia-settings wants an integer Hz in the mode-name (e.g. 100, not 100.00)
    FPS_EXT_INT="${FPS_EXT%%.*}"
    FPS_INT_INT="${FPS_INT%%.*}"

    # INT sits left-of EXT, so EXT's x-offset = INT's width
    INT_W="${RES_INT%%x*}"

    xrandr --output "$EXT" --mode "$RES_EXT" --rate "$FPS_EXT" --primary \
           --output "$INT" --mode "$RES_INT" --rate "$FPS_INT" --left-of "$EXT"

    nvidia-settings --assign CurrentMetaMode="${EXT}: ${RES_EXT}_${FPS_EXT_INT} @${RES_EXT} +${INT_W}+0 {ForceFullCompositionPipeline=On}, ${INT}: ${RES_INT}_${FPS_INT_INT} @${RES_INT} +0+0 {ForceFullCompositionPipeline=On}" &
picom -b &

elif [ -n "$INT" ]; then
    # --- LAPTOP ONLY SETUP (Intel) ---
    # We only auto-configure the internal display. 
    # We don't try to turn off $EXT here because it doesn't exist.
    xrandr --output "$INT" --auto --primary
    
    # Safely turn off all disconnected outputs
    for output in $(xrandr | grep " disconnected" | awk '{print $1}'); do
        xrandr --output "$output" --off
    done

picom -b --vsync &
fi



# --- Background Processes ---
rfkill unblock all &
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

dunst &
slstatus &
thunar --daemon &

# Wallpaper setup
# 1. Immediately set a random wallpaper on boot so the screen isn't blank
feh --bg-fill --randomize ~/Wallpapers/*

# 2. Start the 5-minute background loop daemon
~/suckless/dmenu/scripts/set_wallpaper.sh --loop &
xmousepasteblock &
clipmenud &
udiskie &

# Launch floating sticky notepad (45 columns wide, 15 rows tall, 20px from right, 40px from top)
kitty --class ReminderWidget -e vim ~/.system_reminders.txt &
exec dwm
