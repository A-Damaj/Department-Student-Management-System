#!/bin/bash


function list_all {
  # List all students in alphabetical order by last name
  for file in $(ls "$student_folder"); do
    echo "$(grep -m 1 '^\w\+, \w\+' "$student_folder/$file")"
  done | sort -k2
}



count_students() {
  echo ""

  # Get a list of all majors in the files
  majors=$(grep -oP 'Major:\s*\S+ ?(\w+)?' CurrentStudents/*  | cut -d " " -f 2- | sort | uniq | tr -s ' ' '_')

  # Iterate over each major and count the number of students
  for major in $majors; do
    major=$(echo $major | tr -s '_' ' ')
    count=$(grep -l "Major:\s*$major" "$student_folder"/* | wc -l)
    echo "$count students majoring in $major"
  done | sort -rn
}




display_info() {
  echo ""
  read -p "Enter the filename to save the student info to: " filename
  echo "" > "$filename"
  for file in $(ls "$student_folder"); do
    student_info=$(grep -oP '^[\w-]+, [\w-]+,\K\s*\d+' "$student_folder"/"$file")
    gpa=$(grep -oP 'GPA:\s*\d+\.\d+' "$student_folder"/"$file")
    major=$(grep -oP 'Major:\s*\S+' "$student_folder"/"$file")
    echo "$student_info, $gpa, $major" >> "$filename"
    echo "$student_info, $gpa, $major"
  done
}




function delete_student {


}


function backup  {


}

# Define variables
student_folder="CurrentStudents"   # directory where student files are stored
backup_folder="CurrentStudentsBackup"   # name of backup folder
date=$(date +%d_%B_%y)   # variable for storing the current date in the format day_FullMonthName_Last2DigitsYear

while true; do   # start an infinite loop
    echo ""   # print an empty line

    # Print the menu options and prompt user to choose an option
    # The "select" command displays a numbered list of options and takes care of user input validation
    PS3="Please choose an option (1-6): "   # Set the PS3 environment variable prompt to display a message for selecting an option from the menu
    options=("List all students" "Display student information" "Count students" "Delete a student" "Backup student files" "Exit")
    select choice in "${options[@]}"; do
        case "$choice" in
            "List all students")
                list_all   # if choice is 1, execute list_all function
                break
                ;;
            "Display student information")
                display_info   # if choice is 2, execute display_info function
                break
                ;;
            "Count students")
                count_students   # if choice is 3, execute count_students function
                break
                ;;
            "Delete a student")
                delete_student   # if choice is 4, execute delete_student function
                break
                ;;
            "Backup student files")
                backup   # if choice is 5, execute backup function
                break
                ;;
            "Exit")
                echo "Exiting program."
                exit 0   # if choice is 6, print a message and exit the program with status code 0 (success)
                ;;
            *)   # if choice is not between 1-6, print an error message and prompt user to choose again
                echo "Invalid choice. Please choose an option from 1 to 6."
                ;;
        esac
    done
done

