#!/bin/bash

# check the crontab
crontab -e

# look for files created by hand (the timestamp is filled up to the nanosecond)
find / -type f -exec stat --format='%.9Y %n' {} \; 2>/dev/null | grep -vE '000000000'
