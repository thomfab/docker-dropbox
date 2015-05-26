#!/bin/bash

umask 002

DROPBOX_USER=${DROPBOX_USER:-dropbox}
DROPBOX_USERID=${DROPBOX_USERID:-1000}
DROPBOX_PASSWORD=${DROPBOX_PASSWORD:-password}
DROPBOX_GROUP=${DROPBOX_GROUP:-users}
DROPBOX_GROUPID=${DROPBOX_GROUPID:-100}

getent group ${DROPBOX_GROUP}
if [ $? -ne 0 ]; then
  groupadd -g ${DROPBOX_GROUPID} ${DROPBOX_GROUP}
fi

getent passwd ${DROPBOX_USER}
if [ $? -ne 0 ]; then
  useradd -d /dropbox --gid=${DROPBOX_GROUP} --groups=users --uid=${DROPBOX_USERID} ${DROPBOX_USER}
  echo "$DROPBOX_USER:$DROPBOX_PASSWORD" | chpasswd
fi
usermod -d /dropbox -m ${DROPBOX_USER}

echo fs.inotify.max_user_watches=100000 | sudo tee -a /etc/sysctl.conf; sudo sysctl -p

chown ${DROPBOX_USER}:${DROPBOX_GROUP} /dropbox/.dropbox
chmod ug+rwX /dropbox/.dropbox
chown ${DROPBOX_USER}:${DROPBOX_GROUP} /dropbox/Dropbox
chmod ug+rwX /dropbox/Dropbox

cd /dropbox/.dropbox-dist
DROPBOXDIR="/dropbox/.dropbox-dist/`ls -d dropbox-lnx*`"

exec /sbin/setuser ${DROPBOX_USER} ${DROPBOXDIR}/dropbox
