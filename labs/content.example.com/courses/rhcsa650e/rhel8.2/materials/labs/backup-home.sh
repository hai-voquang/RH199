#!/usr/bin/env bash

# Script to backup the home directory
# Uses rsync, sshpass, sendmail, and mailx (for error logging)

DESTHOST='servera.lab.example.com'
DESTUSER='student'
DESTDIR='/home/student/serverb-backup'
SRC='/home/student'
DEST="${DESTUSER}@${DESTHOST}:${DESTDIR}"
RSYNC_OPTS='-haAXuv --delete'
EXCLUDE='*/.cache/* */.thumbnails/* lost+found backup.log backup-home.sh'
EXCLUDE="$(echo $EXCLUDE | sed 's/\(\S\+\)/ --exclude \1/g')"
LOGFILE='/home/student/backup.log'
TMPFILE='/tmp/backup_out'
ERRFILE='/tmp/backup_err'
ERRFLAG='ERROR'
EMAIL='student@serverb.lab.example.com' 

# clear out tmp files
[ -a ${TMPFILE} ] && rm -rf ${TMPFILE}
[ -a ${ERRFILE} ] && rm -rf ${ERRFILE}
touch ${TMPFILE}
touch ${ERRFILE}

# log handling for this script
function log {
    if [ $# -gt 0 ];
    then
        LOG="$@"
    else
        LOG="$(cat ${TMPFILE})"
    fi
    echo -e "${LOG}" >> ${LOGFILE}
}

# error handling for this script
function error_out {
    if [ $# -gt 0 ];
    then
        ERRMSG="$@"
    else
        ERRMSG="$(cat ${ERRFILE})"
    fi
    ERRMSG="There was an error backing up files on servera on $(date):\n${ERRMSG}"
    echo -e "${ERRMSG}" | mail -s "Backup Error" ${EMAIL}
    log "${ERRMSG}"
    echo "${ERRFLAG}" >> ${LOGFILE}
    exit 1
}

# check if destination is available
ping -c 1 -w 2 ${DESTHOST} &> /dev/null || error_out "Backup destination not reachable" 

# backup everything in /home with a few exceptions
sshpass -p 'student' rsync ${RSYNC_OPTS} -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" ${EXCLUDE} ${SRC} ${DEST} > ${TMPFILE} 2> ${ERRFILE} || error_out

# send an email if last time there was an error
if [ "${ERRFLAG}" == "$(tail -n 1 ${LOGFILE})" ];
then
    echo "Backup successfully restarted on $(date)" | mail -s "Backup Success" ${EMAIL}
fi

# log success
log "$(tail -n 2 ${TMPFILE})" # this is the summary from the end of rsync verbose output
log "Home directories backed up successfully on $(date)"
