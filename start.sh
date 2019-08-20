#!/usr/bin/env bash
for key in $(env | grep -oP ^WALE_\([^=]+\)); do
    printenv $key > /etc/wal-e.d/env/${key#*_}
done
exec $@