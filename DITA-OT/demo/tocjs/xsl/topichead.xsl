<!-- 
  This file is part of the DITA Open Toolkit project hosted on
  Sourceforge.net. See the accompanying license.txt file for
  applicable licenses.
  
  (C) Copyright Shawn McKenzie, 2007. All Rights Reserved.
  *-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:template match="*[contains(@class, ' mapgroup-d/topichead ')]">
    <xsl:param name="parent"/>
    <xsl:param name="contentwin"/>
   <!-- <xsl:variable name="self" 
     select="translate(translate(translate(@navtitle, '/', ''), '.', ''), ' ', '')"/>-->
    <xsl:variable name="apos">'</xsl:variable>
    <xsl:variable name="self" select="translate(@navtitle, '$apos/\^&amp;|\¬`*.-) (%$£!+=', '')"/>
    
    <xsl:message>
  
       ######################## IN TOPICHEAD! parent: <xsl:value-of
        select="$parent"/> self: <xsl:value-of select="$self"/>
    </xsl:message>
    
    <xsl:text>var </xsl:text>
      <xsl:value-of select="$self"/>
      <xsl:text> = new YAHOO.widget.TextNode("</xsl:text>
      <xsl:value-of select="@navtitle"/>
      <xsl:text>", </xsl:text>
      <xsl:value-of select="$parent"/>
      <xsl:text>, false);</xsl:text>
    
      <xsl:apply-templates>
      <xsl:with-param name="parent" select="$self"/>
        <xsl:with-param name="contentwin" select="$contentwin"/>
      </xsl:apply-templates>
    
  </xsl:template>
  
  <!-- var tmpNode = new YAHOO.widget.TextNode("mylabel1", root, false); -->
  
</xsl:stylesheet>
