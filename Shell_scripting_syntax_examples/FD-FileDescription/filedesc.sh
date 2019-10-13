#!/bin/bash
# demo of reading and writing   to a file using a file descriptor

echo "Enter a file name to read:"
read FILE

#Read and write to file, assing to file descriptor to file. Open for read and write
exec 5<>$FILE


# Redirect File input to while
while read -r SUPERHERO;
do
    echo "SuperHero name: $SUPERHERO"
done <&5

# write something to file descriptor
echo "File was read on: `date`" >&5

sleep 60
# Close file
exec 5>&-