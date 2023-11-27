# STIGS-Config-UBUTU-20.04 Final Project
This script checks to see if an Ubuntu 20.04 (Focal Fossa) 20.04 machine meets 6 Department of Defense's STIG configruations to ensure our machines meet the Department of Defense's standards. <br />
This script will configure the following STIGs for Ubuntu 20.04 with the main command to check each configuration in quotes: <br />
1. UBTU-20-010004 - Checks to see if GUI session lock is enabled.
   "checklox=$(sudo gsettings get org.gnome.desktop.screensaver lock-enabled)"
2. UBTU-20-010055 - Checks to see if Ubuntu requires a complex password with at least 1 special character.
   "checkcomp=($(grep -i "ocredit" /etc/security/pwquality.conf| cut -d " " -f 3))"
3. UBTU-20-010053 - Checks to see if the minimum password length for users is 8 characters or longer.
   "checklen=($(grep -i "difok" /etc/security/pwquality.conf | cut -d " " -f 3))"
4. UBTU-20-010454 - Checks to see if the application firewall is enabled.
   "checkfire=$(systemctl status ufw.service | grep -i "active:")"
5. UBTU-20-010439 - Checks to see if the Ubuntu system is configured to use the AppArmor tool.
   "checkapp=($(sudo dpkg -l| grep apparmor| sort -u| cut -d " " -f 3| grep -w apparmor))"
9. UBTU-20-010439 - Checks to see if the system does not allow someone to directly login to the root user.
    "checkpasswd=($(sudo passwd -S root| cut -d " " -f 2))" <br />
Please follow the following guidlines for the script to ensure it runs properly: 
<br />
To ensure that this script properly works please go to the /etc/security/pwquality file in your Ubuntu system, and delete the number signs on the lines with the variables "ocredit" and "difolk".  <br />
Also ensure that whoever runs this script is a user with root privileges, as most of these configuartions require the use of Linux's sudo command (which is a command that allows us to execute system commands with root privileges).  
