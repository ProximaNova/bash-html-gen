#!/bin/bash
# single file: image, software, (mp4) video, text, data
# todo: audio
# Run this script: ". ../how.sh" ( https://superuser.com/questions/1381398 )
# Option 1: no options or ". ../how.sh move" = moves file to current directory.
# Option 2: ". ../how.sh link" = makes a hardlink to file in current folder,
# only use this where source and destination are in the same storage device.
# Option 3: ". ../how.sh copy" = copies file into current directory.
# Option 4: ". ../how.sh last" = same as copy, but doesn't make a new empty folder.

# Get file path
read -p "file: " file
file="$(echo "$file" | sed "s/^file:\/\///g")"

# Get filename
filenobase="$(echo "$file" | sed "s/.*\///g")"

# Get name of current folder
dirnobase="$(pwd | sed "s/.*\///g")"

# Get title
# Safe characters: 0-9, a-z, A-Z
# Unsafe characters: not /[0-9a-zA-Z]/, such as .,/?;:'"{[}]=+-_)(*&^%$#@!`~\|<>
# Map:
# .  ,  /  ?  ;  :  "  {  [  }  ]  =  +  -  _  )  (  *  &  ^  %  $  #  @  !  `  ~  \  |  '  <  >
# 2e 2c 2f 3f 3b 3a 22 7b 5b 7d 5d 3d 2b 2d 5f 29 28 2a 26 5e 25 24 23 40 21 60 7e 5c 7c 27 3c 3e
read -p "title: " title
titlesafe="$(echo -n "$title" | perl -pE "s/\x5c/1734216500x005c1734217364/g" | sed "s/\./1734216500x002e1734217364/g" | sed "s/,/1734216500x002c1734217364/g" | sed "s/\//1734216500x002f1734217364/g" | sed "s/?/1734216500x003f1734217364/g" | sed "s/;/1734216500x003b1734217364/g" | sed "s/:/1734216500x003a1734217364/g" | sed "s/\"/1734216500x00221734217364/g" | sed "s/{/1734216500x007b1734217364/g" | sed "s/\[/1734216500x005b1734217364/g" | sed "s/}/1734216500x007d1734217364/g" | sed "s/\]/1734216500x005d1734217364/g" | sed "s/=/1734216500x003d1734217364/g" | sed "s/+/1734216500x002b1734217364/g" | sed "s/\^/1734216500x005e1734217364/g" | sed "s/%/1734216500x00251734217364/g" | sed 's/\$/1734216500x00241734217364/g' | sed "s/@/1734216500x00401734217364/g" | sed 's/!/1734216500x00211734217364/g' | sed "s/\`/1734216500x00601734217364/g" | sed "s/~/1734216500x007e1734217364/g" | sed "s/</1734216500x003c1734217364/g" | sed "s/>/1734216500x003e1734217364/g" | sed "s/|/1734216500x007c1734217364/g" | sed "s/'/1734216500x00271734217364/g" | sed "s/&/1734216500x00261734217364/g" | sed "s/#/1734216500x00231734217364/g" | sed "s/-/1734216500x002d1734217364/g" | sed "s/_/1734216500x005f1734217364/g" | sed "s/)/1734216500x00291734217364/g" | sed "s/(/1734216500x00281734217364/g" | sed "s/\*/1734216500x002a1734217364/g" | sed "s/1734216500/\\\\\&#/g" | sed "s/1734217364/;/g")"

# Get description
read -p "desc: " desc
descsafe="$(echo -n "$desc" | perl -pE "s/\x5c/1734216500x005c1734217364/g" | sed "s/\./1734216500x002e1734217364/g" | sed "s/,/1734216500x002c1734217364/g" | sed "s/\//1734216500x002f1734217364/g" | sed "s/?/1734216500x003f1734217364/g" | sed "s/;/1734216500x003b1734217364/g" | sed "s/:/1734216500x003a1734217364/g" | sed "s/\"/1734216500x00221734217364/g" | sed "s/{/1734216500x007b1734217364/g" | sed "s/\[/1734216500x005b1734217364/g" | sed "s/}/1734216500x007d1734217364/g" | sed "s/\]/1734216500x005d1734217364/g" | sed "s/=/1734216500x003d1734217364/g" | sed "s/+/1734216500x002b1734217364/g" | sed "s/\^/1734216500x005e1734217364/g" | sed "s/%/1734216500x00251734217364/g" | sed 's/\$/1734216500x00241734217364/g' | sed "s/@/1734216500x00401734217364/g" | sed 's/!/1734216500x00211734217364/g' | sed "s/\`/1734216500x00601734217364/g" | sed "s/~/1734216500x007e1734217364/g" | sed "s/</1734216500x003c1734217364/g" | sed "s/>/1734216500x003e1734217364/g" | sed "s/|/1734216500x007c1734217364/g" | sed "s/'/1734216500x00271734217364/g" | sed "s/&/1734216500x00261734217364/g" | sed "s/#/1734216500x00231734217364/g" | sed "s/-/1734216500x002d1734217364/g" | sed "s/_/1734216500x005f1734217364/g" | sed "s/)/1734216500x00291734217364/g" | sed "s/(/1734216500x00281734217364/g" | sed "s/\*/1734216500x002a1734217364/g" | sed "s/1734216500/\\\\\&#/g" | sed "s/1734217364/;/g")"

