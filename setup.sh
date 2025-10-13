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

sudo pacman -Syu cifs-utils
sudo pacman -S vulkan-intel
sudo pacman -Syu vlc
sudo pacman -Syu aspnet-runtime dotnet-runtime dotnet-sdk

