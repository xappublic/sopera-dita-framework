<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="1.0">

    <xsl:attribute-set name="__frontmatter">
        <xsl:attribute name="text-align">left</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__title">
        <xsl:attribute name="margin-top">70mm</xsl:attribute>
        <xsl:attribute name="font-size">20pt</xsl:attribute>
        <xsl:attribute name="margin-left">20mm</xsl:attribute>
    </xsl:attribute-set>
	
	<xsl:attribute-set name="__frontmatter__line">
        <xsl:attribute name="margin-left">20mm</xsl:attribute>
		<xsl:attribute name="padding-left">180mm</xsl:attribute>
		<xsl:attribute name="border-top">2pt solid #83B819</xsl:attribute>
    </xsl:attribute-set>
	
	<xsl:attribute-set name="__frontmatter__logo">
        <xsl:attribute name="text-align">right</xsl:attribute>
		<xsl:attribute name="margin-top">20mm</xsl:attribute>
		<xsl:attribute name="margin-right">10mm</xsl:attribute>
    </xsl:attribute-set>
	
	<xsl:attribute-set name="__frontmatter__logo__second">
        <xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="margin-left">10mm</xsl:attribute>
    </xsl:attribute-set>
	
	<xsl:attribute-set name="__frontmatter__copyright__second">
        <xsl:attribute name="font-family">Sans</xsl:attribute>
		<xsl:attribute name="margin-left">10mm</xsl:attribute>
		<xsl:attribute name="margin-top">5mm</xsl:attribute>		
    </xsl:attribute-set>
	
	<xsl:attribute-set name="__frontmatter__title__second">
        <xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="margin-left">10mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">120mm</xsl:attribute>
    </xsl:attribute-set>	
	
	<xsl:attribute-set name="__frontmatter__footer">
        <xsl:attribute name="margin-left">20mm</xsl:attribute>
		<xsl:attribute name="margin-top">80mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__subtitle">
		<xsl:attribute name="margin-top">2mm</xsl:attribute>
		<xsl:attribute name="margin-left">20mm</xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>        
    </xsl:attribute-set>

</xsl:stylesheet>