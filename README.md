
           USER MANAGEMENT AUTOMATION PROJECT


1. PROJECT PURPOSE:

This project automates the process of creating users and groups 
on a Linux system using a simple input file. It removes the need 
to manually add users one-by-one and ensures consistent setup 
for new developer accounts.

The script:
- Reads usernames and groups from users.txt
- Creates required groups
- Creates new users
- Generates random passwords
- Creates home directories
- Saves passwords securely
- Logs all actions in a separate log file

This automation is useful for DevOps, SysOps, Linux admins,
and for onboarding multiple users quickly.


2. PROJECT FEATURES:

✓ Reads user data from users.txt  
✓ Supports Windows CRLF and Linux LF formats  
✓ Creates groups if missing  
✓ Creates users with home directories  
✓ Sets secure file permissions  
✓ Generates strong random passwords  
✓ Logs all events with timestamps  
✓ Creates a logs/ folder automatically  
✓ Works on Ubuntu, Debian, Linux Mint, Kali, WSL Ubuntu  
✓ Fully compatible with VS Code terminal  


3. PROJECT STRUCTURE:

user-management-project/
│
├── create_users.sh     → Main automation script
├── users.txt           → Input file (edit by yourself)
└── logs/               → Auto-created folder at runtime
     ├── user_management.log
     └── user_passwords.txt



4. INPUT FILE FORMAT (users.txt):

Each line must follow this structure:

username; group1,group2,group3

Example:
# New Users list
Rajendra; sudo,dev,www-data
Anil; sudo
Dharsha; dev,www-data

Rules:
- Lines starting with # are ignored
- Spaces do not matter
- Windows CRLF lines are allowed
- Empty lines are skipped

5. WHAT THE SCRIPT DOES INTERNALLY:

1) Reads each line from users.txt  
2) Cleans unwanted characters (CRLF, tabs, spaces, etc.)  
3) Extracts username and group list  
4) Creates missing groups  
5) Creates user account (if not already existing)  
6) Creates /home/username directory  
7) Sets correct ownership and permissions  
8) Generates a random 12-character password  
9) Applies password to the user  
10) Saves the password in logs/user_passwords.txt  
11) Logs every action with timestamps in logs/user_management.log  

6. SECURITY NOTES:

✓ Passwords are stored in a file with permission 600  
✓ Log file also uses permission 600  
✓ Only root (sudo) can run the script  
✓ No system folders are modified  
✓ Safe to run on training machines or labs  

7. HOW TO RUN THIS PROJECT (STEP-BY-STEP):


STEP 1: Open the project folder in VS Code

STEP 2: Make the script executable
Command:
chmod +x create_users.sh

STEP 3: Run the script with sudo
Command:
sudo ./create_users.sh

STEP 4: View generated logs
Command:
cat logs/user_management.log

STEP 5: View generated passwords
Command:
cat logs/user_passwords.txt


8. EXAMPLE LOG OUTPUT:

2025-11-13 14:55:12 - ----- Starting User Creation Process -----

2025-11-13 14:55:12 - Processing user: light

2025-11-13 14:55:12 - Created group: dev

2025-11-13 14:55:12 - Created user: light

2025-11-13 14:55:12 - Password set for light

2025-11-13 14:55:12 - ----- User Creation Process Completed -----






Project Name: User Management Automation (SysOps Challenge)
Author: Rajendra
Date: 13/11/2025
