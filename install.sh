clear
cd
rm -rf *
mkdir myapp
echo "Downloading Ubuntu...."
wget http://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/ubuntu-base-20.04.4-base-amd64.tar.gz -O ubuntu.tar.gz
echo "Extracting Ubuntu"
mkdir ubuntu
tar -xf ubuntu.tar.gz -C ubuntu &> /dev/null
rm ubuntu.tar.gz
echo "Downloading Proot"
wget -O proot "https://downloads.sourceforge.net/project/proot.mirror/v5.3.0/proot-v5.3.0-x86_64-static?ts=gAAAAABo2hXN2r2g99TJNV9gPdRhsBvKOupjqoVyyL5FD9-YabatbTwIAbd-yCFeLO5AfqWkb3PeBgQ1mhHw2e94gppk0IZ2FQ%3D%3D&use_mirror=master&r="
chmod +x proot
echo "cd && ./proot -0 -r ubuntu -b /sys -b /proc -b /dev -w /root  /usr/bin/env -i HOME=/root  PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin TERM=$TERM LANG=C.UTF-8 /bin/bash" >> start
chmod +x start
cat >> "ubuntu/etc/resolv.conf" << EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
cd ubuntu/root
rm -rf .bashrc
cat >> ".bashrc" << EOF
apt update 
echo "Downloading Qemu"
apt install qemu-system-x86 qemu-utils wget -y
wget https://github.com/playit-cloud/playit-agent/releases/download/v0.16.2/playit-linux-amd64 -O /usr/bin/playit
chmod +x /usr/bin/playit
cd /opt
mkdir windows
cd windows
wget -O Tiny10.iso https://archive.org/download/lite-edition-ltsb-2015-x86/Windows%2010%20Enterprise%20LTSB%202015%20-%20Lite%20%28x86%29.iso
qemu-img create -f raw windows.img 13G
qemu-system-x86_64 -m 16G   -smp 4               -cpu max  -accel tcg,thread=multi -cdrom Tiny10.iso -hda windows.img -device e1000,netdev=net0 -netdev user,id=net0  -vnc :1
cd
rm -rf .bashrc
exit
EOF
cd 
./start
cd ubuntu/root
cat >> ".bashrc" << EOF
echo "Windows is Booting"
cd /opt/windows
rm -rf Tiny10.iso
pkill qemu
qemu-system-x86_64 -m 16G   -smp 4               -cpu max  -accel tcg,thread=multi -hda windows.img -device e1000,netdev=net0 -netdev user,id=net0  -vnc :1  &
playit

EOF
