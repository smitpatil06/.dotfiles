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
EXT="HDMI-1-0"
INT="eDP-1"

# Clean up any existing picom instances BEFORE setup
killall -q picom

# Connect Intel iGPU to NVIDIA GPU
xrandr --setprovideroutputsource modesetting NVIDIA-0

if xrandr | grep -q "$EXT connected"; then
    # --- DUAL MONITOR SETUP (NVIDIA) ---
    xrandr --output $EXT --mode 1920x1080 --rate 100.00 --primary \
           --output $INT --mode 1920x1200 --rate 60.00 --left-of $EXT

    # NVIDIA Driver handles VSync (ForceCompositionPipeline)
    nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 {ForceCompositionPipeline=On}" &
    
    # Light Picom (Driver does VSync, so we don't need to)
    picom -b &

else
    # --- LAPTOP ONLY SETUP (Intel) ---
    xrandr --output $INT --auto --primary --output $EXT --off

    # Heavy Picom (Compositor MUST handle VSync to stop tearing)
    picom --backend glx --vsync --no-fading-openclose &
fi

# --- Background Processes ---
rfkill unblock wlan &
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

dunst &
slstatus &

# Wallpaper loop
while true; do
    feh --bg-fill --randomize ~/Wallpapers/*
    sleep 300
done &

exec dwm
