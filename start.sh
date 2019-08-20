#!/usr/bin/env bash
for key in $(env | grep -oP ^WALG_\([^=]+\)); do
    printenv $key > /etc/wal-g.d/env/${key#*_}
done
exec $@