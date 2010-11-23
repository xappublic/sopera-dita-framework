<?xml version='1.0' encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo"
    xmlns:exsl="http://exslt.org/common"
    xmlns:exslf="http://exslt.org/functions"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    extension-element-prefixes="exsl"
    exclude-result-prefixes="opentopic-func exslf exsl dita2xslfo"
    version="1.1">

    
    <xsl:template match="*[contains(@class, ' topic/dlentry ')]">
		<fo:table-row xsl:use-attribute-sets="dlentry" id="{@id}">  <!-- new -->
            <fo:table-cell xsl:use-attribute-sets="dlentry.dt" id="{@id}">
                <xsl:apply-templates select="*[contains(@class, ' topic/dt ')]"/>
            </fo:table-cell>            
        </fo:table-row>
		<fo:table-row xsl:use-attribute-sets="dlentry" id="{@id}">
            <fo:table-cell xsl:use-attribute-sets="dlentry.dd" id="{@id}">
                <xsl:apply-templates select="*[contains(@class, ' topic/dd ')]"/>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/dt ')]">
        <fo:block xsl:use-attribute-sets="dlentry.dt__content">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/dd ')]">
        <fo:block xsl:use-attribute-sets="dlentry.dd__content">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

</xsl:stylesheet>
