<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:rx="http://www.renderx.com/XSL/Extensions"
    version="1.0">

    <xsl:attribute-set name="taskbody" use-attribute-sets="body">
		<!--<xsl:attribute name="margin-left">45mm</xsl:attribute>-->
    </xsl:attribute-set>

	<xsl:attribute-set name="steps.step__content">
        <xsl:attribute name="margin-left">2mm</xsl:attribute>    
    </xsl:attribute-set>
		
	<xsl:attribute-set name="steps">
		<xsl:attribute name="margin-left">45mm</xsl:attribute>
    </xsl:attribute-set>
</xsl:stylesheet>