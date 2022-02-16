#!/bin/bash

adduser() {
	read -p "Enter username : " username
	read -s -p "Enter password : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		sudo adduser -p "$pass" -m "$username"
		local choice
		read -p "Do you want to disable login:  y/N  " choice
		case $choice in
		y)
			usermod "$username" -s /sbin/nologin
			[ $? -eq 0 ] && echo "User has been added to system and disable login" || echo "Failed to add a user!"
			;;
		n)
			[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
			;;
		*) echo -e "${RED}Error...${STD}" && sleep 2 ;;
		esac

	fi
}
deluser() {
	read -p "Enter username : " username
	getent passwd $username
	if [ $? -eq 0 ]; then
		userdel -r "$username"
		echo "User "$username" deleted"
	else
		echo "$username not exists!"
	fi
}
addgroups() {
	read -p "Enter groupname : " groupname
	egrep "^$groupname" /etc/group >/dev/null
	if [ $? -eq 0 ]; then
		echo "$groupname exists!"
	else
		groupadd "$groupname"
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
	fi
}
delgroup() {
	read -p "Enter groupname : " groupname
	egrep "^$groupname" /etc/group >/dev/null
	if [ $? -eq 0 ]; then
		groupdel "$groupname"
		echo "Group "$groupname" deleted"
	else
		echo "$groupname not exists!"
	fi
}
gpasswdadd() {
	read -p "Enter username : " username
	while :; do
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
		userdel -r "$username"

	fi
}
gpasswddel() {
	read -p "Enter username : " username
	while :; do
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
		userdel -r "$username"

	fi

}
listuser() {
	if [ $(id -u) -eq 0 ]; then
		ls /home >usernames
		cat usernames

	else
		echo "Only root may add a user to the system."
		exit 2
	fi
	rm -f usernames
}
addusers() {
	read -p "Groupname to add: " groupnames
	while read line; do
		IFS= ':'
		read -ra info <<<"$line"
		egrep "^${info[0]}" /etc/passwd >/dev/null
		if [ $? -eq 0 ]; then
			echo "${info[0]} exists!"
		else
			pass=$(perl -e 'print crypt($ARGV[0], "password")' ${info[1]})
			sudo adduser -p "$pass" -m "${info[0]}" -G "$groupnames"
			[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
		fi
	done <./user
}

menu() {
	#clear
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "          M E N U        "
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Add user              "
	echo "2. Remove user           "
	echo "3. Add group             "
	echo "4. Remove group          "
	echo "5. Add user to group     "
	echo "6. Remove user from group"
	echo "7. List user"
	echo "8. Add users"
	echo "0. Exit"
}
readoptions() {
	local choice
	read -p "Enter choice [ 1 - 7] " choice
	case $choice in
	1)
		adduser
		;;
	2)
		deluser
		;;
	3)
		addgroups
		;;
	4)
		delgroup
		;;
	5)
		gpasswdadd
		;;
	6)
		gpasswddel
		;;
	7)
		listuser
		;;
	8)
		addusers
		;;
	0)
		echo "Thanks"
		exit 0
		;;
	*) echo -e "${RED}Error...${STD}" && sleep 2 ;;
	esac
}
if [ $(id -u) -eq 0 ]; then
	while :; do
		menu
		readoptions
		#sleep 1.5
	done
else
	echo "Only root may add a user to the system."
	exit 2
fi
