#!/bin/sh

# Command
MYSQL=`which mysql`
SED=`which sed`

# Option
while getopts h:u:p OPT
do
  case $OPT in
    "h" ) FLG_H="TRUE" ; HOST="$OPTARG" ;;
    "u" ) FLG_U="TRUE" ; USER="$OPTARG" ;;
    "p" ) FLG_P="TRUE" ; stty -echo ; echo -n 'Password:' ; read PASSWORD ; stty echo ; echo ;;
  esac
done
shift `expr $OPTIND - 1`

# Database
DATABASE="$1"

OPTION=""
# Host
if [ x${FLG_H} == 'xTRUE' ]
then
  OPTION="${OPTION} -h${HOST}"
fi

# User
if [ x${FLG_U} == 'xTRUE' ]
then
  OPTION="${OPTION} -u${USER}"
fi

# Password
if [ x${FLG_P} == 'xTRUE' ]
then
  OPTION="${OPTION} --password=${PASSWORD}"
fi

# Format(tsv to texttile)
FORMAT="${SED} -e s/\(^\|$\|\t\)/\|/g"

COMMAND="${MYSQL} ${OPTION} ${DATABASE}"
TABLES=`echo 'show tables;' | ${COMMAND} -N`

# Show table status.
echo "|\18. ${DATABASE}|"
echo 'show table status;' | ${COMMAND} | ${FORMAT}
echo; echo

# Show table description.
for TABLE in ${TABLES}
do
  echo "|\6. ${TABLE}|"
  echo "desc ${TABLE};" | ${COMMAND} | ${FORMAT}
  echo
done

exit 0
