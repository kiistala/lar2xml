#!/bin/bash

DIR=$1

IDPID=$DIR/id-pid.tsv
DESTDIR=$DIR/SingleXmls
mkdir $DESTDIR
IMPDIR=$DIR/ImportXmls
mkdir $IMPDIR

cat $IDPID | while read line
do
  id=$(echo "$line" | cut -f1)
  pid=$(echo "$line" | cut -f2)

  gdir=$(find $DIR/groups/*/layouts -iname $id -print0)
  file="$gdir/layout.xml"

  if [ ! -e $file ]
  then
    echo "File not found: $file – Abort!"
    exit 1
  fi

  # print every xml to file named after its id:
  DEST="$DESTDIR/$id.xml"
  touch $DEST
  cat $file > $DEST

  # fix the xml
  sed -i -e 's/^<?xml.*?>//' -e 's/CDATA\[<?xml.*>\(.*\)<\/name><\/root>\]/CDATA[\1]/' $DEST
  # xsltproc?
  IMPXML=$IMPDIR/$id.xml
  xsltproc idXml_to_impXmlPageXml.xsl $DEST > $IMPXML

  # just to see the speed
  echo $DEST
done

