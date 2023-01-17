# using a specific tool
pdfunite in-1.pdf in-2.pdf in-n.pdf out.pdf
# using ghostscript
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=out.pdf in-1.pdf in-2.pdf
# using imagemagick
convert -density 300x300 -quality 100 in-1.pdf in-2.pdf out.pdf