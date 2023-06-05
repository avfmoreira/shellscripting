This repo is used to save my shellscript exercises
# shellscripting

## add-local-user.sh
[add-local-user.sh](https://github.com/avfmoreira/shellscripting/blob/main/add-local-user/add-local-user.sh) -  This script allows to create local users asking to user prompt username, real name and password to new one. At the end it returns the hostname, username and temporaly pass created(that will need to changed on first login)
![add-local-user.sh-executed](https://github.com/avfmoreira/shellscripting/blob/main/add-local-user/result.jpg)

## add-new-local-user.sh
![add-new-local-user.sh-executed](https://github.com/avfmoreira/shellscripting/blob/main/add-local-user/add-new-local-user.jpg)
[add-new-local-user.sh](https://github.com/avfmoreira/shellscripting/blob/main/add-local-user/add-new-local-user.sh) - This script allows the user create new accounts on local system.

### HOW it works?
this script just can be called by a user with administrative privileges, a superuser or root user. The user must pass two arguments: It's mandatory that first argument must be the USER_NAME. All that remains will be interpreted as comment to the account.

### If everything goes well 
the return must be a message with 
- the hostname that account was created
- the account name 
- the random pass
