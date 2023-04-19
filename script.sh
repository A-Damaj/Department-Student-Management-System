#!/bin/bash


# Define variables
student_folder="CurrentStudents"  # directory where student files are stored
backup_folder="CurrentStudentsBackup"  # name of backup folder
date=$(date +%d_%B_%y)  # variable for storing the current date in the format day_FullMonthName_Last2DigitsYear

while true; do  # start an infinite loop
    echo ""  # print an empty line
    read -p "Please choose an option (1-6): " choice  # prompt user to enter a choice from the menu
    case "$choice" in  # use case statement to execute a specific function based on user's choice
        1) list_all ;;  # if choice is 1, execute list_all function
        2) display_info ;;  # if choice is 2, execute display_info function
        3) count_students ;;  # if choice is 3, execute count_students function
        4) delete_student ;;  # if choice is 4, execute delete_student function
        5) backup ;;  # if choice is 5, execute backup function
        6) echo "Exiting program." ; break ;;  # if choice is 6, print a message and break out of the loop to exit the program
        *) echo "Invalid choice. Please choose an option from 1 to 6." ;;  # if choice is not between 1-6, print an error message
    esac  # end the case statement
done  # end the infinite loop
