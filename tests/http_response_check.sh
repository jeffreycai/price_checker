#!/bin/env bash
set -e

QUERY=$1
EXPECTED=$2

txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtwht='\e[0;37m' # White

RESPONSE_CODE=$(curl -o /dev/null -s -w "%{http_code}\n" http://localhost:8080/$QUERY)
if [ "$RESPONSE_CODE" == "$EXPECTED" ]; then
  echo -e "   ${txtblu}Expected response code '$EXPECTED', actual response code '$RESPONSE_CODE'${txtwht}"
  echo -e "   ${txtgrn}PASSED${txtwht}"
  exit 0
else
  echo -e "   ${txtblu}Expected response code '$EXPECTED', actual response code '$RESPONSE_CODE'${txtwht}"
  echo -e "   ${txtred}FAILED${txtwht}"
  exit 1
fi