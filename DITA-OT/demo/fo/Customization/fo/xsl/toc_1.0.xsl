<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:exsl="http://exslt.org/common"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:exslf="http://exslt.org/functions"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    extension-element-prefixes="exsl"
    exclude-result-prefixes="opentopic exslf opentopic-func"
    version='1.1'>

    <xsl:variable name="map" select="//opentopic:map"/>

    <xsl:template name="createToc">

        <xsl:variable name="toc">
            <xsl:choose>
                <xsl:when test="($ditaVersion &gt;= '1.1') and $map//*[contains(@class,' bookmap/toc ')][@href]"/>
                <xsl:when test="($ditaVersion &gt;= '1.1') and $map//*[contains(@class,' bookmap/toc ')]">
                    <xsl:apply-templates select="/" mode="toc"/>
                </xsl:when>
                <xsl:when test="($ditaVersion &gt;= '1.1') and /*[contains(@class,' map/map ')][not(contains(@class,' bookmap/bookmap '))]">
                    <xsl:apply-templates select="/" mode="toc"/>
                </xsl:when>
                <xsl:when test="($ditaVersion &gt;= '1.1')"/>
                <xsl:otherwise>
                    <xsl:apply-templates select="/" mode="toc"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="count(exsl:node-set($toc)/*) > 0">
            <fo:page-sequence master-reference="toc-sequence" format="i" xsl:use-attribute-sets="__force__page__count">

                <!--<xsl:call-template name="insertTocStaticContents"/>-->

                <fo:flow flow-name="xsl-region-body">
                    <xsl:call-template name="createTocHeader"/>
                    <fo:block>
                        <xsl:copy-of select="exsl:node-set($toc)"/>
                    </fo:block>
                </fo:flow>

            </fo:page-sequence>
        </xsl:if>
    </xsl:template>

	<xsl:template name="createFiguresList">
		<xsl:if test="count(exsl:node-set(//*[contains(@class,' topic/fig ')]/*[contains(@class,' topic/title ')])) > 0">
			<fo:page-sequence master-reference="toc-sequence" format="i">
				<xsl:call-template name="insertFigStaticContents"/>
				<fo:flow flow-name="xsl-region-body">
					<xsl:call-template name="createFigHeader"/>
					<xsl:for-each select="//*[contains(@class,' topic/fig ')]/*[contains(@class,' topic/title ')]">
						<fo:block margin-left="72pt">
							<xsl:variable name="FigItemContent">
								<fo:basic-link internal-destination="{concat('_OPENTOPIC_FIG_PROCESSING_', generate-id())}" xsl:use-attribute-sets="__toc__link">
									<!--  keep-together.within-line="always" for fo:inline to keep text together on one line -->
									<fo:inline margin-left=".2in">
										<xsl:text>Figure </xsl:text>
										<xsl:number level="any" count="//*[contains(@class,' topic/fig ')]/*[contains(@class,' topic/title ')]"/>
										<xsl:text>: </xsl:text>
									</fo:inline>
									<fo:inline xsl:use-attribute-sets="__toc__title" margin-right=".2in">
										<xsl:value-of select="normalize-space(.)"/>
									</fo:inline>
									<fo:inline margin-left="-.2in">
										<fo:leader xsl:use-attribute-sets="__toc__leader"/>
										<fo:page-number-citation ref-id="{concat('_OPENTOPIC_FIG_PROCESSING_', generate-id())}"/>
									</fo:inline>
								</fo:basic-link>
							</xsl:variable>
							<xsl:apply-templates mode="fig-topic-text">
								<xsl:with-param name="FigItemContent" select="$FigItemContent"/>
							</xsl:apply-templates>
						</fo:block>
					</xsl:for-each>
				</fo:flow>
			</fo:page-sequence>
		</xsl:if>
    </xsl:template>
	
	<xsl:template name="createTablesList">
		<xsl:if test="count(exsl:node-set(//*[contains(@class,' topic/table ')]/*[contains(@class,' topic/title ')])) > 0">
			<fo:page-sequence master-reference="toc-sequence" format="i">
				<xsl:call-template name="insertTblStaticContents"/>
				<fo:flow flow-name="xsl-region-body">
					<xsl:call-template name="createTblHeader"/>
					<xsl:for-each select="//*[contains(@class,' topic/table ')]/*[contains(@class,' topic/title ')]">
							<fo:block margin-left="72pt">
								<xsl:variable name="TblItemContent">
									<fo:basic-link internal-destination="{concat('_OPENTOPIC_TBL_PROCESSING_', generate-id())}" xsl:use-attribute-sets="__toc__link">
										<!--  keep-together.within-line="always" for fo:inline to keep text together on one line -->
										<fo:inline margin-left=".2in">
											<xsl:text>Table </xsl:text>

											<xsl:number level="any" count="//*[contains(@class,' topic/table ')]/*[contains(@class,' topic/title ')]"/>
											<xsl:text>: </xsl:text>
										</fo:inline>
										<fo:inline xsl:use-attribute-sets="__toc__title" margin-right=".2in">
											<xsl:value-of select="normalize-space(.)"/>
										</fo:inline>
										<fo:inline margin-left="-.2in">
											<fo:leader xsl:use-attribute-sets="__toc__leader"/>
											<fo:page-number-citation ref-id="{concat('_OPENTOPIC_TBL_PROCESSING_', generate-id())}"/>
										</fo:inline>
									</fo:basic-link>
								</xsl:variable>
								<xsl:apply-templates mode="tbl-topic-text">
									<xsl:with-param name="TblItemContent" select="$TblItemContent"/>
								</xsl:apply-templates>
							</fo:block>
						</xsl:for-each>
				</fo:flow>
			</fo:page-sequence>
		</xsl:if>
    </xsl:template>
	<!--
	<xsl:template match="//*[contains(@class,' topic/table ')]/*[contains(@class,' topic/title ')]">
		<fo:block xsl:use-attribute-sets="section.title">
			11<xsl:value-of select="."/>22
		</fo:block>
	</xsl:template>
	-->
    <xsl:template name="processTocList">
        <fo:page-sequence master-reference="toc-sequence" format="i" xsl:use-attribute-sets="__force__page__count">

            <xsl:call-template name="insertTocStaticContents"/>

            <fo:flow flow-name="xsl-region-body">
                <xsl:call-template name="createTocHeader"/>
                <fo:block>
                    <xsl:apply-templates/>
                </fo:block>
            </fo:flow>

        </fo:page-sequence>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/topic ')][opentopic-func:determineTopicType() = 'topicTocList']"  mode="toc" priority="10"/>
    <xsl:template match="*[contains(@class, ' topic/topic ')][opentopic-func:determineTopicType() = 'topicIndexList']"  mode="toc" priority="10"/>

</xsl:stylesheet>