# STIGS-Config-UBUTU-20.04 Final Project
This script checks to see if an Ubuntu 20.04 (Focal Fossa) 20.04 machine meets 6 of the  Department of Defense's STIG configruations to ensure our machines meets the Department of Defense's security standards for Ubuntu 20.04. After the script has finished its configuration checklist the script will automatically reboot the system to enforce all the new configuration changes. <br />


This script will configure the following STIGs for Ubuntu 20.04 with the main commands to check to see whether your system is complaint to DoD standards: <br />
1. UBTU-20-010004 - Checks to see if GUI session lock is enabled. <br />
   Code to check configuration : " sudo gsettings get org.gnome.desktop.screensaver lock-enabled " <br />
2. UBTU-20-010055 - Checks to see if Ubuntu requires a complex password with at least 1 special character. <br />
   Code to check configuration : " grep -i "ocredit" /etc/security/pwquality.conf| cut -d " " -f 3 " <br />
3. UBTU-20-010053 - Checks to see if the minimum password length for users is 8 characters or longer. <br />
   Code to check configuration : " grep -i "difok" /etc/security/pwquality.conf | cut -d " " -f 3 " <br />
4. UBTU-20-010454 - Checks to see if the application firewall is enabled. <br />
   Code to check configuration :  " systemctl status ufw.service | grep -i "active:" " <br />
5. UBTU-20-010439 - Checks to see if the Ubuntu system is configured to use the AppArmor tool. <br />
   Code to check configuration : " sudo dpkg -l| grep apparmor| sort -u| cut -d " " -f 3| grep -w apparmor " <br />
9. UBTU-20-010439 - Checks to see if the system does not allow someone to directly login to the root user. <br />
    Code to check configuration : " sudo passwd -S root| cut -d " " -f 2 " <br />
<br />
Please follow the following guidlines for the script to ensure it runs properly (Please note that these guidelines are also in the script):  <br />
1. To ensure that this script properly works please go to the /etc/security/pwquality.conf file in your Ubuntu system, and delete the number signs on the lines in the file with the variables "ocredit" and "difolk".  <br />
2. Also ensure that whoever runs this script is a user with root privileges, as most of these configuartions require the use of Linux's sudo command (which is a command that allows us to execute system commands with root privileges). <br />
