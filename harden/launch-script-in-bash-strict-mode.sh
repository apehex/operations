# prefix the script with
set -euxo pipefail
# whole script fails if one command fails
set -e
# print executed command names
set -x
# fail if accessing a variable that isn't predefined
set -u
# pipes fail when any command fails
set -o pipefail
# define the bash separator
IFS=$'\n\t' # usefull when iterating over strings
