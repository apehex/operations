#!/bin/bash

# list all the potential leaks
gitleaks git -r /tmp/report.json /app/sources

# build a substitution mapping
jq -r '.[].Secret' < /tmp/report.json |
    grep -vi '0x' | # ignore the false positives (blockchain addresses)
    sort -u | # deduplicate
    perl -pe 's/$/==>**REDACTED**/' > /tmp/textmap.txt # concatenate into a regex

# remove the API keys from the file contents
git filter-repo --replace-text /tmp/textmap.txt .

# cleanup artifacts that may still hold the secrets
rm -rf .git/refs/original .git/logs .git/filter-branch # remove backups and logs
git for-each-ref --format='%(refname)' 'refs/original' | xargs -r -n1 git update-ref -d # remove backup refs
git reflog expire --expire=now --all # expire any remaining reflogs
git gc --prune=now --aggressive # prune unreachable objects
