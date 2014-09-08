<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output omit-xml-declaration="yes" indent="yes" cdata-section-elements="folder"/>

<xsl:template match="/">
  <page xsi:noNamespaceSchemaLocation="thlfi-xml-import.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:for-each select="layout">
    <folder><xsl:value-of select="name"/></folder>
    <url><xsl:value-of select="friendly-url"/></url>
    <content></content>
    <title></title>
    <keywords></keywords>
    <description></description>
    <language></language>
    <classes></classes>
  </xsl:for-each>
  </page>
</xsl:template>

</xsl:stylesheet>
