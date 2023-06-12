This repo is used to save my shellscript exercises
# shellscripting

## add-local-user.sh
[add-local-user.sh](https://github.com/avfmoreira/shellscripting/blob/main/add-local-user/add-local-user.sh) -  This script allows to create local users asking to user prompt username, real name and password to new one. At the end it returns the hostname, username and temporaly pass created(that will need to changed on first login)
![add-local-user.sh-executed](https://github.com/avfmoreira/shellscripting/blob/main/add-local-user/result.jpg)

## add-new-local-user.sh
![add-new-local-user.sh-executed](https://github.com/avfmoreira/shellscripting/blob/main/add-local-user/add-new-local-user.jpg)
[add-new-local-user.sh](https://github.com/avfmoreira/shellscripting/blob/main/add-local-user/add-new-local-user.sh) - This script allows the user create new accounts on local system.

### How it works?
This script just can be called by a user with administrative privileges, a superuser or root user. The user must pass two arguments: It's mandatory that first argument must be the USER_NAME. All that remains will be interpreted as comment to the account.

### If everything goes well 
the return must be a message with 
- the hostname that account was created
- the account name 
- the random pass

## disable-accounts.sh
![disable-accounts.sh](https://github.com/avfmoreira/shellscripting/blob/main/disable-accounts.jpg)
[disable-accounts.sh](https://github.com/avfmoreira/shellscripting/blob/main/disable-accounts.sh) - This script allows the user disable, delete and archive accounts on local system.

### How it works?

Only a usar that have superuser privileges can execute this script. 
The user must pass at least one user that will be deleted, but can be more than one. Otherwise the script will be display usage information.

There are as options -a (archive the home directory), -d (delete the account) and -r (remove the home directory account). IMPORTANT: In case the option -d there no passed, the script will just deactive the user, blocking your login until manual intervention of sysadmin.

## show-attackers.sh
![show-attackers.sh](https://github.com/avfmoreira/shellscripting/blob/main/show-attackers.jpg)
[show-attackers.sh](https://github.com/avfmoreira/shellscripting/blob/main/show-attackers.sh) - This script receive a file that content a attempts failed login list as input and sumeraze it to display  if there are any IP addresses with more than 10 failed login attempts, the number of attempts made, the IP address from which those attempts were made, and the location of the IP address will be displayed.

The goals of this exercise was understand how works the commands grep, cut and awk

## run-everywhere.sh
![run-everywhere.sh](https://github.com/avfmoreira/shellscripting/blob/main/multi/run-everywhere.jpg)
[run-everywhere.sh](https://github.com/avfmoreira/shellscripting/blob/main/multi/run-everywhere.sh) - Once the peer are authenticated by ssh, this script allow the user send commands a list of machines at once.