#!/bin/bash

# prepare ssh server
mkdir -p /var/run/sshd
sed -i '/PermitRootLogin/c PermitRootLogin yes' /etc/ssh/sshd_config
if [ ! $SSHPW ]; then  
    SSHPW=`pwgen -c -n -1 12`
fi
echo "root:$SSHPW" | chpasswd
echo "ssh login password: $SSHPW"

if [ -n "$RESOLUTION" ]; then
    sed -i "s/1024x768/$RESOLUTION/" /root/supervisord.conf
fi

# start up supervisord, all daemons should launched by supervisord.
/usr/bin/supervisord -c /root/supervisord.conf

# copy terminal to depsktop
mkdir -p /root/Desktop/
cp -f /usr/share/applications/xfce4-terminal.desktop /root/Desktop/xfce4-terminal.desktop
chmod +x /root/Desktop/xfce4-terminal.desktop
echo 2 | update-alternatives --config x-terminal-emulator >> /dev/null 2>&1

# start a shell
/bin/zsh
