#!/bin/bash

#if not is root running ends the script
if [[ UID -ne 0 ]]
then
 echo 'Just root user can run this script'
 exit 1
fi

#ask for an username
read -p 'Enter the username to create: ' USER_NAME

#ask for real name
read -p 'Enter the user real name: ' COMMENT

#ask for the password
read -p 'Enter the password to user account: ' PASSWORD 

#create the user
useradd -c "${COMMENT}" -m ${USER_NAME}

#check if the last command run succedded
if [[ ${?} -ne 0 ]]
then
 echo "An error occorred trying create the user"
 exit 1
fi 

#set password for the user
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

#ask a new password on fist login
passwd -e ${USER_NAME}

#check if the last command run succedded
if [[ "${?}" -eq 0 ]]
then 
 echo 'New user created:'
 echo "Host: ${HOSTNAME}"
 echo "Username: ${USER_NAME}"
 echo "Password: ${PASSWORD}"
fi 

#check if everything run well or not
echo "exit ${?}"

