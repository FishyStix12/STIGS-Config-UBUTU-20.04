# STIGS-Config-UBUTU-20.04 Final Project
This script checks to see if an Ubuntu 20.04 (Focal Fossa) 20.04 machine meets 6 Department of Defense's STIG configruations to ensure our machines meet the Department of Defense's standards. 
This script will configure the following STIGs for Ubuntu 20.04:
1. UBTU-20-010004
2. UBTU-20-010055
3. UBTU-20-010053
4. UBTU-20-010454
5. UBTU-20-010439
6. UBTU-20-010439

To ensure that this script properly works please go to the /etc/security/pwquality file in your Ubuntu system, and delete the number signs on the lines with the variables "ocredit" and "difolk".  

Also ensure that whoever runs this script is a user with root privileges, as most of these configuartions require the use of Linux's sudo command (which is a command that allows us to execute system commands with root privileges).  
