# using ghostscript
gs -q -sDEVICE=pdfwrite -o out.pdf -c '{1 sub neg} settransfer' -f in.pdf