<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:rx="http://www.renderx.com/XSL/Extensions"
    version="1.0">

    <xsl:attribute-set name="tm">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="tm__content">
        <xsl:attribute name="font-size">75%</xsl:attribute>
        <xsl:attribute name="baseline-shift">20%</xsl:attribute> 
    </xsl:attribute-set>

    <xsl:attribute-set name="tm__content__service">
        <xsl:attribute name="font-size">40%</xsl:attribute>
        <xsl:attribute name="baseline-shift">50%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="author">
    </xsl:attribute-set>

    <xsl:attribute-set name="source">
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.title">
        <xsl:attribute name="border-bottom">inherit</xsl:attribute>
        <xsl:attribute name="margin-left">10mm</xsl:attribute>
        <xsl:attribute name="font-size">24pt</xsl:attribute>
        <xsl:attribute name="text-align">right</xsl:attribute>                		
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.title">
        <xsl:attribute name="border-bottom">inherit</xsl:attribute>
		<xsl:attribute name="page-break-before">always</xsl:attribute>
		<xsl:attribute name="margin-top">5mm</xsl:attribute>		
        <xsl:attribute name="margin-bottom">5mm</xsl:attribute>
		<xsl:attribute name="margin-left">10mm</xsl:attribute>        
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.topic.title">
        <xsl:attribute name="margin-top">5mm</xsl:attribute>		
        <xsl:attribute name="margin-bottom">3mm</xsl:attribute>
		<xsl:attribute name="margin-left">10mm</xsl:attribute>        
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.topic.topic.title">
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="margin-top">5mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">3mm</xsl:attribute>
		<xsl:attribute name="margin-left">45mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.topic.topic.topic.title">
		<xsl:attribute name="margin-left">10mm</xsl:attribute>        
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.topic.topic.topic.topic.title">
        <xsl:attribute name="margin-left">10mm</xsl:attribute>        
    </xsl:attribute-set>

    <xsl:attribute-set name="section.title">
		<xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="margin-left">10mm</xsl:attribute>
		<xsl:attribute name="margin-top">2mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">2mm</xsl:attribute>
		<xsl:attribute name="space-before.optimum">0pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">auto</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fig.title">
        <xsl:attribute name="margin-left">10mm</xsl:attribute>        
    </xsl:attribute-set>

    <xsl:attribute-set name="body__toplevel">
        <xsl:attribute name="margin-left">0pt</xsl:attribute>
        <xsl:attribute name="font-size"><xsl:value-of select="$default-font-size"/></xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="body__secondLevel">
        <xsl:attribute name="margin-left">0pt</xsl:attribute>
        <xsl:attribute name="font-size"><xsl:value-of select="$default-font-size"/></xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="body">
        <xsl:attribute name="margin-left">0pt</xsl:attribute>
        <xsl:attribute name="font-size"><xsl:value-of select="$default-font-size"/></xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="shortdesc">
		<xsl:attribute name="margin-left">45mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic__shortdesc" use-attribute-sets="body">
		<xsl:attribute name="margin-left">45mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="section">
		<!--<xsl:attribute name="text-align">justify</xsl:attribute>-->
        <xsl:attribute name="line-height">12pt</xsl:attribute>
        <xsl:attribute name="space-before">2.0em</xsl:attribute>
        <xsl:attribute name="font-size"><xsl:value-of select="$default-font-size"/></xsl:attribute>
		<xsl:attribute name="margin-top">2mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">2mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="example">
        <xsl:attribute name="line-height">11pt</xsl:attribute>
        <xsl:attribute name="space-before">0.2em</xsl:attribute>
        <xsl:attribute name="margin-left">0.1in</xsl:attribute>
        <xsl:attribute name="margin-right">0.1in</xsl:attribute>
        <xsl:attribute name="padding">3pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
		<xsl:attribute name="margin-left">45mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note">
		<xsl:attribute name="margin-left">45mm</xsl:attribute>
    </xsl:attribute-set>

	<xsl:attribute-set name="rightcolumn">
		<xsl:attribute name="margin-left">55mm</xsl:attribute>
	</xsl:attribute-set>	

</xsl:stylesheet>