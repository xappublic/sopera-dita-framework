<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:exsl="http://exslt.org/common"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    extension-element-prefixes="exsl"
    exclude-result-prefixes="opentopic exsl opentopic-index dita2xslfo"
    version="1.1">

	<xsl:template match="*[contains(@class,' topic/fig ')]/*[contains(@class,' topic/title ')]">
		<fo:block xsl:use-attribute-sets="fig.title" id="{@id}">
			<xsl:attribute name="id">
				<xsl:value-of select="concat('_OPENTOPIC_FIG_PROCESSING_', generate-id())"/>
			</xsl:attribute>
			<xsl:call-template name="insertVariable">
                <xsl:with-param name="theVariableID" select="'Figure'"/>
                <xsl:with-param name="theParameters">
                    <number>
                        <xsl:number level="any" count="*[contains(@class, ' topic/fig ')][child::*[contains(@class, ' topic/title ')]]" from="/"/>
                    </number>
                    <title>
                        <xsl:apply-templates/>
                    </title>
                </xsl:with-param>
            </xsl:call-template>
        </fo:block>
    </xsl:template>

	<!-- <xsl:template match="*[contains(@class,' topic/section ')]"> [not(contains(ancestor::*[@class],' task/task '))] -->
	<xsl:template match="section[contains(@class,' topic/section ')]">
			<fo:table>
				<fo:table-column column-width="40mm"/>
				<fo:table-column column-width="5mm"/>
				<fo:table-column column-width="125mm"/>

				<fo:table-body>
				  <fo:table-row>
					<fo:table-cell>
						<xsl:apply-templates select="title"/>			
					</fo:table-cell>
					<fo:table-cell>
						<fo:block></fo:block>
					</fo:table-cell>
					<fo:table-cell>
						<fo:block xsl:use-attribute-sets="section" id="{@id}">
							<xsl:apply-templates select="." mode="dita2xslfo:section-heading"/>
							<xsl:apply-templates select="*[name()!='title']"/>
						</fo:block>
					</fo:table-cell>
				  </fo:table-row>			  
				</fo:table-body>
			</fo:table>		
    </xsl:template>
	
	<xsl:template match="//unknown">
		<fo:block>
			<xsl:attribute name="page-break-after">always</xsl:attribute>
		</fo:block>
    </xsl:template>
	
	<xsl:template match="*[contains(@class,' topic/section ')]" mode="dita2xslfo:section-heading">
      <!-- Specialized simpletable elements may override this rule to add
           default headings for a section. By default, titles are processed
           where they exist within the section, so overrides may need to
           check for the existence of a title first. -->
    </xsl:template>
	
	<xsl:template match="*[contains(@class,' topic/example ')]">
        <fo:block xsl:use-attribute-sets="example" id="{@id}">
			<xsl:if test="./parent::*[name()='body']">
                <xsl:attribute name="margin-left">45mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor::*[name()='task']">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor::*[name()='section']">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor::*[name()='example']">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/p ')]">
        <fo:block xsl:use-attribute-sets="p" id="{@id}">
			<xsl:if test="./parent::*[contains(@class,' topic/body ')]">
                <xsl:attribute name="margin-left">45mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor::*[contains(@oid, 'metadata')]">
			    <xsl:attribute name="margin-left">10mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor::*[contains(@class, ' task/task ')]">
                <xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>			
			<xsl:apply-templates/>
        </fo:block>
    </xsl:template>
	
	
	<xsl:template name="placeNoteContent">
        <xsl:apply-templates select="." mode="placeNoteContent"/>
    </xsl:template>
	<xsl:template match="*" mode="placeNoteContent">
        <fo:block xsl:use-attribute-sets="note" id="{@id}">
			<xsl:if test="./ancestor::*[name()='task']">
                <xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor::*[name()='section']">
                <xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor::*[name()='table']">
                <xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>
			<fo:inline xsl:use-attribute-sets="note__label">
                <xsl:choose>
                    <xsl:when test="@type='note' or not(@type)">
                        <fo:inline xsl:use-attribute-sets="note__label__note">
                            <xsl:call-template name="insertVariable">
                                <xsl:with-param name="theVariableID" select="'Note'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='tip'">
                        <fo:inline xsl:use-attribute-sets="note__label__tip">
                            <xsl:call-template name="insertVariable">
                                <xsl:with-param name="theVariableID" select="'Tip'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='fastpath'">
                        <fo:inline xsl:use-attribute-sets="note__label__fastpath">
                            <xsl:call-template name="insertVariable">
                                <xsl:with-param name="theVariableID" select="'Fastpath'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='restriction'">
                        <fo:inline xsl:use-attribute-sets="note__label__restriction">
                            <xsl:call-template name="insertVariable">
                                <xsl:with-param name="theVariableID" select="'Restriction'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='important'">
                        <fo:inline xsl:use-attribute-sets="note__label__important">
                            <xsl:call-template name="insertVariable">
                                <xsl:with-param name="theVariableID" select="'Important'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='remember'">
                        <fo:inline xsl:use-attribute-sets="note__label__remember">
                            <xsl:call-template name="insertVariable">
                                <xsl:with-param name="theVariableID" select="'Remember'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='attention'">
                        <fo:inline xsl:use-attribute-sets="note__label__attention">
                            <xsl:call-template name="insertVariable">
                                <xsl:with-param name="theVariableID" select="'Attention'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='caution'">
                        <fo:inline xsl:use-attribute-sets="note__label__caution">
                            <xsl:call-template name="insertVariable">
                                <xsl:with-param name="theVariableID" select="'Caution'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='danger'">
                        <fo:inline xsl:use-attribute-sets="note__label__danger">
                            <xsl:call-template name="insertVariable">
                                <xsl:with-param name="theVariableID" select="'Danger'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='other'">
                        <fo:inline xsl:use-attribute-sets="note__label__other">
                            <xsl:choose>
                                <xsl:when test="@othertype">
                                    <xsl:value-of select="@othertype"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>[</xsl:text>
                                    <xsl:value-of select="@type"/>
                                    <xsl:text>]</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:inline>
                    </xsl:when>
                </xsl:choose>
                <xsl:text>: </xsl:text>
            </fo:inline>
            <xsl:text>  </xsl:text>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
	
	<xsl:template match="*[contains(@class,' topic/note ')]">
        <xsl:variable name="noteType">
            <xsl:choose>
                <xsl:when test="@type">
                    <xsl:value-of select="@type"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'note'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="noteImagePath">
            <xsl:call-template name="insertVariable">
                <xsl:with-param name="theVariableID" select="concat($noteType, ' Note Image Path')"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not($noteImagePath = '')">
                <fo:table xsl:use-attribute-sets="note__table">
                    <fo:table-column column-number="1"/>
                    <fo:table-column column-number="2"/>
                    <fo:table-body>
                        <fo:table-row>
                                <fo:table-cell xsl:use-attribute-sets="note__image__entry">
                                    <fo:block>
                                        <fo:external-graphic src="url({concat($artworkPrefix, $noteImagePath)})" xsl:use-attribute-sets="image"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="note__text__entry">
                                    <xsl:call-template name="placeNoteContent"/>
                                </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="placeNoteContent"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	

	<xsl:template match="*[contains(@class,' topic/fig ')]">
        <fo:block xsl:use-attribute-sets="fig" id="{@id}">
			<xsl:if test="./parent::*[name()='body']">
                <xsl:attribute name="margin-left">45mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="./ancestor::*[name()='section']">
                <xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>
            <xsl:apply-templates select="*[contains(@class,' topic/title ')]"/>
            <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
        </fo:block>
    </xsl:template>
	

	
 	<!-- Add in the left margin to display in two columns of elements without a title (without using tables) for "ul" lists -->
	<xsl:template match="//*[contains(@class,' topic/body ')]/ul">
        <fo:list-block>
			<xsl:attribute name="margin-left">45mm</xsl:attribute>
            <xsl:apply-templates/>
        </fo:list-block>
    </xsl:template>
	
	<!-- Add in the left margin to display in two columns of elements without a title (without using tables) for "ol" lists -->
	<xsl:template match="//*[contains(@class,' topic/body ')]/ol">
        <fo:list-block>
			<xsl:attribute name="margin-left">45mm</xsl:attribute>
            <xsl:apply-templates/>
        </fo:list-block>
    </xsl:template>
	
	<!-- Add in the left margin to display in two columns of elements without a title (without using tables) for tables -->
	<xsl:template match="//*[contains(@class,' topic/body ')]/*[contains(@class,' topic/table ')]">
        <fo:block>
			<xsl:attribute name="margin-left">45mm</xsl:attribute>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>	
	
	<xsl:template match="//*[contains(@oid, 'metadata')]"></xsl:template>
</xsl:stylesheet>
