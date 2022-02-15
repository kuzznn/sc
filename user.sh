#!/bin/bash

adduser(){
if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	read -s -p "Enter password : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -p "$pass" "$username"
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
	fi
else
	echo "Only root may add a user to the system."
	exit 2
fi
}
deluser(){
	if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	getent passwd $username
	if [ $? -eq 0 ]; then
		userdel -r "$username"
		echo "User "$username" deleted"
	else
		echo "$username not exists!"
		exit 1
	fi
	else
		echo "Only root may add a user to the system."
		exit 2
	fi
}
addgroups(){
	if [ $(id -u) -eq 0 ]; then
	read -p "Enter groupname : " groupname
	egrep "^$groupname" /etc/group >/dev/null
	if [ $? -eq 0 ]; then
		echo "$groupname exists!"
		exit
	else
		groupadd "$groupname"
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
	fi
else
	echo "Only root may add a user to the system."
	exit
fi
}
delgroup(){
	if [ $(id -u) -eq 0 ]; then
	read -p "Enter groupname : " groupname
	egrep "^$groupname" /etc/group >/dev/null
	if [ $? -eq 0 ]; then
		groupdel "$groupname"
		echo "Group "$groupname" deleted"
	else
		echo "$groupname not exists!"
		exit 
	fi
	else
		echo "Only root may add a user to the system."
		exit
	fi
}

adduser
addgroups
deluser
delgroup
#usermod
#gpasswd
#menu