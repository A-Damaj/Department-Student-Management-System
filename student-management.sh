#!/bin/bash


# Define a function called list_all that lists all students in alphabetical order by last name
function list_all {
  # Loop through all files in the student folder
  for file in $(ls "$student_folder"); do
    # Use grep to search for the first occurrence of a pattern that matches a last name followed by a comma, a space, and a first name in the student file
    # -m 1 specifies to stop searching after the first match is found (improves performance)
    # "$student_folder/$file" specifies the file path to search
    # The output of grep is passed to echo, which prints the result to the console
    echo "$(grep -m 1 '^\w\+, \w\+' "$student_folder/$file")"
  done | sort -k2   # sort the output in ascending order based on the second column (i.e., the first name)
}


# Define the count_students function
count_students() {

  # Print a blank line for formatting
  echo ""

  # Get a list of all majors in the CurrentStudents directory
  # -oP : Use Perl-compatible regular expressions
  # grep -oP 'Major:\s*\S+ ?(\w+)?' CurrentStudents/*
  #   : Search for the pattern "Major:" followed by optional whitespace, followed by one or more non-whitespace characters,
  #     followed by an optional space and more words (meant to capture majors that are composed of 2 words).
  # cut -d " " -f 2-
  #   : Use a space as the delimiter and output all fields starting from the second field.
  # sort : Sort the list alphabetically
  # uniq : Remove any duplicates
  # tr -s ' ' '_'
  #   : Replace any spaces with underscores
  majors=$(grep -oP 'Major:\s*\S+ ?(\w+)?' CurrentStudents/*  | cut -d " " -f 2- | sort | uniq | tr -s ' ' '_')

  # Iterate over each major
  for major in $majors; do
    # Replace any underscores with spaces
    major=$(echo $major | tr -s '_' ' ')

    # Count the number of students with the current major
    # grep -l "Major:\s*$major" "$student_folder"/*
    #   : Search for the pattern "Major:" followed by optional whitespace, followed by the current major.
    # wc -l : Count the number of lines returned by grep
    count=$(grep -l "Major:\s*$major" "$student_folder"/* | wc -l)

    # Print the count of students for the current major
    echo "$count students majoring in $major"
  done | sort -rn # Sort the output in reverse numerical order
}

# Define the display_info function
display_info() {
  # Display a blank line for formatting
  echo ""

  # Prompt the user to enter the filename to save the student info to
  read -p "Enter the filename to save the student info to: " filename

  # Create a blank file with the specified filename
  echo "" > "$filename"

  # Loop through each file in the student_folder directory
  for file in $(ls "$student_folder"); do
    # Use grep to extract the student ID from the file and save it to the variable "student_info"
    student_info=$(grep -oP '^[\w-]+, [\w-]+,\K\s*\d+' "$student_folder"/"$file")

    # Use grep to extract the student's GPA from the file and save it to the variable "gpa"
    gpa=$(grep -oP 'GPA:\s*\d+\.\d+' "$student_folder"/"$file")

    # Use grep to extract the student's major from the file and save it to the variable "major"
    major=$(grep -oP 'Major:\s*\S+' "$student_folder"/"$file")

    # Write the student info, GPA, and major to the specified file, separated by commas
    echo "$student_info, $gpa, $major" >> "$filename"

    # Display the student info, GPA, and major in the terminal
    echo "$student_info, $gpa, $major"
  done
}

# Function to delete a student from the database
delete_student() {
  echo ""

  # Prompt the user to enter the ID of the student to be deleted
  read -p "Enter the ID of the student to delete: " id

  # Check if ID is in valid format (9 digits)
  if [[ ! "$id" =~ ^[0-9]{9}$ ]]; then
    echo "Error: Invalid student ID format. Must be 9 digits long."
    return
  fi

  # Search for student file with matching ID in the student folder
  # The 'find' command searches the student_folder directory for files of type 'f' (regular file)
  # with the extension '.txt' and containing the student ID (matched using grep)
  # If a match is found, the file path is returned and stored in 'student_file'
  student_file=$(find "$student_folder" -type f -name "*.txt" -exec grep -q "$id" '{}' \; -print)

  # Check if student file was found
  if [[ -z "$student_file" ]]; then
    echo "Error: No student with ID $id found in database."
    return
  fi

  # Confirm deletion with user before proceeding
  read -p "Are you sure you want to delete the file for student $id? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then
    echo "Deletion cancelled."
    return
  fi

  # Delete the student file
  rm "$student_file"
  echo "File for student $id successfully deleted."
}


backup() {
  # Create backup folder with current date
  backup_folder_name="$backup_folder.$date"
  mkdir -f "$backup_folder_name"
  cp -r "$student_folder" "$backup_folder_name"
  echo "Backup created in folder $backup_folder_name"
  exit 0
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

