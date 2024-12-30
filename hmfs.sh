#!/bin/bash -i
# This script works for these years: 0000 to 9999

read -p "MFS base path: " oldmfs
read -p "update it with this CID: " newcid

oldmfs=$(echo "$oldmfs" | sed "s/\/$//g")
newcid=$(echo "$newcid" | sed "s/^\/ipfs\///g" | sed "s/^/\/ipfs\//g")

diff() {
    local f="$1"
    echo $f
    echo -n "older: "; ipfs files stat $oldmfs/$f | head -n1
    echo -n "newer: "; ipfs resolve $newcid/$f | sed "s/^\/ipfs\///g"
    ipfs files rm $oldmfs/$f
    ipfs files cp $newcid/$f $oldmfs/$f
}

diff versions.txt
diff datetime.txt
diff template.htm
diff README.md
diff LICENSE.txt
diff how.sh
diff hmfs.sh

echo "Copying folders from CID to MFS..."
ipfs ls -s --size=false $newcid | grep "/" | grep -Ev " [0-9]{4}/" | sed "s/\/$//g" | oldmfs="$oldmfs" xargs -d "\n" sh -c 'for args do c=$(echo $args | sed "s/ .*//g"); d=$(echo $args | sed "s/.* //g"); ipfs files cp /ipfs/$c $oldmfs/$d; done' _
echo "Done."

year=$(ipfs ls -s --size=false $newcid | grep -E " [0-9]{4}/" | sed "s/.* //g" | sed "s/\/$//g")
ipfs files cp $newcid/$year $oldmfs/$year
month=$(ipfs ls -s --size=false $newcid/$year | grep -E " [0-9]{2}/| [0-9]{1}/" | sed "s/.* //g" | sed "s/\/$//g")
ipfs files cp $newcid/$year/$month $oldmfs/$year/$month
day=$(ipfs ls -s --size=false $newcid/$year/$month | grep -E " [0-9]{2}/| [0-9]{1}/" | sed "s/.* //g" | sed "s/\/$//g")
ipfs files cp $newcid/$year/$month/$day $oldmfs/$year/$month/$day
