#!/bin/bash
#
# Implements the function of sending a message to mail about 
# authorization events in Linux OS.


display_help() {
  echo "Usage: $0 -p period -r recipient"
  echo "Options:"
  echo "  -h                 		Display this help message."
  echo "  -p <period> *Requiered*       Set the time period for sending logs (e.g., 1h, 12h)."
  echo "  -r <recipient> *Requiered*    Set the recipient email address."
}


check_period_limit() {
  # Check if the period is more than 7 days (168 hours)

  local numeric_value="$1"

  if [ "$numeric_value" -gt 168 ]; then
    echo "ERROR: The specified period is more than 7 days (168 hours)."
    exit 1
  fi
}


validate_period() {
  local period="$1"

  if [[ "$period" =~ ^([1-9][0-9]*)([h])$ ]]; then
    numeric_value="${BASH_REMATCH[1]}"

    check_period_limit "$numeric_value"
  else
    echo "ERROR: Invalid time period format. Please use a number followed by 'h' (e.g., 1h, 12h)."
    exit 1
  fi
}


validate_email_address() {
  local email_recipient="$1"
  local email_validator="^(([A-Za-z0-9]+((\.|\-|\_|\+)?[A-Za-z0-9]?)*[A-Za-z0-9]+)|[A-Za-z0-9]+)@(([A-Za-z0-9]+)+((\.|\-|\_)?([A-Za-z0-9]+)+)*)+\.([A-Za-z]{2,})+$"

  if ! [[ $email_recipient =~ ${email_validator} ]]; then
 	echo "ERROR: Ivalid email address format '$email_recipient'."
	exit 1
  fi
}


send_email() {
  local email_content="$1"
  local email_subject="$2"
  local email_recipient="$3"

  echo -e "$email_content" | mail -s "$email_subject" "$email_recipient"
  echo "- Email sent successfully to $recipient at $(date +"%Y.%m.%d %H:%M:%S")."
  echo -e "- Next email will be sent at $(date -d "+$numeric_value hours" +"%Y.%m.%d %H:%M:%S").\n"
}


build_email_body() {
  local successful_logins="$1"
  local failed_logins="$2"

  local email_body=""
  
  # Check if successful_logins exist
  [ -n "$successful_logins" ] && email_body+="Successful LogIns:\n\n$successful_logins\n\n"
  
  # Check if failed_logins exist
  [ -n "$failed_logins" ] && email_body+="Failed LogIns:\n\n$failed_logins"

  # Check if no successful or failed logins exist 
  if [ -z "$successful_logins" ] && [ -z "$failed_logins" ]; then
    email_body+="No authentication logs have been produced for $numeric_value hours"
  fi

  echo "$email_body"
}


send_logs() {
  # Extracts logs using last and lastb commands

  local successful_logins=$(last -s -"$period" | grep -v "wtmp begins")
  local failed_logins=$(lastb -s -"$period" | grep -v "btmp begins")

  local email_subject="Authentication Logs for $HOSTNAME"
  local email_body="$(build_email_body "$successful_logins" "$failed_logins")"

  send_email "$email_body" "$email_subject" "$recipient"
}


while getopts ":hp:r:" flag; do
  case $flag in
  h) display_help; exit 0;;
  p) validate_period "$OPTARG"; period="$OPTARG";;
  r) validate_email_address "$OPTARG"; recipient="$OPTARG";;
  \?) echo "ERROR: Unknown flag '-$OPTARG'. Use '-h' for help"; exit 1;;
  *) echo "Invalid Option: '$OPTARG' requires an argument";;
  esac
done


# Check for missing required arguments
if [ -z "$period" ] || [ -z "$recipient" ]; then
  echo "ERROR: Missing required arguments. Use '-h' for help"
  exit 1
fi


main() {
  echo "Starting script..."
  while true; do
    send_logs
    sleep "$period"
  done
}


# Start the main logic
main
