#!/bin/sh
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DATADIR=$SCRIPT_DIR/lighthouse/validator/run/datadir
SECRETS=$DATADIR/secrets

function write_pass {
    if [ ! -f $SECRETS/validator_pass ]; then
        echo -n "Enter validator password: "
        read -s password

        $(umask 077 ; echo -n $password >> $SECRETS/validator_pass)
    fi
}

PROCESS_UID=$(cat $SCRIPT_DIR/validator.yml | grep "PROCESS_UID" | awk '{ print $2 }')
PROCESS_GID=$(cat $SCRIPT_DIR/validator.yml | grep "PROCESS_GID" | awk '{ print $2 }')

if [ ! -d $DATADIR ]; then
    mkdir -p $SECRETS
    write_pass
    chown -R ${PROCESS_UID}:${PROCESS_GID} $DATADIR
else
    if [ ! -d $SECRETS ]; then
        mkdir -p $SECRETS
        write_pass
        chown -R ${PROCESS_UID}:${PROCESS_GID} $SECRETS
    else
        write_pass
        chown ${PROCESS_UID}:${PROCESS_GID} $SECRETS/validator_pass
    fi
fi




