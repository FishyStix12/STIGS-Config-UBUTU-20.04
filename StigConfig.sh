#!/bin/bash
###################################################################################
#	Author: Nicholas Fisher
#	Date: November 19 2023
#	Collaborators: IS 480 for STIG check 1
#	Course #: IS 480
#	Description of Script
#	Checks to see if Ubuntu Server meets 6 STIG Conditions for
#	configuration and security settings for Ubuntu 20.04. Please read the 
#	comments for STIGs 2 & 3 and make the necessary changes to ensure the
#	script properly configures the settings on your system.
###################################################################################
# STIG 1: UBTU-20-010004
# Check to see if GUI session lock is enabled.
echo "STIG check 1: UBTU-20-010004"

# run the check command and store the results in a variable 'checklox'
checklox=$(sudo gsettings get org.gnome.desktop.screensaver lock-enabled)

# if the command returns false it will ask the user if they would like
# to change the settings to ensure that the Ubuntu system is compliant
# if the command returns true the system congratulates the user
# and moves to the next STIG. If the command returns with true the script moves on
# to the next STIG in the checklist.
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
# special character. Please uncomment the ocredit = 0
# in the /etc/security/pwquality.conf before running this script to ensure the settings are 
# applied to the system.
echo "STIG check 2: UBTU-20-010055"

# run the check command and store the results to 'checkcomp'
checkcomp=($(grep -i "ocredit" /etc/security/pwquality.conf| cut -d " " -f 3))

# if the command returns a value of 0, then the system does not require complex passwords,
# and is not compliant. It then proceeds to ask the user if they would like to change the 
# settings to requires users to use a special character in their password. If they say yes
# The script replaces the ocredit line in the /etc/security/pwquality.conf file to a value
# of -1 to require users to include at least one special character in their password.
# If the user  says no the script moves to the next STIG configuration on the checklist. If the 
# command returns with a value that does not equal 0 the script will move to the next STIG in the 
#checklist.
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
# to a minimum of 8 characters. To ensure the system is compliant. 
# Please uncomment the difolk = 1 line in the /etc/security/pwquality.conf 
# before running this script to ensure the settings are applied to the system.
echo "STIG check 3: UBTU-20-010053"

# run the check command and store the results to 'checklen'
checklen=($(grep -i "difok" /etc/security/pwquality.conf | cut -d " " -f 3))

# If the command returns a value that is less than 8 it will ask the user if they
# Would like to require users to have a password that is at least 8 characters in
# length. If the user responds with yes then the script will replace the line of 
# "difolk = 1" (base configuration for difolk setting) with "difolk = 8", making
# it so users have to have a minimum password length of 8 characters. If the user
#responds with no then the script moves to the next stig on the checklist. If the 
# command returns with a value is greater than or equal to 8 the script moves on
# to the next STIG in the checklist.
if [[ "$checklen" -lt 8 ]]; then
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
echo "STIG check 4: UBTU-20-010454"

# run the check command and store the results to 'checkfire'
checkfire=$(systemctl status ufw.service | grep -i "active:")

# If the command doesn't return active, then the script will ask
# the user if they would like to activate the application firewall.
# If the user responds with yes, then the script will enable
# and start the appliacation firewall on the system. If the user
# responds with no the script will move onto the next STIG in the 
# checklist. If the command returns with active the script moves on
# to the next STIG in the checklist.
if [[ "$checkfire" != *active* ]]; then
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
echo "STIG check 5: UBTU-20-010439"

# run the check command and store the results to 'checkapp'
checkapp=($(sudo dpkg -l| grep apparmor| sort -u| cut -d " " -f 3| grep -w apparmor))

# If the command does not return "apparmor", then the package has not been
# installed on the system. It will then ask the user if they would like
# to download apparmor for their Ubuntu system. If the user says yes
# the script will ask for the sudo password, and install and start 
# the apparmor on their system. If the command returns "apparmor" the 
# script will check to see if the service is enabled on the system.
# If the command does not return enabled, it will then ask the user
# if the would like to enable the apparmor service. If the user 
# responds with yes then the script will enable and start the apparmor
# service. If they respond with no the script will move onto the next STIG
# in the checklist. If the second command does return with enabled the script
# will move onto the next STIG in the checklist. 
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
# direct login into the root user.
echo "STIG check 6: UBTU-20-010408"

# run the check command and store the results to 'checkpasswd'
checkpasswd=($(sudo passwd -S root| cut -d " " -f 2))

# If the command does not return an L, the script will then ask
# the user if they would like to make it so nobody can directly
# login to the root user. If the user responds with yes then the 
# script will change the passwd settings for root to L (locked),
# so nobody can directly log into the root user. If the user responds
# with no the script congratulates the user for finishing the STIG
# Checklist configuration script. If the command above does return
# L as its value the script then congratulates the user for finishing
# the STIG Checklist configuration script.
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
#reboots the system to automatically apply all the new changes on the system for all users. Thank you for using my script.
sudo reboot
