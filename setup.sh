yay -S brave-bin --no-confirm
xdg-settings set default-web-browser brave-browser.desktop

sudo pacman -Sy keepassxc
# Then instlal https://addons.mozilla.org/en-US/firefox/addon/keepassxc-browser/
yay -S localsend-bin --no-confirm

yay -S visual-studio-code-bin --noconfirm
yay -S nautilus-open-any-terminal --noconfirm



# Fix screen record on carbon X1
yay -S intel-media-driver


ln -s $(pwd)/config/hypr ~/.config/hypr
ln -s $(pwd)/applications ~/.local/share/applications
ln -s $(pwd)/bin/ ~/.local/bin
ln -s $(pwd)/config/waybar ~/.config/waybar
ln -s $(pwd)/config/mako ~/.config/mako
ln -s $(pwd)/config/elephant ~/.config/elephant
ln -s $(pwd)/config/ghostty ~/.config/ghostty
ln -s $(pwd)/config/yazi ~/.config/yazi
ln -s $(pwd)/config/hypr/apps/jetbrains.conf  ~/.local/share/omarchy/default/hypr/apps/jetbrains.conf
ln -s $PWD/nicolas ~/.config/omarchy/themes/nicolas

sudo ln -s $PWD/system/* /etc/systemd/system/
sudo systemctl daemon-reload

# SMB setup
sudo pacman -Syu cifs-utils
# Put credentials in /etc/samba/credentials with the following format
# username=user
# password=pass

sudo pacman -S vulkan-intel
sudo pacman -Syu vlc
sudo pacman -Syu aspnet-runtime dotnet-runtime dotnet-sdk

rm ~/.bashrc && ln -s "$(pwd)/.bashrc" ~/.bashrc


xdg-mime default vlc.desktop video/mp4
xdg-mime default vlc.desktop video/x-msvideo
xdg-mime default vlc.desktop video/x-matroska
xdg-mime default vlc.desktop video/x-flv
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

