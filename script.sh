#!/bin/bash
# Define variables
student_folder="CurrentStudents"
backup_folder="CurrentStudentsBackup"
date=$(date +%d_%B_%y)

while true; do
  echo ""
  read -p "Please choose an option (1-6): " choice
  case "$choice" in
    1) list_all ;;
    2) display_info ;;
    3) count_students ;;
    4) delete_student ;;
    5) backup ;;
    6) echo "Exiting program." ; break ;;
    *) echo "Invalid choice. Please choose an option from 1 to 6." ;;
  esac
done










