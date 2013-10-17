curl --form enrollmentid=$1 \
     --form itemid=$2 \
     --form actiontype=submit \
     --form attachment=@$3 \
     --form lastpackage="" \
     --form "notes=\<div\>&nbsp;\</div\>" \
     --form wipFileDeleteFlag=""\
     -H "Host: bwhst.brainhoney.com"\
     -H "User-Agent: Brainhoney Uploader" \
     -H "Cookie: $4" \
     -H "Content-Type: multipart/form-data" \
     https://bwhst.brainhoney.com/Content/Assignment.ashx
