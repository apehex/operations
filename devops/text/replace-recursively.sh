# ignore the .git directory entirely
find ./ \
    \( -type d -name .git -prune \) -o \
    -type f -print0 |
    xargs -0 sed -i 's/before/after/g'

# using Perl
perl -p -i -e 's/oldstring/newstring/g' `grep -ril oldstring *`

perl -p -i -e 's/industrious.optimize/engineering.optimize/g' `grep -ril 'industrious.optimize' industrious`
