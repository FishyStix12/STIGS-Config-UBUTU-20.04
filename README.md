# STIGS-Config-UBUTU-20.04 Final Project
This script checks to see if an Ubuntu 20.04 (Focal Fossa) 20.04 machine meets 6 Department of Defense's STIG configruations to ensure our machines meet the Department of Defense's standards. <br />
This script will configure the following STIGs for Ubuntu 20.04:
1. UBTU-20-010004 - Checks to see if GUI session lock is enabled.
2. UBTU-20-010055 - Checks to see if Ubuntu requires a complex password with at least 1 special character.
3. UBTU-20-010053 - Checks to see if the minimum password length for users is 8 characters or longer. 
4. UBTU-20-010454 - Checks to see if the application firewall is enabled.
5. UBTU-20-010439 - Checks to see if the Ubuntu system is configured to use the AppArmor tool.
6. UBTU-20-010439 - Checks to see if the system does not allow someone to directly login to the root user. 

To ensure that this script properly works please go to the /etc/security/pwquality file in your Ubuntu system, and delete the number signs on the lines with the variables "ocredit" and "difolk".  

Also ensure that whoever runs this script is a user with root privileges, as most of these configuartions require the use of Linux's sudo command (which is a command that allows us to execute system commands with root privileges).  
