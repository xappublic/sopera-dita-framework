<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:rx="http://www.renderx.com/XSL/Extensions"
    exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func"
    version="1.1">
    
	<xsl:variable name="productName">
        <xsl:variable name="mapProdname" select="/*/opentopic:map//*[contains(@class, ' topic/prodname ')]"/>
        <xsl:variable name="bkinfoProdname" select="/*/*[contains(@class, ' bkinfo/bkinfo ')]//*[contains(@class, ' topic/prodname ')]"/>
		<xsl:variable name="metaProdname" select="//topic[contains(@oid, 'metadata')][1]/prolog/metadata/othermeta[contains(@name, 'sopera-documentation-prod-name')]/@content"/>
        <xsl:choose>
            <xsl:when test="$mapProdname">
                <xsl:value-of select="$mapProdname"/>
            </xsl:when>
            <xsl:when test="$bkinfoProdname">
                <xsl:value-of select="$bkinfoProdname"/>
            </xsl:when>
			<xsl:when test="$metaProdname">
                <xsl:value-of select="$metaProdname"/>
            </xsl:when>
            <xsl:otherwise>
				<xsl:call-template name="insertVariable">
                    <xsl:with-param name="theVariableID" select="'Product Name'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
	
    <xsl:template name="rootTemplate">
        <xsl:call-template name="validateTopicRefs"/>

        <fo:root xsl:use-attribute-sets="__fo__root">

            <xsl:comment>
                <xsl:text>Layout masters = </xsl:text>
                <xsl:value-of select="$layout-masters"/>
            </xsl:comment>

            <xsl:call-template name="createLayoutMasters"/>

            <xsl:call-template name="createBookmarks"/>

            <xsl:call-template name="createFrontMatter"/>

            <xsl:call-template name="createToc"/>
			
			<xsl:call-template name="createFiguresList"/>
			
			<xsl:call-template name="createTablesList"/>
			
<!--            <xsl:call-template name="createPreface"/>-->

            <xsl:apply-templates/>

            <xsl:call-template name="createIndex"/>

        </fo:root>
    </xsl:template>

</xsl:stylesheet>