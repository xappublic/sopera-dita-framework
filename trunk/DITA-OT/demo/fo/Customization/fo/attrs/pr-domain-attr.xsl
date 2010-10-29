<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:attribute-set name="codeblock">
        <xsl:attribute name="space-before">0.3em</xsl:attribute>
        <xsl:attribute name="space-after">0.3em</xsl:attribute>
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="margin-left">45mm</xsl:attribute>        
    </xsl:attribute-set>

    <xsl:attribute-set name="pt">
        <xsl:attribute name="font-size">10pt<!--xsl:value-of select="$default-font-size"/--></xsl:attribute>    
    </xsl:attribute-set>

    <xsl:attribute-set name="pt__content">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="pd">
        <xsl:attribute name="font-size">10pt<!--xsl:value-of select="$default-font-size"/--></xsl:attribute>
        <xsl:attribute name="space-before">0.3em</xsl:attribute>
        <xsl:attribute name="space-after">0.5em</xsl:attribute>
        <xsl:attribute name="start-indent">1pc</xsl:attribute>        
    </xsl:attribute-set>

</xsl:stylesheet>