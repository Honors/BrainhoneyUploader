cookie=$1
fname=README.md
enrollment=14915944
courseid=14915878
itemid=NQDB4
itemfolder=V3ZOY
title="Test Assignment"
content="<div>Hello, World</div>"

curl -H "Cookie=$cookie" \
     -d "attachments=/Resource/14915878,0/Assets%2F$fname?attachment=1,$fname,Assets%2F$fname," \
     -d "attachmentlist:Assets%2F$fname" \
     -d "enrollmentid:$enrollment"
     -d "courseid:$courseid" \
     -d "itemid:$itemid" \
     -d "itemfolder:$itemfolder" \
     -d "title=$title"
     -d "content=$content"
     https://bwhst.brainhoney.com/Editor/UpdateContent.ashx
