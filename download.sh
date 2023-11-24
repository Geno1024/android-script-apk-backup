#/bin/bash

function runsucmd() {
    ssh root@$ip -p 8022 'su -c '"$1"
}

function recv_pkg() {
    mkdir $1
    cd $1
    rpkgloc=$(runsucmd 'pm path '$1' | awk -F'":"' '"'"'{print $2}'"'")
    runsucmd 'tar -cf /proc/self/fd/1 -C '$(dirname $rpkgloc)' 'base.apk > $1.apk.tar
    tar xf $1.apk.tar
    su -c "pm install base.apk"
    runsucmd 'LD_LIBRARY_PATH=/data/data/com.termux/files/usr/lib /data/data/com.termux/files/usr/bin/tar -cf /proc/self/fd/1 -C /data/data '$1 > $1.data.tar
    tar xf $1.data.tar
    perm=$(su -c "stat -c '%U:%G' /data/data/$1")
    su -c "cp -r $1/* /data/data/$1"
    su -c "chown -R $perm /data/data/$1"
    cd ..
}

ip="$1"
recv_pkg "$2"
