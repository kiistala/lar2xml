lar2xml
=======

Takes in a Liferay .lar file, outputs XML

Required
==
xmllint, xsltproc, some Perl modules

Install with
  sudo apt-get -y install libxml2-utils xsltproc libxml-libxslt-perl libxml-smart-perl

Usage
==

./lar2xml liferay_site.lar

Result file
==
 Can be found in e.g. Unzipped_liferay_site.lar/combined_liferay_site.lar.xml
