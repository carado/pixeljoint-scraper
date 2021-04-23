#!/bin/bash
set -e
shopt -s expand_aliases

exts="png gif jpg jpeg PNG GIF JPG JPEG webp WEBP"

alias wget='wget -nv --random-wait'

clean-utf8() {
	iconv -f utf-8 -t utf-8 -c "$1" > .filtered
	mv .filtered "$1"
}

for artist_url in $(cat list | shuf)
do
	echo -ne "\e[0;35m"
	wget "$artist_url" -O .tmp.htm
	echo -ne "\e[0m"
	clean-utf8 .tmp.htm
	artist="$(echo "$artist_url"|sed -n 's/^.*\/\([0-9]*\)\.htm/\1/p')"
	name="$(cat .tmp.htm | sed -n 's/^.*<title>Pixel Artist - \([^<]*\)<\/title>.*$/\1/p')"
	dir="$artist $name"
	mkdir -p "$dir"
	(
		cd "$dir"
		page=1
		while true
		do
			echo -ne '\t'
			wget "https://pixeljoint.com/pixels/profile_tab_icons.asp?id=$artist&pg=$page" -O .page.htm
			clean-utf8 .page.htm
			if grep -q 'No icons found.' .page.htm
			then
				break
			fi
			cat .page.htm \
				| grep -o "href='\/pixelart\/[0-9]*.htm'" \
				| uniq \
				| grep -o '[0-9]*' \
				| while read img
			do
				for ext in $exts
				do
					if [ -e "$img.$ext" ]
					then
						#echo "$img.$ext exists"
						continue 2
					fi
				done
				#echo "$img doesn't exist"
				echo -ne '\t\t'
				wget "https://pixeljoint.com/pixelart/$img.htm" -O .img.htm
				clean-utf8 .img.htm
				url="$(cat .img.htm | sed -n 's/^.*<meta property="og:image" content="\([^"]*\)".*$/\1/p')"
				ext="$(echo "$url" | sed 's/^.*\.\([^\.]*\)$/\1/')"
				filename="$img.$ext"
				echo -ne '\t\t\t'
				echo -n "$filename: "
				wget "$url" -O .tmp.img
				mv .tmp.img "$filename"
			done
			page="$(($page+1))"
		done
	)
done

