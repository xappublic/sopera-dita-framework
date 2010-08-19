<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output doctype-public="-//OASIS//DTD DITA Map//EN" doctype-system="../../DITA-OT1.5.1/dtd/technicalContent/dtd/map.dtd" method="xml" indent="yes"/>
	<xsl:template match="map">
		<map>
			<xsl:apply-templates/>
		</map>
	</xsl:template>
	<xsl:template match="dita">
		<map>
			<xsl:apply-templates/>
		</map>
	</xsl:template>
	<xsl:template match="reference">
		<xsl:element name="topicref">
			<xsl:attribute name="href"><xsl:value-of select="@conref"/></xsl:attribute>
		</xsl:element>
	</xsl:template>
	<xsl:template match="concept">
		<xsl:element name="topicref">
			<xsl:attribute name="href"><xsl:value-of select="@conref"/></xsl:attribute>
		</xsl:element>
	</xsl:template>
	<xsl:template match="task">
		<xsl:element name="topicref">
			<xsl:attribute name="href"><xsl:value-of select="@conref"/></xsl:attribute>
		</xsl:element>
	</xsl:template>
	<xsl:template match="topic">
		<xsl:element name="topicref">
			<xsl:attribute name="href"><xsl:value-of select="@conref"/></xsl:attribute>
		</xsl:element>
	</xsl:template>
	<xsl:template match="topicref">
		<xsl:element name="topicref">
			<xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
