#!/bin/bash
#
#This script executes commands as a single command on every server on a server list
#

#The commands will be executed on every server listed in this file
SERVERS_FILE='/vagrant/servers'

#USAGE STATEMENT
usage(){
 echo
 echo "USAGE: ${0} [-nvs] [-f FILE] COMMAND" >&2
 echo
 echo 'Executes COMMANDS as a single command on every server' >&2
 echo " -f FILE  Allows the user override the default file of servers (${SERVERS_FILE})." >&2
 echo ' -n       Allows the user to perform a "dry run" where the commands will be displayed instead of executed.' >&2
 echo '          Precede each command that would have been executed with "DRY RUN: "' >&2
 echo ' -s       Run the command with sudo privileges on the remote server.' >&2
 echo ' -v       Enable verbose mode, which displays the name of the server for which the command is being executed on.' >&2
 echo
 exit 1 
}

#Check if the script is not begin executed as root.
if [[ "${UID}" -eq 0 ]]
then
 echo 'Do not executes this script as root. Use the -s option instead' >&2
 usage
 exit 1
fi

#parse options
while getopts ':f:nsv' OPTION
do
  case $OPTION in
   f) SERVERS_FILE="${OPTARG}" ;;
   n) DRYRUN='true' ;; 
   s) SUDO='sudo' ;;
   v) VERBOSE='true' ;;
   ?) usage ;;
  esac
done

#Remove the options while leaving the remaining arguments
shift "$(( OPTIND - 1 ))"

if [[ ${#} -lt 1 ]]
then
 echo 'This script need at least one command to be executed on the servers'>&2
 usage
fi

#Display an error if the servers file is unreachable
if [[ ! -e ${SERVERS_FILE} ]]
then
 echo "Can not open server list file ${SERVERS_FILE}" >&2
 exit 1
fi

EXIT_STATUS='0'

#Looping through every server in server list
for SERVER in $(cat ${SERVERS_FILE})
do
  
  #Anything else on command line is treat as a single command
  COMMAND="ssh -o ConnectTimeout=2 ${SERVER} ${SUDO} ${@}"
   
  if [[ ${VERBOSE} = 'true' ]]
  then
    echo "${SERVER}"
  fi
  if [[ ${DRYRUN} = 'true' ]]
  then
    echo "DRY RUN: ${COMMAND}"

  else
    ${COMMAND}
    SSH_EXIT_STATUS="${?}"
    
    if [[ ${SSH_EXIT_STATUS} -ne 0 ]]
    then
     EXIT_STATUS="${SSH_EXIT_STATUS}"
     echo "Execution ${SERVER} falied." >&2
    fi
  fi
done

exit ${EXIT_STATUS}
