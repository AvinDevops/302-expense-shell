#!/bin/bash
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log

#colors
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

# Validate function
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo  -e "$2 is....$R FAILED $N"
        exit 1
    else
        echo -e "$2 is....$G SUCCESS $N"
    fi
}

# checking root user or not
if [ $USERID -ne 0 ]
then
    echo -e "$R you'r not root user, please access with root $N"
    exit 1
else
    echo -e "$G you'r root user $N"
fi  

## DB configuring

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing mysql server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabiling mysqld"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting mysqld"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "Setting password for root"