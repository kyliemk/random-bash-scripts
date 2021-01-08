#!/bin/bash

# makes sure path to copy to passed in
if [[ $1 == "" ]]
then
  echo "Please pass in the path to the directory where you'd like the files to be copied to. (ex: ./backup_modified_files.sh /path/to/somewhere_else)"
  exit
elif [ ! -d "$1" ]; then
  echo "$1 could not be found"
  exit
fi

# designed to be run as cron job weekly. Looks at all files in directory and pushes any that have been modified in last week to specified location. Skips subdirectories

# can change it to be any amount of time by changing the value 7 to whatever number of days you want it to go back
week_ago=`date -v-7d +"%Y%m%d"`

ls -gtoT | grep -v "^total.*$" | while read x
  do
    # skips any directories
    if [[ $x != "d"* ]] ; then
      IFS=' ' read -r -a ls_line <<< "$x"
      # get date from ls in usable format for comparison
      modified_date=`date -v"${ls_line[3]}" -v"${ls_line[4]}d" -v"${ls_line[6]}y" +"%Y%m%d"`
      if [[ $modified_date -ge $week_ago ]] ; then
          echo "Copying ${ls_line[7]}"
          cp ${ls_line[7]} $1
      else
        # because ordered by modified time, as soon as it hits the first that is outside of range, it can exit since all subsequent will also be out of range
        exit
      fi
    fi
  done
  echo Finished!
