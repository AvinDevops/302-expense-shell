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

# configuring backend
dnf module disable nodejs:18 -y &>>$LOGFILE
VALIDATE $? "Disabiling nodejs 18v"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabiling nodejs 20v"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs 20v"


id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
    VALIDATE $? "creating expense user for app"
else
    echo -e "$Y expense user already created $N"
fi

mkdir -p /app &>>$LOGFILE
VALIDATE $? "creating app dir"


