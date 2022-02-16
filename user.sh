#!/bin/bash

adduser(){
if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	read -s -p "Enter password : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		sudo adduser -p "$pass" -m "$username" 
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
	fi
	else
		echo "Only root may add a user to the system."
		exit
	fi
}
gpasswdadd(){
	if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	while :
	do
		egrep "^$username" /etc/passwd >/dev/null
		if [ $? -eq 0 ]; then
			break
		else
			echo "$username"
			read -s -p "Enter passwd : " password
			pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
			sudo adduser -p "$pass" -m "$username"
			[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
		fi
	done
		read -p "Enter groupname : " groupname
		egrep "^$groupname" /etc/group >/dev/null
		if [ $? -eq 0 ]; then
			gpasswd -a "$username" "$groupname" 
			echo "Add user $username to group $group suscesfully"

		else
			echo "User $username deleted"
			userdel "$username"
		
		fi

	else
		echo "Only root may add a user to the system."
		exit 2
	fi
}
gpasswddel(){
	if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	while :
	do
		egrep "^$username" /etc/passwd >/dev/null
		if [ $? -eq 0 ]; then
			break
		else
			echo "$username"
			read -s -p "Enter passwd : " password
			pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
			sudo adduser -p "$pass" -m "$username"
			[ $? -eq 0 ] && echo "User has been removed from the system!" || echo "Failed to del a user!"
		fi
	done
		read -p "Enter groupname : " groupname
		egrep "^$groupname" /etc/group >/dev/null
		if [ $? -eq 0 ]; then
			gpasswd -d "$username" "$groupname" 
			echo "User $username has been removed from group $group suscesfully"
			
		else
			echo "User $username deleted"
			userdel "$username"
			
		fi

	else
		echo "Only root may add a user to the system."
		exit 2
	fi
}
menu(){
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~"	
	echo "          M E N U        "
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Add user              "
	echo "2. Remove user           "
	echo "3. Add group             "
	echo "4. Remove group          "
	echo "5. Add user to group     "
	echo "6. Remove user from group"
	echo "7. Exit"
}
readoptions(){
	local choice
	read -p "Enter choice [ 1 - 7] " choice
	case $choice in
		1) adduser
		;;
		2) deluser 
		;;
		3) addgroups
		;;
		4) delgroup 
		;;
		5) gpasswdadd 
		;;
		6) gpasswddel 
		;;
		7) echo "Thanks"
		exit 0
		;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}
while :
do
 
	menu
	readoptions
	sleep 1.5
done