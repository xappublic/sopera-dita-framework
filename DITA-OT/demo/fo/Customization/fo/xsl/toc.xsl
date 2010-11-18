<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:exsl="http://exslt.org/common"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    extension-element-prefixes="exsl"
    exclude-result-prefixes="opentopic"
    version='1.1'>

    <xsl:variable name="map" select="//opentopic:map"/>

    <xsl:template name="createTocHeader">
        <fo:block xsl:use-attribute-sets="__toc__header">
            <xsl:attribute name="id">ID_TOC_00-0F-EA-40-0D-4D</xsl:attribute>
            <xsl:call-template name="insertVariable">
                <xsl:with-param name="theVariableID" select="'Table of Contents'"/>
            </xsl:call-template>
        </fo:block>
    </xsl:template>
	
	<xsl:template name="createFigHeader">
        <fo:block xsl:use-attribute-sets="__toc__header">
            <xsl:attribute name="id">ID_TOC_00-0F-EA-40-0D-4E</xsl:attribute>
            <xsl:call-template name="insertVariable">
                <xsl:with-param name="theVariableID" select="'List of Figures'"/>
            </xsl:call-template>
        </fo:block>
    </xsl:template>
	
	<xsl:template name="createTblHeader">
        <fo:block xsl:use-attribute-sets="__toc__header">
            <xsl:attribute name="id">ID_TOC_00-0F-EA-40-0D-4F</xsl:attribute>
            <xsl:call-template name="insertVariable">
                <xsl:with-param name="theVariableID" select="'List of Tables'"/>
            </xsl:call-template>
        </fo:block>
    </xsl:template>

    <xsl:template name="createToc">

        <xsl:variable name="toc">
            <xsl:apply-templates select="/" mode="toc"/>
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

    <xsl:template match="/" mode="toc">
        <xsl:apply-templates mode="toc">
            <xsl:with-param name="include" select="'true'"/>
        </xsl:apply-templates>
    </xsl:template>

	<!-- add " and not(contains(ancestor-or-self::*/@oid, 'metadata')) " for not adding metadata to TOC -->
    <xsl:template match="*[contains(@class, ' topic/topic ') and not(contains(ancestor-or-self::*/@oid, 'metadata')) and not(contains(@class, ' bkinfo/bkinfo '))]" mode="toc">
        <xsl:param name="include"/>
        <xsl:variable name="topicLevel" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
        <xsl:if test="$topicLevel &lt; $tocMaximumLevel">
            <xsl:variable name="topicTitle">
                <xsl:call-template name="getNavTitle" />
            </xsl:variable>
            <xsl:variable name="id" select="@id"/>
            <xsl:variable name="gid" select="generate-id()"/>
            <xsl:variable name="topicNumber" select="count(exsl:node-set($topicNumbers)/topic[@id = $id][following-sibling::topic[@guid = $gid]]) + 1"/>
            <xsl:variable name="mapTopic">
                <xsl:copy-of select="$map//*[@id = $id]"/>
            </xsl:variable>
            <xsl:variable name="topicType">
                <xsl:call-template name="determineTopicType"/>
            </xsl:variable>

            <xsl:variable name="parentTopicHead">
                <xsl:copy-of select="$map//*[@id = $id]/parent::*[contains(@class, ' mapgroup/topichead ')]"/>
            </xsl:variable>

            <!--        <xsl:if test="(($mapTopic/*[position() = $topicNumber][@toc = 'yes' or not(@toc)]) or (not($mapTopic/*) and $include = 'true')) and not($parentTopicHead/*[position() = $topicNumber]/@toc = 'no')">-->
            <!-- added by William on 2009-05-11 for toc bug start -->
            <xsl:choose>
			<!-- <xsl:when test="($mapTopic/*[position() = $topicNumber][@toc = 'yes' or not(@toc)][not(contains(@ohref, 'metadata'))]) or (not($mapTopic/*) and $include = 'true')"> -->
			<xsl:when test="($mapTopic/*[position() = $topicNumber][@toc = 'yes' or not(@toc)]) or (not($mapTopic/*) and $include = 'true')">
                    <fo:block xsl:use-attribute-sets="__toc__indent">
						<!-- get current level -->
						<xsl:variable name="levelz" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
						<!-- if current level = 1 add top margin -->
						<xsl:if test="$levelz = '1'">
							<xsl:attribute name="margin-top">5mm</xsl:attribute>
						</xsl:if>
                        <xsl:variable name="tocItemContent">
                          <fo:basic-link internal-destination="{concat('_OPENTOPIC_TOC_PROCESSING_', generate-id())}" xsl:use-attribute-sets="__toc__link">
                            <xsl:apply-templates select="$topicType" mode="toc-prefix-text">
                                <xsl:with-param name="id" select="@id"/>
                            </xsl:apply-templates>
							<fo:inline xsl:use-attribute-sets="__toc__title" margin-right=".2in">
								<!-- if current level = 1 add bold attribute -->
								<xsl:if test="$levelz = '1'">
									<xsl:attribute name="font-weight">bold</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="normalize-space($topicTitle)"/> <!-- title text in TOC -->
							</fo:inline>
                            <fo:inline margin-left="-.2in" keep-together.within-line="always">
                                <fo:leader xsl:use-attribute-sets="__toc__leader"/>
                                <fo:page-number-citation ref-id="{concat('_OPENTOPIC_TOC_PROCESSING_', generate-id())}"/>
                            </fo:inline>
                          </fo:basic-link>
                        </xsl:variable>
                        <xsl:apply-templates select="$topicType" mode="toc-topic-text">
                            <xsl:with-param name="tocItemContent" select="$tocItemContent"/>
                        </xsl:apply-templates>
                    </fo:block>
                    <!-- In a future version, suppressing Notices in the TOC should not be hard-coded. -->
                    <xsl:if test="not($topicType = 'topicNotices')">
					    <xsl:apply-templates mode="toc">
                            <xsl:with-param name="include" select="'true'"/>
                        </xsl:apply-templates>
                    </xsl:if>
            	</xsl:when>
            	<xsl:otherwise>
	            	<xsl:apply-templates mode="toc">
		                    <xsl:with-param name="include" select="'true'"/>
		            </xsl:apply-templates>
            	</xsl:otherwise>				
            </xsl:choose>
            <!-- added by William on 2009-05-11 for toc bug end -->
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="text()[.='topicChapter']" mode="toc-prefix-text">
        <xsl:param name="id"/>
        <xsl:variable name="topicChapters">
            <xsl:copy-of select="$map//*[contains(@class, ' bookmap/chapter ')]"/>
        </xsl:variable>
        <xsl:variable name="chapterNumber">
            <xsl:number format="1" value="count($topicChapters/*[@id = $id]/preceding-sibling::*) + 1"/>
        </xsl:variable>
        <xsl:call-template name="insertVariable">
            <xsl:with-param name="theVariableID" select="'Table of Contents Chapter'"/>
            <xsl:with-param name="theParameters">
                <number>
                    <xsl:value-of select="$chapterNumber"/>
                </number>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="text()[.='topicAppendix']" mode="toc-prefix-text">
        <xsl:param name="id"/>
        <xsl:variable name="topicAppendixes">
            <xsl:copy-of select="$map//*[contains(@class, ' bookmap/appendix ')]"/>
        </xsl:variable>
        <xsl:variable name="appendixNumber">
            <xsl:number format="A" value="count($topicAppendixes/*[@id = $id]/preceding-sibling::*) + 1"/>
        </xsl:variable>
        <xsl:call-template name="insertVariable">
            <xsl:with-param name="theVariableID" select="'Table of Contents Appendix'"/>
            <xsl:with-param name="theParameters">
                <number>
                    <xsl:value-of select="$appendixNumber"/>
                </number>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="text()[.='topicPart']" mode="toc-prefix-text">
        <xsl:param name="id"/>
        <xsl:variable name="topicParts">
            <xsl:copy-of select="$map//*[contains(@class, ' bookmap/part ')]"/>
        </xsl:variable>
        <xsl:variable name="partNumber">
            <xsl:number format="I" value="count($topicParts/*[@id = $id]/preceding-sibling::*) + 1"/>
        </xsl:variable>
        <xsl:call-template name="insertVariable">
            <xsl:with-param name="theVariableID" select="'Table of Contents Part'"/>
            <xsl:with-param name="theParameters">
                <number>
                    <xsl:value-of select="$partNumber"/>
                </number>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="text()[.='topicPreface']" mode="toc-prefix-text">
        <xsl:call-template name="insertVariable">
            <xsl:with-param name="theVariableID" select="'Table of Contents Preface'"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="text()[.='topicNotices']" mode="toc-prefix-text">
        <xsl:call-template name="insertVariable">
            <xsl:with-param name="theVariableID" select="'Table of Contents Notices'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="node()" mode="toc-prefix-text" />


    <xsl:template match="text()[. = 'topicChapter']" mode="toc-topic-text">
        <xsl:param name="tocItemContent"/>
        <fo:block xsl:use-attribute-sets="__toc__chapter__content">
            <xsl:copy-of select="$tocItemContent"/>
        </fo:block>
    </xsl:template>
    
    <xsl:template match="text()[. = 'topicAppendix']" mode="toc-topic-text">
        <xsl:param name="tocItemContent"/>
        <fo:block xsl:use-attribute-sets="__toc__appendix__content">
            <xsl:copy-of select="$tocItemContent"/>
        </fo:block>
    </xsl:template>
    
    <xsl:template match="text()[. = 'topicPart']" mode="toc-topic-text">
        <xsl:param name="tocItemContent"/>
        <fo:block xsl:use-attribute-sets="__toc__part__content">
            <xsl:copy-of select="$tocItemContent"/>
        </fo:block>
    </xsl:template>
    
    <xsl:template match="text()[. = 'topicPreface']" mode="toc-topic-text">
        <xsl:param name="tocItemContent"/>
        <fo:block xsl:use-attribute-sets="__toc__preface__content">
            <xsl:copy-of select="$tocItemContent"/>
        </fo:block>
    </xsl:template>
    
    <xsl:template match="text()[. = 'topicNotices']" mode="toc-topic-text">
        <!-- Disabled, because now the Notices appear before the TOC -->
        <!--<xsl:param name="tocItemContent"/>
        <fo:block xsl:use-attribute-sets="__toc__notices__content">
            <xsl:copy-of select="$tocItemContent"/>
        </fo:block>-->
    </xsl:template>
    
    <xsl:template match="node()" mode="toc-topic-text">
        <xsl:param name="tocItemContent"/>
        <fo:block xsl:use-attribute-sets="__toc__topic__content">
            <xsl:copy-of select="$tocItemContent"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="node()" mode="toc">
        <xsl:param name="include"/>
        <xsl:apply-templates mode="toc">
            <xsl:with-param name="include" select="$include"/>
        </xsl:apply-templates>
    </xsl:template>
	
	<xsl:template match="text()" mode="fig-topic-text">
        <xsl:param name="FigItemContent"/>
        <fo:block xsl:use-attribute-sets="__toc__topic__content">
            <xsl:copy-of select="$FigItemContent"/>
        </fo:block>
    </xsl:template>
	
	<xsl:template match="node()" mode="fig-topic-text">
        <xsl:param name="FigItemContent"/>
        <fo:block xsl:use-attribute-sets="__toc__topic__content">
            <xsl:copy-of select="$FigItemContent"/>
        </fo:block>
    </xsl:template>
	
	<xsl:template match="text()" mode="tbl-topic-text">
        <xsl:param name="TblItemContent"/>
        <fo:block xsl:use-attribute-sets="__toc__topic__content">
            <xsl:copy-of select="$TblItemContent"/>
        </fo:block>
    </xsl:template>
	
	<xsl:template match="node()" mode="tbl-topic-text">
        <xsl:param name="TblItemContent"/>
        <fo:block xsl:use-attribute-sets="__toc__topic__content">
            <xsl:copy-of select="$TblItemContent"/>
        </fo:block>
    </xsl:template>

</xsl:stylesheet>
