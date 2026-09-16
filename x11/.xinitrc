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

EXT=$(xrandr | grep " connected" | grep -i -v "edp" | head -n 1 | awk '{print $1}')
INT=$(xrandr | grep " connected" | grep -i "edp" | head -n 1 | awk '{print $1}')

# Clean up any existing picom instances BEFORE setup
killall -q picom
killall -q slstatus
killall -q dunst


if [ -n "$EXT" ] && [ -n "$INT" ]; then
    # --- DUAL MONITOR SETUP (NVIDIA) ---
    xrandr --output "$EXT" --mode 1920x1080 --rate 100.00 --primary \
           --output "$INT" --mode 1920x1200 --rate 100.00 --right-of "$EXT"

    # Optional: NVIDIA Driver VSync (ForceCompositionPipeline)
    # Note: nvidia-settings uses its own naming convention (like HDMI-0 instead of HDMI-1-0).
    # If you get screen tearing on the external monitor, uncomment and adjust the name below.
nvidia-settings --assign CurrentMetaMode="${EXT}: 1920x1080_100 @1920x1080 +1920+0 {ForceFullCompositionPipeline=On}, ${INT}: 1920x1200_165 @1920x1200 +0+0 {ForceFullCompositionPipeline=On}" &	

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

# Wallpaper setup
# 1. Immediately set a random wallpaper on boot so the screen isn't blank
feh --bg-fill --randomize ~/Wallpapers/*

# 2. Start the 5-minute background loop daemon
~/suckless/dmenu/scripts/set_wallpaper.sh --loop &

clipmenud &
udiskie &
# Launch floating sticky notepad (45 columns wide, 15 rows tall, 20px from right, 40px from top)
kitty --class ReminderWidget -e vim ~/.system_reminders.txt &
exec dwm
