#!/bin/bash


#Check if who is running this script is root or not
if [[ UID -ne 0 ]]
then
 echo 'This script must be executed with superuser (root) privileges'
 exit 1
fi

#Show usage statement if no argument is passed
if [[ ${#} -lt 1 ]]
then
    echo 
    echo "Usage: ${0} [USER_NAME] [COMMENT]"
    echo 
    echo "The first argument is always a USER_NAME, it refers to a local user that will be create on localhost."
    echo "Any remaining arguments on the command line will be treated as the [COMMENT] for the account."
    echo 
    exit 1
fi

#First parameter is got as user name
USER_NAME=${1}

#The parameters remains will be took as comment
shift
COMMENT=${@}

PASSWORD=$(date +%s%N | sha256sum | head -c 14)

#Create the new user
useradd -c "${COMMENT}" -m ${USER_NAME}

#Check if the last command run succedded
if [[ ${?} -ne 0 ]]
then
 echo "An error occorred trying create the account"
 exit 1
fi 

#Set password for the account
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

#Check if the password has been setted
if [[ ${?} -ne 0 ]]
then
 echo "An error occorred trying to set the password"
 exit 1
fi 

#Define new password to account on fist login
passwd -e ${USER_NAME}

#Check if the last command run succedded
if [[ "${?}" -eq 0 ]]
then 
    echo
    echo 'New local account created:'
    echo
    echo "Hostname:"
    echo "${HOSTNAME}"
    echo
    echo "Username:"
    echo "${USER_NAME}"
    echo
    echo "Password:"
    echo "${PASSWORD}"
    echo
fi 

#Check if everything run well or not
echo "exit ${?}"

