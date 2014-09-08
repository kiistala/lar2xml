file=$1
./id-pid_and_singleXmls_to_xml.py Unzipped_$file > Unzipped_$file/combined_$file.xml

echo "All combined:"
wc -l Unzipped_$file/combined_$file.xml
echo "Checking XML:"
xmllint --noout Unzipped_$file/combined_$file.xml
