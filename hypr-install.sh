#!/bin/bash

set -e

echo "=== UPDATE SYSTEM ==="

sudo pacman -Syu --noconfirm

echo "=== INSTALL PACKAGES ==="

sudo pacman -S --needed --noconfirm \
hyprland \
waybar \
kitty \
walker \
mako \
hyprlock \
hyprpaper \
xdg-desktop-portal-hyprland \
pipewire \
wireplumber \
pipewire-pulse \
pavucontrol \
networkmanager \
network-manager-applet \
thunar \
thunar-volman \
gvfs \
brightnessctl \
playerctl \
grim \
slurp \
wl-clipboard \
cliphist \
polkit-kde-agent \
ttf-jetbrains-mono-nerd \
noto-fonts \
noto-fonts-emoji \
ttf-dejavu \
firefox \
foot \
mpv \
imv \
file-roller \
unzip \
zip \
7zip \
fastfetch \
btop \
neovim \
tlp \
bluez \
bluez-utils \
blueman \
sddm

echo "=== ENABLE SERVICES ==="

sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo systemctl enable tlp
sudo systemctl enable sddm

systemctl --user enable wireplumber

echo "=== CREATE CONFIG DIRS ==="

mkdir -p /home/mrb/.config/hypr
mkdir -p /home/mrb/.config/waybar

echo "=== HYPRLAND CONFIG ==="

cat > /home/mrb/.config/hypr/hyprland.conf << 'EOF'
monitor=,preferred,auto,1

exec-once = waybar
exec-once = mako
exec-once = nm-applet --indicator
exec-once = hyprpaper
exec-once = wl-paste --type text --watch cliphist store
exec-once = blueman-applet
exec-once = /usr/lib/polkit-kde-authentication-agent-1

input {
    kb_layout = ro

    touchpad {
        natural_scroll = true
        tap-to-click = true
    }

    sensitivity = 0
}

general {
    gaps_in = 5
    gaps_out = 12
    border_size = 2

    col.active_border = rgba(89b4faff)
    col.inactive_border = rgba(444444aa)

    layout = dwindle
}

decoration {
    rounding = 10

    blur {
        enabled = true
        size = 5
        passes = 2
    }
}

animations {
    enabled = true

    bezier = myBezier,0.05,0.9,0.1,1.05

    animation = windows,1,7,myBezier
    animation = border,1,10,default
    animation = fade,1,7,default
    animation = workspaces,1,6,default
}

$mod = SUPER

bind = $mod, RETURN, exec, kitty
bind = $mod, Q, killactive
bind = $mod, E, exec, thunar
bind = $mod, D, exec, walker
bind = $mod, F, fullscreen
bind = $mod SHIFT, L, exec, hyprlock

bind = $mod, left, movefocus, l
bind = $mod, right, movefocus, r
bind = $mod, up, movefocus, u
bind = $mod, down, movefocus, d

bind = $mod, 1, workspace, 1
bind = $mod, 2, workspace, 2
bind = $mod, 3, workspace, 3
bind = $mod, 4, workspace, 4
bind = $mod, 5, workspace, 5

bind = $mod SHIFT, 1, movetoworkspace, 1
bind = $mod SHIFT, 2, movetoworkspace, 2
bind = $mod SHIFT, 3, movetoworkspace, 3

bind = , Print, exec, grim -g "$(slurp)" - | wl-copy

misc {
    force_default_wallpaper = 0
}
EOF

echo "=== HYPRPAPER CONFIG ==="

cat > /home/mrb/.config/hypr/hyprpaper.conf << 'EOF'
preload = /home/mrb/wallpaper.jpg

wallpaper = ,/home/mrb/wallpaper.jpg
EOF

echo "=== WAYBAR CONFIG ==="

cat > /home/mrb/.config/waybar/config << 'EOF'
{
  "layer": "top",
  "position": "top",

  "modules-left": [
    "hyprland/workspaces"
  ],

  "modules-center": [
    "clock"
  ],

  "modules-right": [
    "pulseaudio",
    "network",
    "cpu",
    "memory",
    "battery"
  ]
}
EOF

echo "=== WAYBAR STYLE ==="

cat > /home/mrb/.config/waybar/style.css << 'EOF'
* {
    font-family: "JetBrainsMono Nerd Font";
    font-size: 13px;
}

window#waybar {
    background: rgba(20,20,20,0.85);
    color: white;
}

#workspaces button.active {
    background: #89b4fa;
    color: black;
}

#clock,
#battery,
#cpu,
#memory,
#network,
#pulseaudio {
    padding: 0 10px;
}
EOF

echo "=== FIX OWNERSHIP ==="

sudo chown -R mrb:mrb /home/mrb/.config

echo "=== DONE ==="
echo
echo "Pune un wallpaper la:"
echo "/home/mrb/wallpaper.jpg"
echo
echo "Reboot și alege Hyprland din SDDM."