# Get tags, doesn't escape "," which is fine
read -p "tags: " tags
tagssafe="$(echo -n "$tags" | perl -pE "s/\x5c/1734216500x005c1734217364/g" | sed "s/\./1734216500x002e1734217364/g" | sed "s/\//1734216500x002f1734217364/g" | sed "s/?/1734216500x003f1734217364/g" | sed "s/;/1734216500x003b1734217364/g" | sed "s/:/1734216500x003a1734217364/g" | sed "s/\"/1734216500x00221734217364/g" | sed "s/{/1734216500x007b1734217364/g" | sed "s/\[/1734216500x005b1734217364/g" | sed "s/}/1734216500x007d1734217364/g" | sed "s/\]/1734216500x005d1734217364/g" | sed "s/=/1734216500x003d1734217364/g" | sed "s/+/1734216500x002b1734217364/g" | sed "s/\^/1734216500x005e1734217364/g" | sed "s/%/1734216500x00251734217364/g" | sed 's/\$/1734216500x00241734217364/g' | sed "s/@/1734216500x00401734217364/g" | sed 's/!/1734216500x00211734217364/g' | sed "s/\`/1734216500x00601734217364/g" | sed "s/~/1734216500x007e1734217364/g" | sed "s/</1734216500x003c1734217364/g" | sed "s/>/1734216500x003e1734217364/g" | sed "s/|/1734216500x007c1734217364/g" | sed "s/'/1734216500x00271734217364/g" | sed "s/&/1734216500x00261734217364/g" | sed "s/#/1734216500x00231734217364/g" | sed "s/-/1734216500x002d1734217364/g" | sed "s/_/1734216500x005f1734217364/g" | sed "s/)/1734216500x00291734217364/g" | sed "s/(/1734216500x00281734217364/g" | sed "s/\*/1734216500x002a1734217364/g" | sed "s/1734216500/\\\\\&#/g" | sed "s/1734217364/;/g")"

# Get media type
read -p "type ([t]ext,[v]ideo,[i]mage,[d]ata,[a]udio,[s]oftware,[w]eb): " type
type=$(echo $type | sed "s/^t$/text/g"); type=$(echo $type | sed "s/^v$/video/g")
type=$(echo $type | sed "s/^i$/image/g"); type=$(echo $type | sed "s/^d$/data/g")
type=$(echo $type | sed "s/^a$/audio/g"); type=$(echo $type | sed "s/^s$/software/g")
type=$(echo $type | sed "s/^w$/web/g")

# Write file metadata to text file
TZ=UTC stat "$file" >> file_meta.txt; TZ=UTC stat -t "$file" >> file_meta.txt
filedir="$(echo "$file" | sed "s/\/[^\/]*$//g")"
TZ=UTC stat "$filedir" >> file_meta.txt; TZ=UTC stat -t "$filedir" >> file_meta.txt

# Check if an argument is provided
if [ "$1" == "move" ]; then
    date -u +%Y-%m-%dT%H:%M:%S.%NZ; mv -n "$file" .; date -u +%Y-%m-%dT%H:%M:%S.%NZ
elif [ "$1" == "link" ]; then
    # Make a hardlink to the file in current directory
    # WARNING: will result in "ln: failed to create hard link ./file => /path/file: Invalid cross-device link"
    # if the source and destination are two different storage devices, like to different HDDs
    date -u +%Y-%m-%dT%H:%M:%S.%NZ; ln "$file" "./$filenobase"; date -u +%Y-%m-%dT%H:%M:%S.%NZ
elif [ "$1" == "copy" ] || [ "$1" == "last" ]; then
    date -u +%Y-%m-%dT%H:%M:%S.%NZ; cp --update=none "$file" "./$filenobase"; date -u +%Y-%m-%dT%H:%M:%S.%NZ
else
    # No argument provided, default is to MOVE file to current directory
    date -u +%Y-%m-%dT%H:%M:%S.%NZ; mv -n "$file" .; date -u +%Y-%m-%dT%H:%M:%S.%NZ
fi

# Write title to JSON
echo -n "{\"title\":\"$(echo $title | sed "s/\"/\\\\\"/g")\"," >> file_meta.json

# Write tags to JSON
echo -n "\"tags\":\"$(echo $tags | sed "s/\"/\\\\\"/g")\"," >> file_meta.json

# Write description to JSON
echo -n "\"description\":\"$(echo $desc | sed "s/\"/\\\\\"/g")\"," >> file_meta.json

# Write type to JSON
echo -n "\"type\":\"$type\"," >> file_meta.json

# Write folder name to JSON
echo "\"folder\":\"$dirnobase\"}" >> file_meta.json

# Copy template HTML to current folder
cp --update=none ../template.htm index.html

# If type is software, text, or data then write: "Cannot preview file"
if [ "$type" == "software" ] || [ "$type" == "text" ] || [ "$type" == "data" ]; then sed -i "s/img src=\"IMAGE1\" alt=\"\" \//b>Cannot preview file.<\/b/g" index.html; fi

