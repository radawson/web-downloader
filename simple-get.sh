#!/bin/bash
# Collects web pages from a list of URLs
# Runs as the current user
# (c) 2022 Richard Dawson

# Global Variables
let COUNT=0
DESTINATION="${HOME}/Documents/web-downloader"
DRY_RUN='false'
EXIT_STATUS='0'
SOURCE_FILE='./listofurls.txt'
VERBOSE='false'

# Functions
check_curl() {
sudo apt update
sudo apt-get -y install curl
}

check_root(){
# Check to ensure script is not run as root
if [[ "${UID}" -eq 0 ]]; then
  UNAME=$(id -un)
  printf "This script should not be run as root" >&2
  usage
fi
}

echo_out() {
  local MESSAGE="${@}"
  if [[ "${VERBOSE}" = 'true' ]]; then
    printf "${MESSAGE}\n"
  fi
}

usage() {
  echo "Usage: ${0} [-nv] [-d DESTINATION] [-f SOURCE_FILE] COMMAND" >&2
  echo "Downloads ."
  echo "-f SOURCE_FILE Use FILE for the list of URLs. Default: ./listofurls.txt."
  echo "-n		Dry run mode. Display the URLs that would have been downloaded and exit."
  echo "-v 		Verbose mode. Displays the server name before executing COMMAND."
  exit 1
}
## MAIN ##
# Check to see if running as root
check_root

# Check to see if curl is installed
check_curl

# Provide usage statement if no parameters
while getopts d:f:nv OPTION; do
  case ${OPTION} in
    d)
	# Change DESTINATION
      DESTINATION="${OPTARG}"
      echo_out "Commands will be run as super user (sudo) on remote systems"
      ;;
    f)
	# Change SOURCE_FILE
      SOURCE_FILE="${OPTARG}"
      echo_out "Server file is ${FILE}"
      ;;
    n)
	# Execute a dry run instead of downloading
      DRY_RUN='true'
      echo_out "Commands will be listed but not executed (Dry Run)"
      ;;
	v)
    # Echo commands to console
      VERBOSE='true'
      echo_out "Verbose mode on"
      ;;
    ?)
      echo "invalid option" >&2
      usage
      ;;
  esac
done

# Clear the options from the arguments
shift "$(( OPTIND - 1 ))"

# Check for destination directory
if [[ ! -d "${DESTINATION}" ]]; then
  echo_out "Creating destination directory ${DESTINATION}."
  mkdir -p "${DESTINATION}"
else
  echo_out "Destination directory ${DESTINATION} already exists."
fi

# Check for URL list file
if [[ ! -e "${SOURCE_FILE}" ]]; then
  echo "URL file ${SOURCE_FILE} does not exist" >&2
  exit 1
fi

# Loop through websites in URL list file
for WEBSITE in $(cat ${SOURCE_FILE})
# If this is a dry run, echo instead of sending
do
  echo_out "${WEBSITE}"
  FILE=$(echo "${WEBSITE}" | awk -F"//" '{print $NF}' | sed "s/\//./g")
  DESTINATION_FILE="${DESTINATION}/${FILE}"
  CURL_COMMAND="curl -fsSL ${WEBSITE} --output ${DESTINATION_FILE}"
  # print command if this is a dry run
  if [[ "${DRY_RUN}" = 'true' ]]; then
    echo "DRY RUN: ${CURL_COMMAND}"
  else
    ${CURL_COMMAND}
    CURL_EXIT_STATUS="${?}"
    # Get any non-zero exit status
    if [[ "${CURL_EXIT_STATUS}" -ne 0 ]]; then
      EXIT_STATUS="${CURL_EXIT_STATUS}"
	  let COUNT=$COUNT+1
      echo "Execution failed on ${WEBSITE}"
    fi
  fi
done

echo "File list processing complete."
if [[ "${EXIT_STATUS}" -ne 0 ]]; then
  echo "${COUNT} errors detected, exit status ${EXIT_STATUS}."
exit "${EXIT_STATUS}"