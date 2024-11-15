echo "Reinstalling packages..."

# Reinstall packages
sudo pacman -Syu --needed - < pkglist.txt  # Update & reinstall packages listed by pacman