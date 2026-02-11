# 🚀 EndeavourOS + DWM Dotfiles

<div align="center">

![EndeavourOS](https://img.shields.io/badge/EndeavourOS-7F7FFF?style=for-the-badge&logo=arch-linux&logoColor=white)
![DWM](https://img.shields.io/badge/DWM-1177AA?style=for-the-badge&logo=suckless&logoColor=white)
![Alacritty](https://img.shields.io/badge/Alacritty-F46D01?style=for-the-badge&logo=alacritty&logoColor=white)
![GNU Stow](https://img.shields.io/badge/GNU_Stow-A42E2B?style=for-the-badge&logo=gnu&logoColor=white)

*A meticulously crafted configuration for a minimalist, performant Linux desktop environment*

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [System Stack](#-system-stack)
- [Philosophy](#-philosophy)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Configuration Management](#-configuration-management)
- [Component Details](#-component-details)
- [Customization](#-customization)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Overview

This repository contains my personal dotfiles for a lightweight, highly customizable desktop environment built on **EndeavourOS** with the **DWM** window manager. The configuration prioritizes performance, minimalism, and aesthetic appeal while maintaining practical usability for daily development work.

All configurations are version-controlled and managed using **GNU Stow**, enabling easy deployment, rollback, and synchronization across multiple machines.

---

## 🖥️ System Stack

| Component        | Software                                    | Description                                          |
|------------------|---------------------------------------------|------------------------------------------------------|
| **OS**           | EndeavourOS (Arch-based)                   | Rolling-release Arch Linux derivative                |
| **Window Manager** | DWM (Suckless)                           | Dynamic, lightweight tiling window manager           |
| **Terminal**     | Alacritty                                  | GPU-accelerated terminal emulator                    |
| **Color Scheme** | Catppuccin Mocha / Gruvbox                 | Multiple theme options for Alacritty                 |
| **Compositor**   | Picom (GLX backend)                        | Compositing manager optimized for NVIDIA GPUs        |
| **GTK Theme**    | GTK-3.0 (Adwaita Dark)                     | GTK+ 3 theme configuration                           |
| **X11 Session**  | .xinitrc                                   | X session startup configuration with dual-monitor support |
| **Config Manager** | GNU Stow                                 | Symlink farm manager for dotfiles                    |

---

## 💡 Philosophy

### GNU Stow: Elegant Symlink Management

This dotfiles repository embraces the **GNU Stow** methodology for configuration management. Instead of scattering configuration files across your system or manually maintaining symlinks, GNU Stow provides an elegant, maintainable solution:

#### Core Principles

1. **Centralized Repository**: All configurations live in `~/dotfiles/` (or your chosen location)
2. **Symlink Automation**: GNU Stow creates and manages symlinks from `~/dotfiles/` to `~/.config/` and other target locations
3. **Modular Structure**: Each application has its own "stow package" (directory), making it easy to install/remove configurations independently
4. **Version Control**: The entire configuration is git-tracked, enabling history, rollback, and collaboration
5. **Portability**: Deploy your entire setup to a new machine with just a few commands

#### How It Works

```
~/dotfiles/               ← Your dotfiles repository (this repo)
├── alacritty/
│   └── .config/
│       └── alacritty/
│           ├── alacritty.toml
│           ├── catppuccin-mocha.toml
│           └── gruvbox_*.toml (multiple theme files)
├── picom/
│   └── .config/
│       └── picom/
│           └── picom.conf
├── gtk-3.0/
│   └── .config/
│       └── gtk-3.0/
│           └── settings.ini
└── x11/
    └── .xinitrc

When you run: `stow alacritty`

~/                        ← Your home directory
└── .config/
    └── alacritty/
        └── alacritty.toml ← Symlink to ~/dotfiles/alacritty/.config/alacritty/alacritty.toml
```

**Key Benefit**: Edit files in `~/dotfiles/`, and changes immediately reflect in `~/.config/` through symlinks. Commit, push, and your configurations are safely backed up and portable.

---

## ✅ Prerequisites

Before installing these dotfiles, ensure you have the following installed on your EndeavourOS system:

```bash
# Update system
sudo pacman -Syu

# Install required packages
sudo pacman -S stow git base-devel

# Install core components
sudo pacman -S alacritty picom gtk3

# Optional: Install DWM (needs to be compiled from source)
# Clone DWM from suckless.org or use your patched version
```

### NVIDIA Users

If you're using NVIDIA proprietary drivers:

```bash
# Ensure you have the NVIDIA drivers installed
sudo pacman -S nvidia nvidia-utils
```

The Picom configuration in this repository uses the **GLX backend** specifically for NVIDIA stability.

---

## 🚀 Installation

### 1. Clone the Repository

```bash
# Clone to your home directory
cd ~
git clone https://github.com/smitpatil06/.dotfiles.git dotfiles
cd dotfiles
```

### 2. Backup Existing Configurations

**Important**: Before stowing, backup any existing configurations to prevent conflicts:

```bash
# Backup existing configs
mkdir -p ~/config_backup
cp -r ~/.config/alacritty ~/config_backup/ 2>/dev/null
cp -r ~/.config/picom ~/config_backup/ 2>/dev/null
cp -r ~/.config/gtk-3.0 ~/config_backup/ 2>/dev/null
cp ~/.xinitrc ~/config_backup/ 2>/dev/null
# Add other components as needed
```

### 3. Stow Configurations

GNU Stow creates symlinks from the dotfiles directory to your home directory:

```bash
# From within ~/dotfiles directory

# Stow all configurations at once
stow */

# OR stow individually for more control
stow alacritty
stow picom
stow gtk-3.0
stow x11
# ... and so on for each component
```

### 4. Verify Symlinks

```bash
# Check that symlinks were created correctly
ls -la ~/.config/alacritty/
ls -la ~/.config/picom/
ls -la ~/.config/gtk-3.0/
ls -la ~/.xinitrc

# You should see symlinks pointing to ~/dotfiles/
```

### 5. Apply DWM Configuration (Optional)

If you're using DWM, it needs to be compiled from source. This repository doesn't include a dwm directory, as DWM is typically maintained separately:

```bash
# Navigate to your DWM source directory
cd ~/path/to/dwm

# Configure and rebuild DWM
sudo make clean install
```

---

## 🔧 Configuration Management

### Adding New Configurations

```bash
# Create a new stow package for a new application
cd ~/dotfiles
mkdir -p myapp/.config/myapp

# Add your config files
# Then stow it
stow myapp
```

### Removing Configurations

```bash
# Unstow removes the symlinks
cd ~/dotfiles
stow -D alacritty  # Removes alacritty symlinks
```

### Updating Configurations

```bash
# Simply edit files in ~/dotfiles/
cd ~/dotfiles
nvim alacritty/.config/alacritty/alacritty.toml

# Changes are immediately active (via symlinks)
# Commit your changes
git add .
git commit -m "Update alacritty color scheme"
git push
```

### Deploying to a New Machine

```bash
# On new machine:
cd ~
git clone https://github.com/smitpatil06/.dotfiles.git dotfiles
cd dotfiles
stow */

# Done! All configurations are now active
```

---

## 🎨 Component Details

### DWM (Dynamic Window Manager)

**DWM** is a minimalist tiling window manager from [suckless.org](https://suckless.org/). It's configured by editing `config.h` and recompiling.

**Key Features**:
- Extremely lightweight (< 100KB binary)
- Keyboard-driven workflow
- Configured in C source code
- Patches applied for enhanced functionality

**Note**: DWM configuration is typically maintained separately and not included in this dotfiles repository.

### Alacritty

**Alacritty** is a GPU-accelerated terminal emulator focused on performance and simplicity.

**Themes Available**:
- Catppuccin Mocha (default) - A soothing pastel color scheme
- Gruvbox Material Hard Dark
- Gruvbox Material Medium Dark
- Gruvbox Dark

**Configuration Location**: `~/dotfiles/alacritty/.config/alacritty/`
- `alacritty.toml` - Main configuration file (TOML format)
- `catppuccin-mocha.toml` - Catppuccin Mocha theme
- `gruvbox_*.toml` - Various Gruvbox theme variants

**Features Configured**:
- Theme imports (easily switch themes by changing the import line)
- JetBrainsMono Nerd Font with custom sizing
- Window opacity (0.8) with blur enabled
- Custom padding and decorations
- 256-color terminal support

### Picom

**Picom** is a lightweight compositor for X11, providing transparency, shadows, and smooth animations.

**Backend**: GLX (OpenGL) - Chosen for NVIDIA GPU stability  
**Configuration Location**: `~/dotfiles/picom/.config/picom/picom.conf`

**Key Settings**:
- GLX backend for NVIDIA compatibility
- VSync enabled for tear-free rendering
- Dual Kawase blur method with strength 5
- Optimized shadow settings
- Window transparency rules
- Fading disabled for better performance

### GTK-3.0

**GTK-3.0** theme configuration for consistent appearance across GTK applications.

**Configuration Location**: `~/dotfiles/gtk-3.0/.config/gtk-3.0/settings.ini`

**Key Settings**:
- Theme: Adwaita (dark mode enabled)
- Icon Theme: Qogir
- Cursor Theme: Qogir
- Font: Sans 11
- Anti-aliasing and hinting enabled

### X11 Session (.xinitrc)

**X11 session startup** configuration with intelligent display management.

**Configuration Location**: `~/dotfiles/x11/.xinitrc`

**Key Features**:
- Qt theme configuration (qt5ct/qt6ct)
- High DPI support
- Dual-monitor setup with NVIDIA Optimus support
- Automatic detection of external monitor (HDMI-1-0)
- Different Picom configurations for laptop vs external display
- NVIDIA-specific VSync handling with ForceCompositionPipeline
- Background services: dunst, slstatus, feh wallpaper rotation
- DWM window manager startup

---

## 🎨 Customization

### Modifying the Color Scheme

Alacritty comes with multiple theme options. To switch themes:

**Option 1: Switch to a different pre-configured theme**
1. Edit `~/dotfiles/alacritty/.config/alacritty/alacritty.toml`
2. Change the import line to use a different theme:
   ```toml
   import = [
       "~/.config/alacritty/gruvbox_material_hard_dark.toml"  # or any other theme file
   ]
   ```
3. Save and reopen Alacritty (changes apply immediately via symlink)

**Option 2: Customize an existing theme**
1. Edit the theme file directly, e.g., `~/dotfiles/alacritty/.config/alacritty/catppuccin-mocha.toml`
2. Modify color values as desired
3. Save and the changes apply immediately

**Option 3: Add a new theme**
1. Create a new `.toml` file in `~/dotfiles/alacritty/.config/alacritty/`
2. Define your color scheme following the TOML format
3. Update the import in `alacritty.toml` to use your new theme
4. Commit your new theme file

### Adding DWM Patches

To add functionality to DWM (if you're using it):

1. Download desired patch from [suckless.org](https://dwm.suckless.org/patches/)
2. Apply patch to DWM source: `patch -p1 < patch-file.diff`
3. Update `config.h` if needed
4. Recompile: `sudo make clean install`

### Adjusting Picom Settings

For different visual effects or performance tuning:

1. Edit `~/dotfiles/picom/.config/picom/picom.conf`
2. Adjust shadow, fade, blur, or transparency settings
3. Restart Picom: `pkill picom && picom -b`

### Customizing GTK Theme

To change the GTK theme or icons:

1. Edit `~/dotfiles/gtk-3.0/.config/gtk-3.0/settings.ini`
2. Modify `gtk-theme-name`, `gtk-icon-theme-name`, or other settings
3. Changes apply to new GTK applications immediately

### Modifying X11 Session Startup

To customize your X session startup:

1. Edit `~/dotfiles/x11/.xinitrc`
2. Add or modify:
   - Monitor configurations
   - Startup applications
   - Environment variables
   - Display settings
3. Changes take effect on next X session login

---

## 🐛 Troubleshooting

### Stow Conflicts

**Problem**: `stow: WARNING! stowing X would cause conflicts`

**Solution**: 
```bash
# Remove or backup the conflicting file
mv ~/.config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml.backup

# Then retry stow
stow alacritty
```

### Picom Not Starting

**Problem**: Picom fails to start or crashes

**Solution**:
```bash
# Check for errors
picom --config ~/.config/picom/picom.conf

# For NVIDIA users, ensure GLX backend is set in config
# backend = "glx";

# Kill existing instance and restart
pkill picom
picom -b --config ~/.config/picom/picom.conf
```

### DWM Compilation Errors

**Problem**: DWM fails to compile

**Solution**:
```bash
# Ensure you have build dependencies
sudo pacman -S base-devel libx11 libxft libxinerama

# Check for patch conflicts
# May need to manually resolve conflicts in config.h or source files
```

### Symlinks Not Working

**Problem**: Changes in dotfiles not reflecting in system

**Solution**:
```bash
# Verify symlinks exist
ls -la ~/.config/alacritty/

# Re-stow if needed
cd ~/dotfiles
stow -R alacritty  # -R restows (removes and re-adds)
```

---

## 🤝 Contributing

While this is a personal dotfiles repository, suggestions and improvements are welcome!

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/improvement`
3. Commit your changes: `git commit -m 'Add improvement'`
4. Push to the branch: `git push origin feature/improvement`
5. Open a Pull Request

---

## 📄 License

This repository is available under the MIT License. Feel free to use, modify, and distribute these configurations as you see fit.

---

## 🙏 Credits

- **EndeavourOS Team** - For the excellent Arch-based distribution
- **Suckless Community** - For DWM and the philosophy of simplicity
- **Alacritty Contributors** - For the blazing-fast terminal emulator
- **Catppuccin Team** - For the beautiful Mocha color theme
- **Picom Developers** - For the reliable compositor
- **GNU Stow** - For elegant dotfile management

---

<div align="center">

**[⬆ Back to Top](#--endeavouros--dwm-dotfiles)**

Made with ❤️ for the Linux community

</div>