#!/bin/bash

sudo pacman -Syu --noconfirm

sudo pacman -S --noconfirm \
    hyprland waybar kitty thunar mako wofi \
    pipewire pipewire-alsa pipewire-pulse wireplumber \
    network-manager-applet bluez bluez-utils \
    polkit-gnome brightnessctl grim slurp wl-clipboard \
    xdg-desktop-portal-hyprland xdg-user-dirs \
    papirus-icon-theme graphite-gtk-theme \
    fish git base-devel

sudo systemctl enable --now bluetooth

chsh -s /usr/bin/fish

xdg-user-dirs-update

cd ~
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm

yay -S awww --noconfirm

mkdir -p ~/.config/hypr
cat << 'EOF' > ~/.config/hypr/hyprland.conf
monitor=,preferred,auto,1

exec-once = waybar
exec-once = awww init
exec-once = nm-applet
exec-once = mako

$mod = SUPER

bind = $mod, RETURN, exec, kitty
bind = $mod, Q, killactive
bind = $mod, D, exec, wofi --show drun
bind = $mod, F, togglefloating
bind = $mod, E, exec, thunar
bind = $mod, L, exec, hyprlock

input {
    kb_layout = ro
    kb_variant = winkeys
}
EOF

mkdir -p ~/.config/waybar
cat << 'EOF' > ~/.config/waybar/config
{
  "layer": "top",
  "position": "top",
  "modules-left": ["hyprland/workspaces"],
  "modules-center": ["clock"],
  "modules-right": ["network", "bluetooth", "battery"]
}
EOF

cat << 'EOF' > ~/.config/waybar/style.css
* {
  font-family: JetBrainsMono, sans-serif;
  font-size: 12px;
  color: #cdd6f4;
}
EOF

gsettings set org.gnome.desktop.interface gtk-theme "Graphite-Blue-Dark"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

echo "Setup complet. Repornește sesiunea."
