#!/bin/bash
#
# This script disable, delete and/or archives users on the local system
#
ARCHIVE_DIR='/archive'

#Usage statement
usage(){
	echo
	echo "USAGE: $(basename ${0}) [-dra] USER [USERNAME]..." >&2
	echo "Disable a local Linux account." >&2
	echo "	-d	Deletes accounts instead of disabling them."  >&2
	echo "	-r	Removes the home directory associetead with the account." >&2
	echo "	-a	Create an archive of the home dictory associated with the account and stores the archives in the /archives directory." >&2
	echo
	exit 1
} 

#Check if the current user have superuser privileges or it is root
if [[ "${UID}" -ne 0 ]]
then 
	echo "$(id -un), you are not root. Only a user with superuser privileges can run this script." >&2
	exit 1
fi

#At least one user is requered to be deleted. Otherwise display usage statement.
if [[ "${#}" -lt 1 ]]
then
	usage
else
	while getopts dra OPTION
	do
		case ${OPTION} in
            d) DELETE_USER='true' ;;
            r) REMOVE_OPTION='-r' ;;
            a) ARCHIVE='true';;
            ?) usage ;; 
		esac
	done

	#Remove the options while leaving the remaining arguments.
	shift "$((OPTIND - 1))"

    #Loop through all the usernames supplied as arguments.
    for USERNAME in "${@}"
    do
        echo "Processing user: ${USERNAME}"

        #make sure the uid of the account is at least 1000
        USERID=$(id -u ${USERNAME}) 
        if [[ ${USERID} -lt 1000 ]]
        then
            echo "Refusing to remove the ${USERNAME} account with UID ${USERID}." >&2
            exit 1
        fi

        #Create an archive if requested to do so.
        if [[ "${ARCHIVE}" = 'true' ]]
        then

            #Make sure the ARCHIVE_DIR exists
            if [[ ! -d "${ARCHIVE_DIR}" ]]
            then 
                echo "Creating ${ARCHIVE_DIR}"
                mkdir -p ${ARCHIVE_DIR}
                if [[ "${?}" -ne 0 ]]
                then
                    echo "The archive directory ${ARCHIVE_DIR} could not be created." >&2
                    exit 1
                fi
            fi

            #Archive the user's home directory and move it into the ARCHIVE_DIR
            HOME_DIR="/home/${USERNAME}"
            ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"
            if [[ -d ${HOME_DIR} ]]
            then
                echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
                tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &> /dev/null
                if [[ ${?} -ne 0 ]]
                then
                    echo "Could not create ${ARCHIVE_FILE}." >&2
                    exit 1
                fi
            else
                echo "${HOME_DIR} does not exist or is not a directory." >&2
                exit 1
            fi
        fi

        #Delete the user
        if [[ "${DELETE_USER}" = 'true' ]]
        then
            userdel ${REMOVE_OPTION} ${USERNAME}
        
            #check if the user was deleted
            if [[ ${?} -ne 0 ]]
            then
                echo "The account ${USERNAME} was NOT deleted." >&2
                exit 1
            fi
        else
            #disable the user
            chage -E 0 ${USERNAME}
            #check if the user was disable
            if [[ ${?} -ne 0 ]]
            then
                echo "The account ${USERNAME} was NOT disable." >&2
                exit 1
            fi
            echo "The account ${USERNAME} was disable."  
        fi
    done
fi
exit 0
