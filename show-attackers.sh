#! /bin/bash

#
# This script display summarize failed login attempts.
#

#a file must be passed as argument, if not display an error and exit 1
FILE=${@}

#Set a temp directory
TEMP_DIR='/var/tmp/'
#Set a temp file 
ATTEMPTS_BY_IP_LIST="${TEMP_DIR}list_ip_attackers"
#Set a output CSV file with a header 
OUTPUT_FILE=$(echo 'Count,IP,Location' > attackers.csv)

#In case there no file as argument, exit as an error
if [[ ! -e ${FILE} ]]
then
	echo "There no valid file passed as argument or the file does not exist." >&2
      	exit 1
fi

#In case the temp dir no exist, create them
if [[ ! -d ${TEMP_DIR} ]]
then
	mkdir -p ${TEMP_DIR}
fi
 
#Count how many times of falied login attempts by IP address and select all those up 10 times and store in a temp file
cat ${FILE} | grep "Failed password" | cut -d " " -f 11 | sort -nk 2 | grep -vE '[a-zA-Z]' | uniq -c | awk '($1 > 10) {print $1","$2}' > ${ATTEMPTS_BY_IP_LIST}

#For each item in the list previusly stored, get count, ip and location of the ip address and stored in a csv file
for ITEM in $(cat ${ATTEMPTS_BY_IP_LIST})
do
	NUMBER_ATTEMPTS=$(echo "${ITEM}" | awk -F ',' '{print $1}')
	IP=$(echo ${ITEM} | awk -F "," '{print $2}')
	echo "${NUMBER_ATTEMPTS},${IP},$(geoiplookup ${IP} | awk '{print $NF}')" >> attackers.csv
done

#Remove the temp file that is no needed any more
rm ${ATTEMPTS_BY_IP_LIST}

#Display the content of attackers.csv on the screen
echo 
echo "RESULT:"
echo
cat attackers.csv
echo 
exit 0

