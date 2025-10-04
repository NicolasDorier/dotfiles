yay -S brave-bin --no-confirm
xdg-settings set default-web-browser brave-browser.desktop

sudo pacman -Sy keepassxc
# Then instlal https://addons.mozilla.org/en-US/firefox/addon/keepassxc-browser/
yay -S localsend-bin --no-confirm

yay -S visual-studio-code-bin --no-confirm
yay -S nautilus-open-any-terminal --no-confirm



# Fix screen record on carbon X1
yay -S intel-media-driver


ln -s config/hypr ~/.config/hypr
ln -s applications ~/.local/share/applications