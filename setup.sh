#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

setup_tools() {
  sudo pacman -Sy keepassxc
  # Then instlal https://addons.mozilla.org/en-US/firefox/addon/keepassxc-browser/
  yay -S localsend-bin --no-confirm
  yay -S visual-studio-code-bin --noconfirm
  # Fix screen record on carbon X1
  yay -S intel-media-driver

  # SMB setup
  sudo pacman -Syu cifs-utils
  # Put credentials in /etc/samba/credentials with the following format
  # username=user
  # password=pass
  
  yay -S brave-bin --no-confirm
  xdg-settings set default-web-browser brave-browser.desktop

  sudo pacman -S vulkan-intel
  sudo pacman -Syu vlc
  sudo pacman -Syu aspnet-runtime dotnet-runtime dotnet-sdk
}

link() {
  local src="$1" dst="$2"
  rm -rf "$dst"
  mkdir -p "$(dirname "$dst")"
  ln -sfnT "$src" "$dst"
}

install_config() {
  link $script_dir/config/hypr ~/.config/hypr
  link $script_dir/applications ~/.local/share/applications
  link $script_dir/bin/ ~/.local/bin
  link $script_dir/config/waybar ~/.config/waybar
  link $script_dir/config/mako ~/.config/mako
  link $script_dir/config/elephant ~/.config/elephant
  link $script_dir/config/ghostty ~/.config/ghostty
  link $script_dir/config/yazi ~/.config/yazi
  link $script_dir/config/brave-flags.conf ~/.config/brave-flags.conf
  link $script_dir/config/hypr/apps/jetbrains.conf  ~/.local/share/omarchy/default/hypr/apps/jetbrains.conf
  link $script_dir/nicolas ~/.config/omarchy/themes/nicolas

  link $script_dir/nautilus/scripts ~/.local/share/nautilus/scripts
  nautilus -q

  sudo install -m 0644 system/* /etc/systemd/system/
  sudo install -m 0644 system/user/* ~/.config/systemd/user/
  sudo systemctl daemon-reload

  sudo systemctl enable --user --now hide-waybar-jetbrains.service

  link "$script_dir/.bashrc" ~/.bashrc

  sudo cp $script_dir/hosts /etc/hosts && sudo chown root /etc/hosts
}

setup_mime() {
    xdg-mime default vlc.desktop video/mp4
    xdg-mime default vlc.desktop video/x-msvideo
    xdg-mime default vlc.desktop video/x-matroska
    xdg-mime default vlc.desktop video/x-flvv
    xdg-mime default vlc.desktop video/x-ms-wmv
    xdg-mime default vlc.desktop video/mpeg
    xdg-mime default vlc.desktop video/ogg
    xdg-mime default vlc.desktop video/webm
    xdg-mime default vlc.desktop video/quicktime
    xdg-mime default vlc.desktop video/3gpp
    xdg-mime default vlc.desktop video/3gpp2
    xdg-mime default vlc.desktop video/x-ms-asf
    xdg-mime default vlc.desktop video/x-ogm+ogg
    xdg-mime default vlc.desktop video/x-theora+ogg
    xdg-mime default vlc.desktop application/ogg
}

# check to see if this file is being run or sourced from another script
_is_sourced() {
	# https://unix.stackexchange.com/a/215279
	[ "${#FUNCNAME[@]}" -ge 2 ] \
		&& [ "${FUNCNAME[0]}" = '_is_sourced' ] \
		&& [ "${FUNCNAME[1]}" = 'source' ]
}

_main() {
  setup_tools
  install_config
  setup_mime
}

if ! _is_sourced; then
	_main "$@"
fi
