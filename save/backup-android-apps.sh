#!/bin/bash

# output directory
OUTPUT=${1:-$(dirname "$0")}

# operate in the tmp dir
CACHE=$(mktemp -d)

# check whether there's a connected device

# list the package names only
adb shell pm list packages -f -3 | awk -F'=' -e '{print $NF}' > "$CACHE/packages.lst"

# loop on the packages
while IFS= read -r package; do
  # show progress
  echo "======================================== $package";
  # tidy: group the sources & config by package
  mkdir "$CACHE/$package" && cd "$CACHE/$package";
  # import the modules
  adb </dev/null shell pm path "$package" | awk -F':' -e '{print $NF}' > "$CACHE/$package/modules.lst";
  # import each module apk
  while read module; do
    # pull the apk
    adb pull "$module";
    # reverse to sources
    filename=$(echo "$module" | awk -F'/' -e '{print $NF}');
    apktool d -o "$CACHE/$package/sources/$filename" "$CACHE/$package/$filename";
  done < "$CACHE/$package/modules.lst"
done < "$CACHE/packages.lst"

# sync with the output directory
rsync -avh --update --progress "$CACHE" "$OUTPUT"

# clean tmp
rm -rf "$CACHE"
