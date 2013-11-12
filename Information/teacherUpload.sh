#!/bin/bash
cookie=`cat $1`
fname=homescreen.png
entity=14915878
curl --form "__VIEWSTATE=/wEPDwUINTIxODU1MzhkZKgW5U0d/kbIvCytxYMA4Y4pbuCZ" \
     --form "up_file=@$fname" \
     -H "Cookie=$cookie" \
     "https://bwhst.brainhoney.com/Editor/AssetHandler.ashx?entityid=$entity&path=Assets/$fname&mediatype=all&.ASPXAUTH=$cookie"
