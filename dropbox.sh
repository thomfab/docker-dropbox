#!/bin/bash

umask 002

USER=${USER:-dropbox}
USERID=${USERID:-1000}
PASSWORD=${PASSWORD:-password}
GROUP=${GROUP:-users}
GROUPID=${GROUPID:-100}

getent group ${GROUP}
if [ $? -ne 0 ]; then
  groupadd -g ${GROUPID} ${GROUP}
fi

getent passwd ${USER}
if [ $? -ne 0 ]; then
  useradd -d /dropbox --gid=${GROUP} --groups=users --uid=${USERID} ${USER}
  echo "$USER:$PASSWORD" | chpasswd
fi
usermod -d /dropbox -m ${USER}

echo fs.inotify.max_user_watches=100000 | sudo tee -a /etc/sysctl.conf; sudo sysctl -p

chown ${USER}:${GROUP} /dropbox/.dropbox
chmod ug+rwX /dropbox/.dropbox
chown ${USER}:${GROUP} /dropbox/Dropbox
chmod ug+rwX /dropbox/Dropbox

cd /dropbox/.dropbox-dist
DROPBOXDIR="/dropbox/.dropbox-dist/`ls -d dropbox-lnx*`"

exec /sbin/setuser ${USER} $DROPBOXDIR/dropbox
