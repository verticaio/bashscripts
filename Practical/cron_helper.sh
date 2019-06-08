#!/bin/bash
 
usage() {
  cat << EOF
Usage: $0 [OPTION]... COMMAND
Execute the given command in a way that works safely with cron. This should
typically be used inside of a cron job definition like so:
* * * * * $(which "$0") [OPTION]... COMMAND
 
Arguments:
  -c           Ensure that the job never exits non zero.
  -e EXITFILE  The exit file that will have a time stamp written to it if the
               job succeeds.
  -h           This help message.
  -i           Nice the job so that it doesn't over consume resources.
  -k LOCKFILE  The lock file to hold while the job is running.
  -l LOGFILE   The log file to write stdout and stderr too.
  -n NAME      The name of this cron job. Giving the cron job a name causes
               log lines to include it in the output, and automatically sets
               EXITFILE, LOCKFILE, and LOGFILE to some simple default values.
                
               EXITFILE will be set to /var/run/\$USER/NAME.exit if
               /var/run/\$USER exists, otherwise it will write to
               /var/tmp/\$USER/NAME.exit
 
               LOCKFILE will be set to /var/run/\$USER/NAME.lock if
               /var/run\$USER exists, otherwise it will write to
               /var/tmp/\$USER/NAME.lock
 
               LOGFILE will be set to /var/log/\$USER/NAME.log if
               /var/log/\$USER exists, otherwise it will write to
               /var/tmp/$USER/NAME.log
  -s           If set the script will sleep a random time between 0 and 60
               seconds before starting the command.
  -t           If set then the output from the script will be automatically
               timestamped when being written to the log file.
 
COMMAND is the command that should be executed.
EOF
}
 
SAFE_EXIT=0
EXIT_FILE=""
NICE=0
LOCK_FILE=""
LOG_FILE=""
NAME=""
SLEEP=0
TIMESTAMP=0
 
# This is a cach of all the groups the user is a member of. We use it with
# canwrite() later.
GROUPS=""
 
# Checks to see if the shell array ($2) contains $1.
contains() {
  local i
  for i in "${@:2}"; do
    [[ "$i" == "$1" ]] && return 0
  done
  return 1
}
 
# Checks to see if the current user can write to the given file. This will check the
# file permissions first, and if the file does not exist then it will check the
# directory permissions.
canwrite() {
  local perm
  local owner
  local group
 
  if [ -f "$1" ] ; then
    read perm owner group < <(stat -Lc "%a %G %U" "$1" 2> /dev/null)
  else
    read perm owner group < <(stat -Lc "%a %G %U" "$(dirname $1)" 2> /dev/null)
  fi
  if [ $? -ne 0 ] ; then
    return 1
  fi
  
  if [ "$owner" == "$USER" ] ; then
    if [ $((perm&0200)) -ne 0 ] ; then
      return 1
    fi
    return 0
  elif contains "$group" "${GROUPS[@]}" ; then
    if [ $((perm&0020)) -ne 0 ] ; then
      return 1
    fi
    return 0
  else
    if [ $((perm&0002)) -ne 0 ] ; then
      return 1
    fi
    return 0
  fi
}
 
name() {
  NAME="$1"
 
  # Exit file
  if [ -z "$EXIT_FILE" ] ; then
    if canwrite "/var/run/${USER}/${NAME}.exit" ; then
      EXIT_FILE="/var/run/${USER}/${NAME}.exit"
    else
      mkdir -p "/var/tmp/${USER}"
      EXIT_FILE="/var/tmp/${USER}/${NAME}.exit"
    fi
  fi
   
  # Lock File
  if [ -z "$LOCK_FILE" ] ; then
    if canwrite "/var/run/${USER}/${NAME}.lock" ; then
      LOCK_FILE="/var/run/${USER}/${NAME}.lock"
    else
      mkdir -p "/var/tmp/${USER}"
      LOCK_FILE="/var/tmp/${USER}/${NAME}.lock"
    fi
  fi
   
  # Log File
  if [ -z "$LOG_FILE" ] ; then
      if canwrite "/var/run/${USER}/${NAME}.lock" ; then
      LOG_FILE="/var/log/${USER}/${NAME}.log"
    else
      mkdir -p "/var/tmp/${USER}"
      LOG_FILE="/var/tmp/${USER}/${NAME}.log"
    fi
  fi
}
 
while getopts "ce:hik:l:n:st" arg; do
  case $arg in
    c) SAFE_EXIT=1 ;;
    e) EXIT_FILE="$OPTARG" ;;
    h) usage ; exit ;;
    i) NICE=1 ;;
    k) LOCK_FILE="$OPTARG" ;;
    l) LOG_FILE="$OPTARG" ;;
    n) name "$OPTARG" ;;
    s) SLEEP=1 ;;
    t) TIMESTAMP=1 ;;
  esac
done
shift $((OPTIND-1))
 
 
# This function will write a log line to the output. This can either be called by the
# timestamper, or internally.
log() {
  if [ $TIMESTAMP -eq 1 ] ; then
    echo "$(date) $*"
  else
    echo "$*"
  fi
}
 
# Setup logging first so we can report to the user what is happening.
if [ -n "$LOG_FILE" ] ; then
  exec > "$LOG_FILE" 2>&1
fi
 
# Attempt to lock the lock file if it is set.
if [ -n "$LOCK_FILE" ] ; then
  exec 200>> "$LOCK_FILE"
  flock -n -x 200
  if [ $? -ne 0 ] ; then
    log "Unable to obtain a lock, is a job already running?"
    if [ $SAFE_EXIT -eq 1 ] ; then
      exit 0
    else
      exit 1
    fi
  fi
fi
 
# Sleep a random amount between 0 and 60 seconds.
if [ $SLEEP -eq 1 ] ; then
  sleep $((RANDOM%60))
fi
 
# Get the pre-command in case we need to nice the job.
PRECOMMAND=""
if [ $NICE -eq 1 ] ; then
  PRECOMMAND="nice"
fi
 
# Run the command.
if [ $TIMESTAMP -eq 1 ] ; then
  $PRECOMMAND "$@" 2>&1 | while read line ; do log "$line" ; done
else
  $PRECOMMAND "$@" 2>&1
fi
EXIT_STATUS=$?
 
# Process the exit file.
if [ -n "$EXIT_FILE" -a $EXIT_STATUS -eq 0 ] ; then
  date > "$EXIT_FILE"
fi
 
# Exit status
if [ $SAFE_EXIT -eq 1 ] ; then
  exit 0
else
  exit $EXIT_STATUS
fi