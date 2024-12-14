#!/bin/bash
# single file: image, software, (mp4) video, text
# todo: audio, data
# Run this script: ". ../how.sh" -- see https://superuser.com/questions/1381398/changing-directory-in-script-doesnt-change-directory-why

# Get file path
read -p "file: " file
file=$(echo "$file" | sed "s/^file:\/\///g")

# Get filename
filenobase=$(echo $file | sed "s/.*\///g")

# Get name of current folder
dirnobase="$(pwd | sed "s/.*\///g")"

# Get title
read -p "title: " title
titlesafe="$(echo -n "$title" | xxd -ps | tr -d \\n | perl -pE "s/(..)/\\\\&#x00\1;/g")"

# Get description
read -p "desc: " desc
descsafe="$(echo -n "$desc" | xxd -ps | tr -d \\n | perl -pE "s/(..)/\\\\&#x00\1;/g")"

# Get tags
read -p "tags: " tags

# Get media type
read -p "type ([t]ext,[v]ideo,[i]mage,[d]ata,[a]udio,[s]oftware,[w]eb): " type
type=$(echo $type | sed "s/^t$/text/g"); type=$(echo $type | sed "s/^v$/video/g")
type=$(echo $type | sed "s/^i$/image/g"); type=$(echo $type | sed "s/^d$/data/g")
type=$(echo $type | sed "s/^a$/audio/g"); type=$(echo $type | sed "s/^s$/software/g")
type=$(echo $type | sed "s/^w$/web/g")

# Write file metadata to text file
TZ=UTC stat "$file" >> file_meta.txt; TZ=UTC stat -t "$file" >> file_meta.txt
filedir=$(echo $file | sed "s/\/[^\/]*$//g")
TZ=UTC stat "$filedir" >> file_meta.txt; TZ=UTC stat -t "$filedir" >> file_meta.txt

# MOVE file to current directory
date -u +%Y-%m-%dT%H:%M:%S.%NZ; mv -n "$file" .; date -u +%Y-%m-%dT%H:%M:%S.%NZ

# Write title to JSON
echo -n "{\"title\":\"$title\"," >> file_meta.json

# Write tags to JSON
echo -n "\"tags\":\"$tags\"," >> file_meta.json

# Write description to JSON
echo -n "\"description\":\"$(echo $desc | sed "s/\"/\\\\\"/g")\"," >> file_meta.json

# Write type to JSON
echo -n "\"type\":\"$type\"," >> file_meta.json

# Write folder name to JSON
echo "\"folder\":\"$dirnobase\"}" >> file_meta.json

# Copy template HTML to current folder
cp --update=none ../template.htm index.html

# If type is software or text then write: "Cannot preview file"
if [ "$type" == "software" ] || [ "$type" == "text" ]; then sed -i "s/img src=\"IMAGE1\" alt=\"\" \//b>Cannot preview file.<\/b/g" index.html; fi

# If type is video then write VIDEO element
if [ "$type" == "video" ]; then sed -i "s/img src=\"IMAGE1\" alt=\"\" \//video controls autoplay><source src=\"IMAGE1\" type=\"video\/mp4\"><\/video/g" index.html; fi

# Write title to HTML
sed -i "s/META1/$titlesafe/g" index.html

# Write image file name to HTML's IMG tag
sed -i "s/IMAGE1/.\/$filenobase/g" index.html

# Write page creation timestamp to HTML
time="$(TZ=UTC date -u +%Y-%m-%d\ %H:%M:%S)"; sed -i "s/TIME1/$time UTC/g" index.html

# Write tags, if any, to HTML
if [ ! -z "$tags" ]; then sed -i "s/<\x21--br><div>Tags/<br><div>Tags/g" index.html; sed -i "s/TAGS1<\/div-->/$tags<\/div>/g" index.html; fi

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
mkdir -p ../$indexindex; stat -t ../$indexindex/index.html || echo -e '<!DOCTYPE html><html><head><meta charset="utf-8"><title>Index of generated HTMLs</title></head><body><h1>Index of generated HTMLs</h1>\n<ul>\n<!--next-->\n</ul>\n</body></html>' >> ../$indexindex/index.html

# Write entry for this in index of index
indexinfo="$(cat file_meta.json | jq | grep -v "\"title\"\|\"folder\"" | tail -n+2 | head -n-1 | sed "s/^\s*//g" | perl -pE "s/\n/ /g" | sed "s/, $//g" | xxd -ps | tr -d \\n | perl -pE "s/(..)/\\\\&#x00\1;/g")"
sed -i "s/<\x21--next-->/<li>$dirnobase: <a href=\"..\/..\/..\/$dirnobase\">$titlesafe<\/a> - $indexinfo<\/li>\n<\x21--next-->/g" ../$indexindex/index.html

# Create next empty folder and go into it
cd ..; newemptyfolder=$(date +%s.%N); mkdir $newemptyfolder; cd $newemptyfolder
