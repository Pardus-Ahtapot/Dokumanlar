#!/bin/bash
### DIR degiskeni degistirilerek istenilen dosyalarin bulundugu dizin verilmeli

DIR="/opt/docs/ahtapot-docs/docs"
[ "$DIR" == "" ] && DIR="." 
OLDIFS=$IFS
IFS=$'\n'
mdler=($(find $DIR -type f -name *.md))
pdfler=($(find $DIR -type f -name "*.pdf"))
IFS=$OLDIFS
mdsayisi=${#mdler[@]}
pdfsayisi=${#pdfler[@]}
for (( j=0; j<${pdfsayisi}; j++ ));
do
  rm ${pdfler[$j]}
done
for (( i=0; i<${mdsayisi}; i++ ));
do
  pandoc --toc -f markdown+grid_tables+table_captions -o ${mdler[$i]%%.*}.pdf ${mdler[$i]} --latex-engine=xelatex
done
