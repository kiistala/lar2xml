#!/bin/bash

if [ -z $1 ]
then
  echo Usage: $0 file.lar
  exit 1
fi

if [ ! -e $1 ]
then
  echo File not found: $1
  exit 1
fi

###

LAR=$1
DIR=Unzipped_$LAR
rm -rf $DIR
mkdir $DIR
unzip -q -d $DIR $LAR

# grep -R 'friendly-url' $DIR
# grep -R 'friendly-url' $DIR | sed 's/.*.friendly-url.\(\/.*\)<.*/\1/' | sort
grep -R 'friendly-url' $DIR | sed -e 's/^.*\/\([[:digit:]]\+\)\/layout.xml:/\1	:/' -e 's/:.*.friendly-url.\(\/.*\)<.*/\1/' \
> $DIR/id-fu.txt

echo "layout.xml's with friendly-url"
wc -l $DIR/id-fu.txt

DEST=$DIR/id-pid.tsv
# rm $DEST
touch $DEST

cat $DIR/id-fu.txt | cut -f1 | while read id
do
  #prefix="$DIR/groups/*/layouts"
  #suffix='layout.xml'
  #file="$prefix/$id/$suffix"

  gdir=$(find $DIR/groups/*/layouts -iname $id -print0)
  file="$gdir/layout.xml"

  if [ ! -e $file ]
  then
    echo "File not found: $file – Abort!"
    exit 1
  fi

  parent=$(xmllint --xpath '//parent-layout-id/text()' $file)
  # print layout id and its parent's id
  echo "$id	$parent" >> $DEST
done

# use Perl to create an XML tree
# perl id-pid_to_a_tree2.pl $DIR/id-pid.tsv

# use Python to create a tree
# python id-pid_to_a_tree.py $DIR/id-pid.tsv

# exit

IDPID=$DEST
PDIR=$DIR/ParentXmls
mkdir $PDIR

cat $IDPID | while read line
do
  id=$(echo "$line" | cut -f1)
  pid=$(echo "$line" | cut -f2)

  prefix="$DIR/groups/*/layouts"
  suffix='layout.xml'
  file="$prefix/$id/$suffix"

  if [ ! -e $file ]
  then
    echo "File not found: $file – Abort!"
    exit 1
  fi

  # print every xml to a file named after its parent:
  DEST="$PDIR/$pid.xml"
  touch $DEST
  cat $file >> $DEST
done
