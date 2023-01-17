# using the metadata
exiftool -T -filename -PageCount -s3 -ext pdf 1.pdf 2.pdf
# or with manual wrangling
exiftool *.pdf | grep -ai 'page count' | cut -d':' -f2 | xargs -n1