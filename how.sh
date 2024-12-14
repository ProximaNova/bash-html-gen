#!/bin/bash -i
# -i: probably the only thing is this: "utc" = "date -u +%Y-%m-%dT%H:%M:%S.%NZ"
# single file: image, software, (mp4) video
# todo: audio, data, text
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

TZ=UTC stat "$file" >> file_meta.txt; TZ=UTC stat -t "$file" >> file_meta.txt; filedir=$(echo $file | sed "s/\/[^\/]*$//g"); TZ=UTC stat "$filedir" >> file_meta.txt; TZ=UTC stat -t "$filedir" >> file_meta.txt; utc; mv -n "$file" .; utc; echo -n "{\"title\":\"$title\"," >> file_meta.json; echo -n "\"tags\":\"$tags\"," >> file_meta.json; echo -n "\"description\":\"$(echo $desc | sed "s/\"/\\\\\"/g")\"," >> file_meta.json; echo -n "\"type\":\"$type\"," >> file_meta.json; echo "\"folder\":\"$dirnobase\"}" >> file_meta.json; cp --update=none ../template.htm index.html

if [ "$type" == "software" ] || [ "$type" == "text" ]; then sed -i "s/img src=\"IMAGE1\" alt=\"\" \//b>Cannot preview file.<\/b/g" index.html; fi; if [ "$type" == "video" ]; then sed -i "s/img src=\"IMAGE1\" alt=\"\" \//video controls autoplay><source src=\"IMAGE1\" type=\"video\/mp4\"><\/video/g" index.html; fi; sed -i "s/META1/$titlesafe/g" index.html; sed -i "s/IMAGE1/.\/$filenobase/g" index.html; time="$(TZ=UTC date -u +%Y-%m-%d\ %H:%M:%S)"; sed -i "s/TIME1/$time UTC/g" index.html; if [ ! -z "$tags" ]; then sed -i "s/<\x21--br><div>Tags/<br><div>Tags/g" index.html; sed -i "s/TAGS1<\/div-->/$tags<\/div>/g" index.html; fi

indexindex="$(date -u +%Y/%m/%d)"; indexindexsafe=$(echo $indexindex | sed "s/\//\\\\\//g"); if [ ! -z "$desc" ]; then sed -i "s/<\x21--br><div>Description/<br><div>Description/g" index.html; sed -i "s/DESC1<\/div-->/$descsafe<\/div>/g" index.html; fi; sed -i "s/<\x21--br><div>Type/<br><div>Type/g" index.html; sed -i "s/TYPE1<\/div-->/$type<\/div>/g" index.html; if [ ! -z "$dirnobase" ]; then sed -i "s/<\x21--br><div>In folder/<br><div>In folder/g" index.html; sed -i "s/DIR1<\/div-->/$dirnobase<\/div><div>In index | <a href=\"..\/$indexindexsafe\">..\/$indexindexsafe<\/a><\/div>/g" index.html; fi

mkdir -p ../$indexindex; stat -t ../$indexindex/index.html || echo -e '<!DOCTYPE html><html><head><meta charset="utf-8"><title>Index of generated HTMLs</title></head><body><h1>Index of generated HTMLs</h1>\n<ul>\n<!--next-->\n</ul>\n</body></html>' >> ../$indexindex/index.html

indexinfo="$(cat file_meta.json | jq | grep -v "\"title\"\|\"folder\"" | tail -n+2 | head -n-1 | sed "s/^\s*//g" | perl -pE "s/\n/ /g" | sed "s/, $//g" | xxd -ps | tr -d \\n | perl -pE "s/(..)/\\\\&#x00\1;/g")"; sed -i "s/<\x21--next-->/<li>$dirnobase: <a href=\"..\/..\/..\/$dirnobase\">$titlesafe<\/a> - $indexinfo<\/li>\n<\x21--next-->/g" ../$indexindex/index.html; cd ..; newemptyfolder=$(date +%s.%N); mkdir $newemptyfolder; cd $newemptyfolder
