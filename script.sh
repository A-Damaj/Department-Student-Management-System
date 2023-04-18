#!/bin/bash


while true; do
  # Prompt the user to enter a menu choice
  read -p "Enter choice: " choice

  case "$choice" in
  1) # List all students
    list_all
    ;;
  2) # Display student info
    display_info
    ;;
  3) # Count students by major
    count_students
    ;;
  4) # Delete a student file
    delete_student
    ;;
  5) # Create a backup of the data directory
    backup
