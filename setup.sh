#!/usr/bin/env bash
set -euo pipefail

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
  link $(pwd)/config/hypr ~/.config/hypr
  link $(pwd)/applications ~/.local/share/applications
  link $(pwd)/bin/ ~/.local/bin
  link $(pwd)/config/waybar ~/.config/waybar
  link $(pwd)/config/mako ~/.config/mako
  link $(pwd)/config/elephant ~/.config/elephant
  link $(pwd)/config/ghostty ~/.config/ghostty
  link $(pwd)/config/yazi ~/.config/yazi
  link $(pwd)/config/hypr/apps/jetbrains.conf  ~/.local/share/omarchy/default/hypr/apps/jetbrains.conf
  link $PWD/nicolas ~/.config/omarchy/themes/nicolas
  rm -rf ~/.local/share/nautilus/scripts

  link $PWD/nautilus/scripts ~/.local/share/nautilus/scripts
  nautilus -q

  sudo install -m 0644 system/* /etc/systemd/system/
  sudo systemctl daemon-reload
  rm ~/.bashrc && link "$(pwd)/.bashrc" ~/.bashrc
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
