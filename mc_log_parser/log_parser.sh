#!/bin/bash


function useage {
  echo "log_paser -l <log file name> -u <username file name> -o <output file name>"
  exit 1
}

function check_output_file {
if [ ! -e $output_file ]
then
  echo "Creating action file"
  touch $output_file
fi
if [ ! -s $output_file ]
then
  echo "Writing output file headers"
  echo "username|action|date" > $output_file
fi
}

function parse_log_file {
  mkdir temp
  grep -f $user_file $log_file > temp/user_log
  grep -v '<' temp/user_log > temp/no_chat_log
  grep -v 'whitelist' temp/no_chat_log > temp/no_chat_or_whitelist 
  grep 'Server thread/INFO' temp/no_chat_or_whitelist > temp/from_server
  grep -v 'lost connection' temp/from_server > temp/from_server_without_lost_connection
  grep -v 'logged in' temp/from_server_without_lost_connection > temp/from_server_without_lost_connection_or_logged_in
  grep -v '*' temp/from_server_without_lost_connection_or_logged_in > temp/fine_log
}

function clean_temp {
  rm -r temp/
}

function write_output {
  date=`echo $log_file | cut -d '-' -f -3`
  OIFS='$IFS'
  IFS=$'\n'
  for line in `cat temp/fine_log`
  do
    time=`echo $line | cut -d ' ' -f 1 | sed -e 's/\[\|\]//g'`
    second_half=`echo $line | cut -d ':' -f 4`
    username=`echo $second_half | cut -d ' ' -f 2`
    action=`echo $second_half | cut -d ' ' -f 3-`
    echo "$username|$action|$date $time" >>$output_file
  done
  IFS='$OIFS'
}

while getopts ":l:u:o:" opt;
do
  case $opt in
	l)
	  if [ -z $log_file ]
	  then
	    log_file=$OPTARG
	  else
	    useage
	  fi;;
	u)
	  if [ -z $user_file ]
	  then
	    user_file=$OPTARG
	  else
	    useage
	  fi;;
	o)
	  if [ -z $output_file ]
	  then
	    output_file=$OPTARG
	  else
	    useage
	  fi;;
    /?)
	  echo "-$OPTARG is not a valid option"
	  useage;;
	:)
	  echo "Option -$OPTARG requires an argument"
	  useage;;
  esac
done

if [ -z $log_file ]
then
  useage
elif [ -z $user_file ]
then
  useage
elif [ -z $output_file ]
then
  useage
fi
echo "log file = $log_file"
echo "user file = $user_file"
echo "output file = $output_file"

check_output_file
parse_log_file
write_output
clean_temp
