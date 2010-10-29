<?xml version='1.0' encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl"
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

</xsl:stylesheet>
