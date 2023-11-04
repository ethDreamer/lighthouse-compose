#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LOOPBACK=$SCRIPT_DIR/encfs
VOLUME=secrets
FILESYSTEM=ext2
DATADIR=$SCRIPT_DIR/lighthouse/validator/run/datadir
MNTPOINT=$DATADIR/secrets

[ "$UID" -eq 0 ] || {
    echo "Not running as root; escalating privileges.";
    exec sudo "$0" "$@";
}

create() {
    until which mkfs.$FILESYSTEM &>/dev/null ; do
        echo "Command mkfs.${FILESYSTEM} not found."
        read -p "Enter filesystem for loopback file: " FILESYSTEM
    done

    while true; do
        read -p "Enter size of filesystem in MB [32]: " FSIZE
        FSIZE="${FSIZE:=32}"
        if [[ $((FSIZE)) != $FSIZE ]]; then
            echo "Value '${FSIZE}' is not a number"
            continue;
        fi
        if (( $FSIZE < 32 )); then
            echo "Filesystem must be minimum of 32 MB";
            continue;
        else
            break;
        fi
    done

    LOCALMOUNT=/tmp/.localmount
    LOOPDEVICE=$(losetup -f)
      {
        mkdir $LOCALMOUNT && \
        dd if=/dev/random of=$LOOPBACK bs=1M count=$FSIZE && \
        losetup $LOOPDEVICE $LOOPBACK && \
        cryptsetup luksFormat -y $LOOPDEVICE && \
        cryptsetup luksOpen $LOOPDEVICE $VOLUME && \
        mkfs.$FILESYSTEM /dev/mapper/$VOLUME && \
        mount /dev/mapper/$VOLUME $LOCALMOUNT && \
        touch $LOCALMOUNT/.mounted && \
        umount /dev/mapper/$VOLUME && \
        cryptsetup luksClose /dev/mapper/$VOLUME && \
        losetup -d $LOOPDEVICE && \
        echo "Filesystem created. Run script again to mount." && \
        rmdir $LOCALMOUNT
    } || {
        RC=$?
        umount /dev/mapper/$VOLUME &>/dev/null
        cryptsetup luksClose /dev/mapper/$VOLUME &>/dev/null;
        losetup -d $LOOPDEVICE &>/dev/null;
        rm -f $LOOPBACK;
        rm -rf $LOCALMOUNT;
        exit $RC;
    }
}

if [ ! -e $LOOPBACK ]; then
    echo "Loopback file '${LOOPBACK}' does not exist."
    while true; do
        read -p "Do you wish to create a new loopback file? " yn
        case $yn in
            [Yy]* ) create; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    exit 0
fi

{
    # unmount volume if mounted
    cryptsetup status $VOLUME > /dev/null && \
        {
            grep -qs "/dev/mapper/${VOLUME}" /proc/mounts && \
                umount /dev/mapper/${VOLUME};
            /bin/true;
        } && \
            cryptsetup luksClose /dev/mapper/${VOLUME} && \
            echo "Successfully unmounted ${VOLUME}";
} || {
    # mount volume
    if [ ! -d $MNTPOINT ]; then
        mkdir -p $MNTPOINT
    fi

    if [ -z ${VALIDATOR_UID} ]; then
        echo "Must run \`source ./globals.sh\` before mounting"
        exit 1
    fi

    cryptsetup luksOpen $LOOPBACK ${VOLUME} && \
        mount /dev/mapper/${VOLUME} $MNTPOINT && \
        mount --make-shared $MNTPOINT && {
            chown -R ${VALIDATOR_UID}:${VALIDATOR_GID} $DATADIR 2>/dev/null;
            chown -R ${VALIDATOR_UID}:${VALIDATOR_GID} $MNTPOINT 2>/dev/null;
        } && \
        echo "Successfully mounted ${VOLUME}";
}


