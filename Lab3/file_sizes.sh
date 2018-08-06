#!/bin/sh

#use () to initilize array
#use {} to display array

for FILE in *; do
    NumLine=$(wc -l < "$FILE")
    if [ $NumLine -lt 10 ]; then
        SF+=($FILE)
    elif [ $NumLine -lt 100 ]; then
        MF+=($FILE)
    else
        LF+=($FILE)
    fi
done

echo "Small files: "${SF[@]}
echo "Medium-sized files: "${MF[@]}
echo "Large files: "${LF[@]}
