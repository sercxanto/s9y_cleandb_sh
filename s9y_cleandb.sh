#!/bin/sh
#
#    s9y_cleandb.sh optionFile
#
#    Cleans s9y spamblocklog and visitor databases so that contain
#    only the logs of the last n days
#
#    Copyright (C) 2010 Georg Lutz <georg AT NOSPAM georglutz DOT de>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.


# Provide option file as first parameter
myOptionFile=$1
# Option file should look at least like the following
#
# [client]
# database=your_s9y_dbname
# user=your_s9y_db_username
# password=your_s9y_db_password
#
# According to mysql documenation this is currently the only safe way to
# pass credentials to the mysql client program


daysToKeep=100

# Prevent mysql client to record history file
MYSQL_HISTFILE=/dev/null

dbPrefix="serendipity"

spamblocklog_count="SELECT count(*) FROM ${dbPrefix}_spamblocklog"
spamblocklog_count_delete="SELECT count(*) FROM ${dbPrefix}_spamblocklog WHERE timestamp < ( unix_timestamp() - $daysToKeep*24*60*60 )"
spamblocklog_delete="DELETE FROM ${dbPrefix}_spamblocklog WHERE timestamp < ( unix_timestamp() - $daysToKeep*24*60*60 )"

visitors_count="SELECT count(*) FROM ${dbPrefix}_visitors"
visitors_count_delete="SELECT count(*) FROM ${dbPrefix}_visitors WHERE unix_timestamp(concat(day,' ',time)) < ( unix_timestamp() - $daysToKeep*24*60*60 )"
visitors_delete="DELETE FROM ${dbPrefix}_visitors WHERE unix_timestamp(concat(day,' ',time)) < ( unix_timestamp() - $daysToKeep*24*60*60 )"

mysql="mysql --defaults-file=$myOptionFile --batch --silent"


echo "$spamblocklog_count: "
$mysql --execute "$spamblocklog_count"
echo

echo "$spamblocklog_count_delete: "
$mysql --execute "$spamblocklog_count_delete"
echo

echo "$spamblocklog_delete"
$mysql --execute "$spamblocklog_delete"
echo


echo "$visitors_count: "
$mysql --execute "$visitors_count"
echo

echo "$visitors_count_delete: "
$mysql --execute "$visitors_count_delete"
echo

echo "$visitors_delete"
$mysql --execute "$visitors_delete"
echo

