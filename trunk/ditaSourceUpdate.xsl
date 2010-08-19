<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output doctype-public="-//OASIS//DTD DITA 1.2 Topic//EN" doctype-system="../../DITA-OT1.5.1/dtd/technicalContent/dtd/topic.dtd" method="xml" indent="yes"/>
	<xsl:template name="copyDoc">
		<xsl:choose>
			<xsl:when test="self::node()[not((descendant::topic) or (descendant::concept) or (descendant::task) or (descendant::reference) or (descendant::glossary))]">
				<xsl:copy-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="href" select="@id"/>
				<xsl:result-document href="{$href}.ditamap" doctype-public="-//OASIS//DTD DITA Map//EN" doctype-system="../../DITA-OT1.5.1/dtd/technicalContent/dtd/map.dtd" indent="yes" method="xml" encoding="UTF-8">
					<map>
						<xsl:element name="topicref">
							<xsl:attribute name="href">
									<xsl:value-of select="@id"/>
									<xsl:text>.xml</xsl:text>
							</xsl:attribute>
							<xsl:for-each select="(descendant::topic) | (descendant::concept) | (descendant::task) | (descendant::reference) | (descendant::glossary)">
								<xsl:element name="topicref">
									<xsl:attribute name="href">
										<xsl:value-of select="@id"/>
										<xsl:text>.xml</xsl:text>
									</xsl:attribute>
								</xsl:element> 
							</xsl:for-each>
						</xsl:element>
					</map>
				</xsl:result-document>
				<xsl:result-document href="{$href}.tmp" doctype-public="-//OASIS//DTD DITA 1.2 Topic//EN" doctype-system="../../DITA-OT1.5.1/dtd/technicalContent/dtd/topic.dtd" indent="yes" method="xml" encoding="UTF-8">
					<xsl:element name="{local-name(.)}">
						<xsl:attribute name="id">
							<xsl:value-of select="@id"/>
						</xsl:attribute>
						<xsl:apply-templates mode="noChild"/>
					</xsl:element>
				</xsl:result-document>
				<xsl:for-each select="(descendant::topic) | (descendant::concept) | (descendant::task) | (descendant::reference) | (descendant::glossary)">
					<xsl:variable name="href" select="@id"/>
					<xsl:result-document href="{$href}.xml" doctype-public="-//OASIS//DTD DITA 1.2 Topic//EN" doctype-system="../../DITA-OT1.5.1/dtd/technicalContent/dtd/topic.dtd" indent="yes" method="xml" encoding="UTF-8">
						<xsl:element name="{local-name(.)}">
							<xsl:attribute name="id">
								<xsl:value-of select="@id"/>
							</xsl:attribute>
							<xsl:apply-templates mode="noChild"/>
						</xsl:element>
					</xsl:result-document>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="topic">
		<xsl:call-template name="copyDoc"/>
	</xsl:template>
	<xsl:template match="concept">
		<xsl:call-template name="copyDoc"/>
	</xsl:template>
	<xsl:template match="task">
		<xsl:call-template name="copyDoc"/>
	</xsl:template>
	<xsl:template match="reference">
		<xsl:call-template name="copyDoc"/>
	</xsl:template>
	<xsl:template match="glossary">
		<xsl:call-template name="copyDoc"/>
	</xsl:template>
	<xsl:template match="topic" mode="noChild">
	</xsl:template>
	<xsl:template match="task" mode="noChild">
	</xsl:template>
	<xsl:template match="concept" mode="noChild">
	</xsl:template>
	<xsl:template match="reference" mode="noChild">
	</xsl:template>
	<xsl:template match="glossary" mode="noChild">
	</xsl:template>
	<xsl:template match="*" mode="noChild">
		<xsl:copy-of select="."/>
	</xsl:template>
</xsl:stylesheet>