<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    exclude-result-prefixes="opentopic"
    version="1.1">

    <xsl:variable name="map" select="//opentopic:map"/>

    <xsl:template name="createFrontMatter_1.0">
        <fo:page-sequence master-reference="front-matter" xsl:use-attribute-sets="__force__page__count">
            <xsl:call-template name="insertFrontMatterStaticContents"/>
            <fo:flow flow-name="xsl-region-body">
                <fo:block xsl:use-attribute-sets="__frontmatter">
                    <!-- set the title -->
					<!-- <fo:block> -->
					<xsl:variable name="imagepath" select="//topic[contains(@oid, 'metadata')][1]/topic/body/image/@href"/>
					<xsl:variable name="imagewidth" select="//topic[contains(@oid, 'metadata')][1]/topic/body/image/@width"/>
					<xsl:variable name="imageheight" select="//topic[contains(@oid, 'metadata')][1]/topic/body/image/@height"/>
					<fo:block xsl:use-attribute-sets="__frontmatter__logo">
						<fo:external-graphic>
							<xsl:attribute name="src">
								<xsl:value-of select="concat('url(', $imagepath, ')')"/>
							</xsl:attribute>
							<xsl:attribute name="content-width">
								<xsl:value-of select="$imagewidth"/>
							</xsl:attribute>
							<xsl:attribute name="content-height">
								<xsl:value-of select="$imageheight"/>
							</xsl:attribute>
						</fo:external-graphic>
					</fo:block>
					<!-- </fo:block> -->
                    <fo:block xsl:use-attribute-sets="__frontmatter__title">
						<!--start of title
                        <xsl:choose>
                            <xsl:when test="$map/*[contains(@class,' topic/title ')][1]">
                                <xsl:apply-templates select="$map/*[contains(@class,' topic/title ')][1]"/>
                            </xsl:when>
                            <xsl:when test="$map//*[contains(@class,' bookmap/mainbooktitle ')][1]">
                                <xsl:apply-templates select="$map//*[contains(@class,' bookmap/mainbooktitle ')][1]"/>
                            </xsl:when>
                            <xsl:when test="//*[contains(@class, ' map/map ')]/@title">
                                <xsl:value-of select="//*[contains(@class, ' map/map ')]/@title"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="/descendant::*[contains(@class, ' topic/topic ')][1]/*[contains(@class, ' topic/title ')]"/>
                            </xsl:otherwise>
                        </xsl:choose>
						-->
						<xsl:value-of select="//topic[contains(@oid, 'metadata')][1]/*[contains(@class, ' topic/title ')]"/>
                    </fo:block>
					<!-- green line -->
					<fo:block xsl:use-attribute-sets="__frontmatter__line"></fo:block>
					<!-- set the subtitle
                    <xsl:apply-templates select="$map//*[contains(@class,' bookmap/booktitlealt ')]"/>
					-->
					<fo:block xsl:use-attribute-sets="__frontmatter__subtitle">
						<xsl:value-of select="//topic[contains(@oid, 'metadata')][1]/prolog/metadata/othermeta[contains(@name, 'sopera-documentation-subtitle')]/@content"/>
					</fo:block>
                    <fo:block xsl:use-attribute-sets="__frontmatter__owner">
                        <xsl:apply-templates select="$map//*[contains(@class,' bookmap/bookmeta ')]"/>
                    </fo:block>
					<fo:block xsl:use-attribute-sets="__frontmatter__footer">
						<xsl:value-of select="//topic[contains(@oid, 'metadata')][1]/prolog/metadata/othermeta[contains(@name, 'sopera-documentation-footer')]/@content"/>
					</fo:block>
                </fo:block>				
                <!--<xsl:call-template name="createPreface"/>-->
            </fo:flow>			
        </fo:page-sequence>
		<fo:page-sequence master-reference="front-matter" xsl:use-attribute-sets="__force__page__count">
            <!--<xsl:call-template name="insertFrontMatterStaticContents"/>-->
            <fo:flow flow-name="xsl-region-body">
                <xsl:call-template name="createSecondPage"/>
            </fo:flow>			
        </fo:page-sequence>
        <xsl:call-template name="createNotices"/>
    </xsl:template>
	
	<xsl:template name="createSecondPage">
		<xsl:variable name="imagepath" select="//topic[contains(@oid, 'metadata')][1]/topic/body/image/@href"/>
		<xsl:variable name="imagewidth" select="//topic[contains(@oid, 'metadata')][1]/topic/body/image/@width"/>
		<xsl:variable name="imageheight" select="//topic[contains(@oid, 'metadata')][1]/topic/body/image/@height"/>
		<fo:block xsl:use-attribute-sets="__frontmatter__title__second"></fo:block>
		<fo:block xsl:use-attribute-sets="__frontmatter__logo__second">
			<fo:external-graphic>
							<xsl:attribute name="src">
								<xsl:value-of select="concat('url(', $imagepath, ')')"/>
							</xsl:attribute>
							<xsl:attribute name="content-width">
								<xsl:value-of select="$imagewidth"/>
							</xsl:attribute>
							<xsl:attribute name="content-height">
								<xsl:value-of select="$imageheight"/>
							</xsl:attribute>
			</fo:external-graphic>
		</fo:block>
		<xsl:apply-templates select="//topic[contains(@oid, 'metadata')][1]/topic[contains(@oid, 'legal_copyright')]/body/p" />
		<fo:block xsl:use-attribute-sets="__frontmatter__copyright__second">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			Updated: <xsl:value-of select="//topic[contains(@oid, 'metadata')][1]/prolog/metadata/othermeta[contains(@name, 'sopera-documentation-updated')]/@content"/>
		</fo:block>
		<fo:block xsl:use-attribute-sets="__frontmatter__copyright__second">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			Document ID: <xsl:value-of select="//topic[contains(@oid, 'metadata')][1]/prolog/metadata/othermeta[contains(@name, 'sopera-documentation-version')]/@content"/>
		</fo:block>
	</xsl:template>
</xsl:stylesheet>