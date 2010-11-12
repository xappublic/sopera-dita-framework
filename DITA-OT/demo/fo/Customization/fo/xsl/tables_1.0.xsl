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

    <xsl:param name="tableSpecNonProportional" select="'false'"/>

    <xsl:template match="*[contains(@class,' topic/table ')]/*[contains(@class,' topic/title ')]">
        <fo:block xsl:use-attribute-sets="table.title" id="{@id}">
			<xsl:attribute name="id">
				<xsl:value-of select="concat('_OPENTOPIC_TBL_PROCESSING_', generate-id())"/>
			</xsl:attribute>
            <xsl:call-template name="insertVariable">
                <xsl:with-param name="theVariableID" select="'Table'"/>
                <xsl:with-param name="theParameters">
                    <number>
                        <xsl:number level="any" count="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]" from="/"/>
                    </number>
                    <title>
                        <xsl:apply-templates/>
                    </title>
                </xsl:with-param>
            </xsl:call-template>
        </fo:block>
    </xsl:template>

	<xsl:template match="*[contains(@class, ' topic/tbody ')]/*[contains(@class, ' topic/row ')]/*[contains(@class, ' topic/entry ')]">
        <fo:table-cell xsl:use-attribute-sets="tbody.row.entry" id="{@id}">
            <xsl:call-template name="applySpansAttrs"/>
            <xsl:call-template name="applyAlignAttrs"/>
            <xsl:call-template name="generateTableEntryBorder"/>
			<!-- Cell Content -->
			<fo:block xsl:use-attribute-sets="tbody.row.entry__content">
				<xsl:call-template name="processEntryContent"/>
			</fo:block>
        </fo:table-cell>
    </xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/dl ')]">
        <fo:table xsl:use-attribute-sets="dl" id="{@id}">
			<xsl:attribute name="margin-left">0mm</xsl:attribute>
			<xsl:if test="./parent::*[name()='body']">
				<xsl:attribute name="margin-left">22mm</xsl:attribute>
			</xsl:if>
			<!--<xsl:if test="./ancestor::*[name()='task']">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor::*[name()='section']">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor::*[name()='example']">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>-->
            <xsl:apply-templates select="*[contains(@class, ' topic/dlhead ')]"/>
            <fo:table-body xsl:use-attribute-sets="dl__body">
                <xsl:choose>
                    <xsl:when test="contains(@otherprops,'sortable')">
                        <xsl:apply-templates select="*[contains(@class, ' topic/dlentry ')]">
                            <xsl:sort select="opentopic-func:getSortString(normalize-space( opentopic-func:fetchValueableText(*[contains(@class, ' topic/dt ')]) ))" lang="{$locale}"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="*[contains(@class, ' topic/dlentry ')]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:table-body>
        </fo:table>
    </xsl:template>	
	
	
    <exslf:function name="opentopic-func:getSortString">
        <xsl:param name="text"/>
        <xsl:choose>
            <xsl:when test="contains($text, '[') and contains($text, ']')">
                <exslf:result select="substring-before(substring-after($text, '['),']')"/>
            </xsl:when>
            <xsl:otherwise>
                <exslf:result select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </exslf:function>
    
    <xsl:function version="2.0" name="opentopic-func:getSortString">
        <xsl:param name="text"/>
        <xsl:choose>
            <xsl:when test="contains($text, '[') and contains($text, ']')">
                <xsl:value-of select="substring-before(substring-after($text, '['),']')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <exslf:function name="opentopic-func:fetchValueableText">
        <xsl:param name="node"/>

        <xsl:variable name="res">
            <xsl:apply-templates select="$node" mode="insert-text"/>
        </xsl:variable>

        <exslf:result select="$res"/>

    </exslf:function>
    
    <xsl:function version="2.0" name="opentopic-func:fetchValueableText">
        <xsl:param name="node"/>

        <xsl:variable name="res">
            <xsl:apply-templates select="$node" mode="insert-text"/>
        </xsl:variable>

        <xsl:value-of select="$res"/>

    </xsl:function>
	
</xsl:stylesheet>
