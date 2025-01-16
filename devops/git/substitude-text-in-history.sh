#!/bin/bash

# the substitions are listed line by line, with the format:
# specificstring==>specificsubstitution
# regex:old==>new
# regex:password=\w+==>password=3x4mpl3!

# BFG reverts its changes in the HEAD commit so that the current files are unchanged
touch dummy & git add dummy
git commit -m 'Empty commit'

# rewrite the whole git history
java -jar bfg.jar --replace-text ../substitutions.txt .

# ignore the revert commit, which does not contain any meaningful changes
git reset HEAD^
git restore .
