#! /bin/sh
find <directory> -name '*' -type f -daystart -ctime +14 -exec rm -Rf {} \;
