#!/usr/bin/env bash

#if [[ "$1" == '' ]] || [[ "$1" == '--help' ]]
#then
#	echo "$0 [channel id] [slack token]"
#	exit 0
#fi

SLACK_CHANNEL_ID=
SLACK_TOKEN=

SLACK_ICON=':slack:'
MY_HOSTNAME="$(cat /etc/hostname)"

OUTFILE='/tmp/lynis-audit.txt'
OUTFILE2='/tmp/lynis-audit2.txt'
ALL_INFO='/tmp/all_info.txt'

lynis audit system --cronjob > $ALL_INFO
cat $ALL_INFO | grep -Pzo '.*Warnings(.*\n)*' > "$OUTFILE"
cat $ALL_INFO | grep -Pzo '.*Suggestions(.*\n)*' > "$OUTFILE2"

if [ -s $OUTFILE ]
then
	
	LYNIS_WARNINGS="$(cat $OUTFILE)"
else
	
	LYNIS_WARNINGS="$(cat $OUTFILE2)"
fi


curl -F "content=$LYNIS_WARNINGS" -F "initial_comment=lynis report for $MY_HOSTNAME" -F channels="$SLACK_CHANNEL_ID" -F token="$SLACK_TOKEN" https://slack.com/api/files.upload

rm "$OUTFILE" 
rm "$OUTFILE2" 
rm "$ALL_INFO" 
