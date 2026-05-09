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

#configuring forntend
dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabiling nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "Removing all files in html folder"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading zip file in tmp folder"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Unzipping zip file"

cp /home/ec2-user/302-expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "Copying expense conf file"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restarting nginx"