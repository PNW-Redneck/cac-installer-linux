if command -v yay &> /dev/null; then
    echo "yay is installed"
    AUR_HELPER="yay"
elif command -v paru &> /dev/null; then
    echo "paru is installed"
    AUR_HELPER="paru"
else
    echo "Neither yay nor paru is installed"
    read -p "Do you want to install yay or paru? (y/p): " choice
    case "$choice" in 
        (y|YAY)
            echo "Installing yay..."
            git clone https://aur.archlinux.org/yay.git
            cd yay
            makepkg -si
            cd ..
            rm -rf yay
            echo "yay installed"   
            AUR_HELPER="yay"
            
        (p|PARU)
            echo "Installing paru..."
            git clone https://aur.archlinux.org/paru.git
            cd paru
            makepkg -si
            cd ..
            rm -rf paru
            echo "paru installed"
            AUR_HELPER="paru"
            
    esac
fi

clear
echo "Installing required packages for CAC usage on Arch"
$AUR_HELPER -S ccid opensc pcsc-tools pcsc-perl lib32-pcsclite coolkey --noconfirm
clear
echo "Require packages installed, now configuring pcscd"
sudo systemctl enable pcscd.service --now
clear
echo "Adding CAC Module for use with Chrome and its derivatives, please close any open browsers"
modutil -dbdir sql:.pki/nssdb/ -add "CAC Module" -libfile /usr/lib/pkcs11/libcoolkeypk11.so