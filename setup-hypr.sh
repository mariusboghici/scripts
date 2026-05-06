
#!/bin/bash

# -------------------------
# UPDATE SISTEM
# -------------------------
sudo pacman -Syu --noconfirm

# -------------------------
# PACHETE DE BAZĂ PENTRU HYPRLAND
# -------------------------
sudo pacman -S --noconfirm \
    hyprland \
    xdg-desktop-portal-hyprland \
    kitty \
    wofi \
    waybar \
    thunar \
    mako \
    pipewire pipewire-alsa pipewire-pulse wireplumber \
    networkmanager network-manager-applet \
    bluez bluez-utils \
    polkit-gnome \
    wl-clipboard grim slurp brightnessctl \
    xdg-user-dirs

# -------------------------
# ACTIVEAZĂ SERVICII
# -------------------------
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth

# -------------------------
# DIRECTOARE USER
# -------------------------
xdg-user-dirs-update

# -------------------------
# INSTALARE YAY (AUR)
# -------------------------
cd ~
if [ ! -d "yay" ]; then
    git clone https://aur.archlinux.org/yay.git
fi
cd yay
makepkg -si --noconfirm

# -------------------------
# WALLPAPER DAEMON (swww)
# -------------------------
yay -S --noconfirm swww

# -------------------------
# CONFIG HYPRLAND
# -------------------------
mkdir -p ~/.config/hypr

cat << 'EOF' > ~/.config/hypr/hyprland.conf
monitor=,preferred,auto,1

exec-once = sleep 1 && waybar
exec-once = sleep 1 && swww init
exec-once = nm-applet
exec-once = mako

$mod = SUPER

bind = $mod, RETURN, exec, kitty
bind = $mod, Q, killactive
bind = $mod, D, exec, wofi --show drun
bind = $mod, E, exec, thunar
bind = $mod, F, togglefloating

input {
    kb_layout = us
}
EOF

# -------------------------
# CONFIG WAYBAR
# -------------------------
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

echo "Setup complet. Repornește sesiunea și pornește Hyprland."