# If type is video then write VIDEO element
if [ "$type" == "video" ]; then sed -i "s/img src=\"IMAGE1\" alt=\"\" \//video controls autoplay><source src=\"IMAGE1\" type=\"video\/mp4\"><\/video/g" index.html; fi

# Write title to HTML
sed -i "s/META1/$titlesafe/g" index.html

# Write image file name to HTML's IMG tag
sed -i "s/IMAGE1/.\/$filenobase/g" index.html

# Write page creation timestamp to HTML
time="$(TZ=UTC date -u +%Y-%m-%d\ %H:%M:%S)"; sed -i "s/TIME1/$time UTC by <a href=\"..\/how.sh\">bash-html-gen<\/a>/g" index.html

# Write tags, if any, to HTML
if [ ! -z "$tags" ]; then sed -i "s/<\x21--br><div>Tags/<br><div>Tags/g" index.html; sed -i "s/TAGS1<\/div-->/$tagssafe<\/div>/g" index.html; fi

# Variables for index of index
indexindex="$(date -u +%Y/%m/%d)"
indexindexsafe=$(echo $indexindex | sed "s/\//\\\\\//g")

# Write description, if any, to HTML
if [ ! -z "$desc" ]; then sed -i "s/<\x21--br><div>Description/<br><div>Description/g" index.html; sed -i "s/DESC1<\/div-->/$descsafe<\/div>/g" index.html; fi

# Write media type to HTML
sed -i "s/<\x21--br><div>Type/<br><div>Type/g" index.html
sed -i "s/TYPE1<\/div-->/$type<\/div>/g" index.html

# Write folder name to HTML, and write index of index link to HTML
if [ ! -z "$dirnobase" ]; then sed -i "s/<\x21--br><div>In folder/<br><div>In folder/g" index.html; sed -i "s/DIR1<\/div-->/$dirnobase<\/div><div>In index | <a href=\"..\/$indexindexsafe\">..\/$indexindexsafe<\/a><\/div>/g" index.html; fi

# Create index of index for today if that folder and file doesn't exist
mkdir -p ../$indexindex; stat -t ../$indexindex/index.html || echo -e '<!DOCTYPE html><html><head><meta charset="utf-8"><title>Index of generated HTMLs</title></head><body><h1>Index of generated HTMLs</h1>\n<ul><li><a href="..">.. [go up one folder]</a></li>\n<!--next-->\n</ul>\n</body></html>' >> ../$indexindex/index.html

# Write entry for this in index of index
indexinfo="$(cat file_meta.json | jq | grep -v "\"title\"\|\"folder\"" | tail -n+2 | head -n-1 | sed "s/^\s*//g" | perl -pE "s/\n/ /g" | sed "s/, $//g" | perl -pE "s/\x5c/1734216500x005c1734217364/g" | sed "s/\./1734216500x002e1734217364/g" | sed "s/,/1734216500x002c1734217364/g" | sed "s/\//1734216500x002f1734217364/g" | sed "s/?/1734216500x003f1734217364/g" | sed "s/;/1734216500x003b1734217364/g" | sed "s/:/1734216500x003a1734217364/g" | sed "s/\"/1734216500x00221734217364/g" | sed "s/{/1734216500x007b1734217364/g" | sed "s/\[/1734216500x005b1734217364/g" | sed "s/}/1734216500x007d1734217364/g" | sed "s/\]/1734216500x005d1734217364/g" | sed "s/=/1734216500x003d1734217364/g" | sed "s/+/1734216500x002b1734217364/g" | sed "s/\^/1734216500x005e1734217364/g" | sed "s/%/1734216500x00251734217364/g" | sed 's/\$/1734216500x00241734217364/g' | sed "s/@/1734216500x00401734217364/g" | sed 's/!/1734216500x00211734217364/g' | sed "s/\`/1734216500x00601734217364/g" | sed "s/~/1734216500x007e1734217364/g" | sed "s/</1734216500x003c1734217364/g" | sed "s/>/1734216500x003e1734217364/g" | sed "s/|/1734216500x007c1734217364/g" | sed "s/'/1734216500x00271734217364/g" | sed "s/&/1734216500x00261734217364/g" | sed "s/#/1734216500x00231734217364/g" | sed "s/-/1734216500x002d1734217364/g" | sed "s/_/1734216500x005f1734217364/g" | sed "s/)/1734216500x00291734217364/g" | sed "s/(/1734216500x00281734217364/g" | sed "s/\*/1734216500x002a1734217364/g" | sed "s/1734216500/\\\\\&#/g" | sed "s/1734217364/;/g")"
sed -i "s/<\x21--next-->/<li>$dirnobase: <a href=\"..\/..\/..\/$dirnobase\">$titlesafe<\/a> - $indexinfo<\/li>\n<\x21--next-->/g" ../$indexindex/index.html

# Create next empty folder and go in to it
if [ ! "$1" == "last" ]; then
    cd ..; newemptyfolder=$(date +%s.%N); mkdir $newemptyfolder; cd $newemptyfolder
fi
