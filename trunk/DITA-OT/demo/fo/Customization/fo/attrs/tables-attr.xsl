<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0">

    <xsl:attribute-set name="table">
        <xsl:attribute name="font-size">10pt<!--xsl:value-of select="$default-font-size"/--></xsl:attribute>    
    </xsl:attribute-set>

    <xsl:attribute-set name="tgroup.tbody">
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="tgroup.thead">
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="tgroup.tfoot">
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="thead.row">
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="tfoot.row">
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="tbody.row">
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="thead.row.entry__content">
        <xsl:attribute name="start-indent">1pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="tbody.row.entry">
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="tbody.row.entry__content">
        <xsl:attribute name="start-indent">1pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="dl">
        <!--DL is a table-->
        <!--<xsl:attribute name="width">100%</xsl:attribute>-->
        <xsl:attribute name="space-before.optimum">5pt</xsl:attribute>
        <xsl:attribute name="space-after.optimum">5pt</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="margin-left">0pt</xsl:attribute>
		<xsl:attribute name="margin-right">0pt</xsl:attribute>
    </xsl:attribute-set>
	
    <xsl:attribute-set name="dl__body">
    </xsl:attribute-set>

    <xsl:attribute-set name="dl.dlhead">
    </xsl:attribute-set>
	
	<xsl:attribute-set name="dlentry.dt__content">
        <xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="margin-left">0pt</xsl:attribute>
		<xsl:attribute name="margin-right">0pt</xsl:attribute>
    </xsl:attribute-set>

	<xsl:attribute-set name="dlentry.dd__content">
        <xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="margin-left">0pt</xsl:attribute>
		<xsl:attribute name="margin-right">0pt</xsl:attribute>
    </xsl:attribute-set>
	
    <xsl:attribute-set name="dlhead.dthd__content">
        <xsl:attribute name="font-weight">normal</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="dlhead.ddhd__content">
        <xsl:attribute name="font-weight">normal</xsl:attribute>
    </xsl:attribute-set>
	
	<xsl:attribute-set name="dlentry.dt">
        <xsl:attribute name="relative-align">baseline</xsl:attribute>
		<xsl:attribute name="width">40mm</xsl:attribute>
		
		<xsl:attribute name="margin-left">0pt</xsl:attribute>
		<xsl:attribute name="margin-right">2pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="dlentry.dd">	
		<xsl:attribute name="margin-left">2pt</xsl:attribute>
		<xsl:attribute name="margin-right">0pt</xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>