#!/usr/bin/env bash

dataFolderPath=~/devops_labs/lab1/data/
dataFilePath=~/devops_labs/lab1/data/user.db
shouldCreateDataFile="yes"
commandArg=$1

if [[ ! -f "$dataFilePath" && $commandArg != '' && $commandArg != "help" ]]
  then 
    read -p "Looks like user.db is not create yet. would you like to create the file? [yes]: " "$shouldCreateDataFile"

    if [[ "$shouldCreateDataFile" == "yes" ]]
      then
        touch $dataFilePath
    fi
fi

if [[ -z $commandArg || $commandArg == "help" ]] 
  then 
    echo "add - add new line to db"
    echo "backup - makes file backup"
    echo "find - find info"
    echo "help - prints availiable commands"
fi

handleValidation() {
  if ! [[ $1 =~ ^[a-zA-Z]+$ ]] 
    then 
      echo "$2 must consist of only lattins letters"
      exit 1
  fi
}

handleAddCommand() {
  read -p "Enter new username: " username
  handleValidation "$username" "username" 
  
  read -p "Enter new role: " role 
  handleValidation "$role" "role" 

  echo "$username, $role" >> "$dataFilePath"
}

handleBackupCommand() {
  touch $dataFolderPath"`date +"%d-%m-%Y"`"-user.db  
}

handleRestoreCommand() {
  backupFilePath=$(find $dataFolderPath -name "*-user.db")
  backupFileName=$(basename "$backupFilePath") 

  if [[ $backupFileName != "" ]]
    then
      rm $dataFilePath 
      mv $dataFolderPath/$backupFileName $dataFilePath
  fi
}

createArgumentHandler() {
  if [[ $commandArg == $1 ]]
    then
      $2
  fi 
}

createArgumentHandler "backup" handleBackupCommand
createArgumentHandler "add" handleAddCommand 
createArgumentHandler "restore" handleRestoreCommand 

