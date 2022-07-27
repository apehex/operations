# files created by automated tools like dpkg have their timestamps truncated to the second: everything after the dot is null
find / -type f -exec stat --format='%.9Y %n' {} \; 2>/dev/null | grep -vE '000000000'
