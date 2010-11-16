<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="1.0">

    <xsl:template match="*[contains(@class,' pr-d/codeblock ')]">
        <xsl:call-template name="generateAttrLabel"/>
        <fo:block xsl:use-attribute-sets="codeblock" id="{@id}">
			<!--<xsl:if test="./ancestor::*[contains(@class, ' task/task ')]">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="width">100%</xsl:attribute>
			</xsl:if>-->
			<xsl:if test="./ancestor::*[contains(@class, ' topic/section ')]">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="width">100%</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor::*[contains(@class, ' topic/example ')]">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="width">100%</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor::*[contains(@class, ' task/steps ')]">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="width">100%</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor::*[contains(@class, ' topic/p ')]">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="width">100%</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor::*[contains(@class, ' topic/dd ')]">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="width">100%</xsl:attribute>
			</xsl:if>
			<xsl:if test="./parent::*[contains(@class,' topic/li ')]">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="width">100%</xsl:attribute>
			</xsl:if>
            <xsl:call-template name="setScale"/>
            <!-- rules have to be applied within the scope of the PRE box; else they start from page margin! -->
            <xsl:if test="contains(@frame,'top')">
                <fo:block>
                    <fo:leader xsl:use-attribute-sets="codeblock__top"/>
                </fo:block>
            </xsl:if>
            <xsl:apply-templates/>
            <xsl:if test="contains(@frame,'bot')">
                <fo:block>
                    <fo:leader xsl:use-attribute-sets="codeblock__bottom"/>
                </fo:block>
            </xsl:if>
        </fo:block>
    </xsl:template>

</xsl:stylesheet>