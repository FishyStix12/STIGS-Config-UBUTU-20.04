#!/bin/bash
###################################################################################
#	Author: Nicholas Fisher
#	Date: November 11 2023
#	Collaborators: IS 480
#	Course #: IS 480
#	Description of Script
#	Checks to see if Ubuntu Server meets 6 STIG Conditions for
#	configuration and security settings for Ubuntu 20.04.
###################################################################################
# STIG 1: UBTU-20-010004
# Check to see if GUI session lock is enabled
# run the check command and store the results in a variable 'checklox'
checklox=$(sudo gsettings get org.gnome.desktop.screensaver lock-enabled)

# if the command returns false it will ask the user if they would like
# to change the settings to ensure that the Ubuntu system is compliant
# if the command returns true the system congratulates the user
# and moves to the next STIG
if [[ "$checklox" != *true* ]]; then
	echo "system does not have screen lock enabled and is not compliant."
	read -p "Would you like to enable screen lock? y/n: " userinput
	if [[ $userinput == [yY] || $userinput == [yY][eE][sS] ]]; then
		sudo gsettings set org.gnome.desktop.screensaver lock-enabled true
		echo "Your system is now compliant!"
	else
		echo "Onto STIG Check 2!"
	fi
else
	echo "System has screen lock enabled and is complaint!"
fi

# STIG 2: UBTU-20-010055
# Checks to see if Ubunutu requires a complex password with at least 1
# special character
# run the check command and store the results to 'checkcomp'
checkcomp=($(grep -i "ocredit" /etc/security/pwquality.conf| cut -d " " -f 3))
if [[ "$checkcomp" -eq 0 ]]; then
	echo "System is not compliant as users do not require complex passwords!"
	read -p "Would you like to enable the use of special chars in passwords y/n: " userinput2
	if [[ $userinput2 == [yY] || $userinput2 == [yY][eE][sS] ]]; then
		thefile=/etc/security/pwquality.conf
		text="ocredit = 0"
		sudo sed -i "s/$text/ocredit=-1/" $thefile
		echo "The new complexity is" $checkcomp "and the system is now compliant!"
	else
		echo "Onto STIG Check 3!"
	fi
else
	echo "System does require complex passwords!"
fi

# STIG 3: UBTU-20-010053
# Checks to see what the minimum password length is, and changes it
# to a minimum of 8 characters. TO ensure the system is compliant
# run the check command and store the results to 'checklen'
checklen=($(grep -i "difok" /etc/security/pwquality.conf | cut -d " " -f 3))
if [[ "$checklen" >= 8 ]]; then
	echo "System is not compliant as users do not require a minimum passwd of 8 characters!"
	read -p "Would you like the system to require an 8 character min for passwds y/n: " userinput3
	if [[ $userinput3 == [yY] || $userinput3 == [yY][eE][sS] ]]; then
		thefile2=/etc/security/pwquality.conf
		text2="difok = 1"
		sudo sed -i "s/$text2/difok = 8/" $thefile2
		finallen=($(grep -i "difok" /etc/security/pwquality.conf | cut -d " " -f 3))
		echo "The new min passwd length is " $finallen "and the system is compliant!"
	else
		echo "Onto STIG Check 4!"
	fi
else
	echo "System is compliant with 8 character password minimum!"
fi

# STIG 4: UBTU-20-010454
# Checks to see if the system application firewall is
# enabled.
checkfire=$(systemctl status ufw.service | grep -i "active:")
if [[ "$checkfire" == *inactive* ]]; then
        echo "The systems application firewall is disabled!"
        read -p "Would you like to enable the application firewall y/n: " userinput4
        if [[ $userinput4 == [yY] || $userinput4 == [yY][eE][sS] ]]; then
                sudo systemctl enable ufw.service
                sudo systemctl start ufw.service
                starttime=$(systemctl status ufw.service | grep -i "active:"| cut -d " " -f 10-12)
                echo "The system firewall has been active since" $starttime "!"
	else
		echo "Onto STIG Check 5!"
        fi
else
        echo "The system firewall is active!"
fi

# STIG 5: UBTU-20-010439
# Checks to see if the system is configured to use
# Apparmor.
checkapp=($(sudo dpkg -l| grep apparmor| sort -u| cut -d " " -f 3| grep -w apparmor))

if [[ "$checkapp" != "apparmor" ]]; then
	echo "Apparmor is not installed"
	read -p "Would you like to install Apparmor y/n: " userinput5
	if [[ $userinput5 == [yY] || $userinput5 == [yY][eE][sS] ]]; then
		sudo apt-get install apparmor
		sudo systemctl enable apparmor.service
		sudo systemctl start apparmor.service
		echo "The system has now installed and started Apparmor!"
	fi
else
	echo "App Armor is installed on this pc. Let us see if it is enabled"
	checkarmor=($(systemctl is-enabled apparmor.service))
	if [[ "$checkarmor" != "enabled" ]]; then
		read -p "The apparmor service is installed but inactive. Would you like to activate it y/n: " userinput6
		if [[ $userinput6 == [yY] || $userinput6 == [yY][eE][sS] ]]; then
			sudo systemctl enable apparmor.service
			sudo systemctl start apparmor.service
			echo "The Apparmor service is now enabled and started!"
		else
			echo "Onto STIG Check 6!"
		fi
	else
		echo "System is compliant!"
	fi
fi


# STIG 6: UBTU-20-010408
# Checks to see if the Ubunutu system doesn't allow
# direct login into the root user

checkpasswd=($(sudo passwd -S root| cut -d " " -f 2))

if [[ "$checkpasswd" != "L" ]]; then
	echo "Someone can directly login to the root user..."
	read -p "Would you like to prevent users from directly logging into the root user y/n: " userinput7
	if [[ $userinput7 == [yY] || $userinput7 == [yY][eE][sS] ]]; then
		sudo passwd -l root
		echo "Users can no longer directly login to the root user! STIG Checklist is complete. Have a great day!"
	else
		echo "STIG Checklist is complete. Have a good day!"
	fi
else
	echo "The system is compliant and nobody can log directly into the root user. Your system is now fully compliant!"
	echo "Have a great day!"
fi
