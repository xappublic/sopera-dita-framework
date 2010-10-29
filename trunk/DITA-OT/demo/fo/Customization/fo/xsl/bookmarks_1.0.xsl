<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                xmlns:exsl="http://exslt.org/common"
                xmlns:opentopic="http://www.idiominc.com/opentopic"
                xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
                xmlns:exslf="http://exslt.org/functions"
                xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
                extension-element-prefixes="exsl"
                exclude-result-prefixes="opentopic-index opentopic exslf opentopic-func"
                version='1.1'>

    <xsl:variable name="map" select="//opentopic:map"/>

    <xsl:template name="createBookmarks">
        <xsl:variable name="bookmarks">
            <xsl:apply-templates select="/" mode="bookmark"/>
        </xsl:variable>

        <xsl:if test="count(exsl:node-set($bookmarks)/*) > 0">
            <fo:bookmark-tree>
                <xsl:choose>
                    <xsl:when test="($ditaVersion &gt;= '1.1') and $map//*[contains(@class,' bookmap/toc ')][@href]"/>
                    <!-- Add contents bookmark -->
					<xsl:when test="($ditaVersion &gt;= '1.1') and ($map//*[contains(@class,' bookmap/toc ')]
                        				or /*[contains(@class,' map/map ')][not(contains(@class,' bookmap/bookmap '))])">
                        <fo:bookmark internal-destination="ID_TOC_00-0F-EA-40-0D-4D">
                            <fo:bookmark-title>
                                <xsl:call-template name="insertVariable">
                                    <xsl:with-param name="theVariableID" select="'Table of Contents'"/>
                                </xsl:call-template>
							</fo:bookmark-title>
                        </fo:bookmark>
						<fo:bookmark internal-destination="ID_TOC_00-0F-EA-40-0D-4E">
                            <fo:bookmark-title>
                                <xsl:call-template name="insertVariable">
                                    <xsl:with-param name="theVariableID" select="'List of Figures'"/>
                                </xsl:call-template>
							</fo:bookmark-title>
                        </fo:bookmark>
						<fo:bookmark internal-destination="ID_TOC_00-0F-EA-40-0D-4F">
                            <fo:bookmark-title>
                                <xsl:call-template name="insertVariable">
                                    <xsl:with-param name="theVariableID" select="'List of Tables'"/>
                                </xsl:call-template>
							</fo:bookmark-title>
                        </fo:bookmark>
                    </xsl:when>
					<xsl:when test="($ditaVersion &gt;= '1.1')"/>
                    <xsl:otherwise>
                        <fo:bookmark internal-destination="ID_TOC_00-0F-EA-40-0D-4D">
                            <fo:bookmark-title>
                                <xsl:call-template name="insertVariable">
                                    <xsl:with-param name="theVariableID" select="'Table of Contents'"/>
                                </xsl:call-template>
                            </fo:bookmark-title>
                        </fo:bookmark>
						<fo:bookmark internal-destination="ID_TOC_00-0F-EA-40-0D-4E">
                            <fo:bookmark-title>
                                <xsl:call-template name="insertVariable">
                                    <xsl:with-param name="theVariableID" select="'List of Figures'"/>
                                </xsl:call-template>
                            </fo:bookmark-title>
                        </fo:bookmark>
						<fo:bookmark internal-destination="ID_TOC_00-0F-EA-40-0D-4F">
                            <fo:bookmark-title>
                                <xsl:call-template name="insertVariable">
                                    <xsl:with-param name="theVariableID" select="'List of Tables'"/>
                                </xsl:call-template>
                            </fo:bookmark-title>
                        </fo:bookmark>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:copy-of select="exsl:node-set($bookmarks)"/>
                <!-- CC #6163  -->
                <xsl:if test="//opentopic-index:index.groups//opentopic-index:index.entry">
                    <xsl:choose>
                        <xsl:when test="($ditaVersion &gt;= '1.1') and $map//*[contains(@class,' bookmap/indexlist ')][@href]"/>
                        <xsl:when test="($ditaVersion &gt;= '1.1') and ($map//*[contains(@class,' bookmap/indexlist ')]
                        				or /*[contains(@class,' map/map ')][not(contains(@class,' bookmap/bookmap '))])">
                            <fo:bookmark internal-destination="ID_INDEX_00-0F-EA-40-0D-4D">
                                <fo:bookmark-title>
                                    <xsl:call-template name="insertVariable">
                                        <xsl:with-param name="theVariableID" select="'Index'"/>
                                    </xsl:call-template>
                                </fo:bookmark-title>
                            </fo:bookmark>
                        </xsl:when>
                        <xsl:when test="($ditaVersion &gt;= '1.1')"/>
                        <xsl:otherwise>
                            <fo:bookmark internal-destination="ID_INDEX_00-0F-EA-40-0D-4D">
                                <fo:bookmark-title>
                                    <xsl:call-template name="insertVariable">
                                        <xsl:with-param name="theVariableID" select="'Index'"/>
                                    </xsl:call-template>
                                </fo:bookmark-title>
                            </fo:bookmark>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </fo:bookmark-tree>
        </xsl:if>
    </xsl:template>

    <!--<xsl:template match="*[contains(@class, ' topic/topic ')][opentopic-func:determineTopicType() = 'topicTocList']" mode="bookmark" priority="10"/>-->
    <!--<xsl:template match="*[contains(@class, ' topic/topic ')][opentopic-func:determineTopicType() = 'topicIndexList']" mode="bookmark" priority="10"/>-->


</xsl:stylesheet>