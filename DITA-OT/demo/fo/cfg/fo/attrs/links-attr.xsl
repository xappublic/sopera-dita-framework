<?xml version="1.0"?>

<!-- 
Copyright © 2004-2006 by Idiom Technologies, Inc. All rights reserved. 
IDIOM is a registered trademark of Idiom Technologies, Inc. and WORLDSERVER
and WORLDSTART are trademarks of Idiom Technologies, Inc. All other 
trademarks are the property of their respective owners. 

IDIOM TECHNOLOGIES, INC. IS DELIVERING THE SOFTWARE &quot;AS IS,&quot; WITH 
ABSOLUTELY NO WARRANTIES WHATSOEVER, WHETHER EXPRESS OR IMPLIED,  AND IDIOM
TECHNOLOGIES, INC. DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING
BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
PURPOSE AND WARRANTY OF NON-INFRINGEMENT. IDIOM TECHNOLOGIES, INC. SHALL NOT
BE LIABLE FOR INDIRECT, INCIDENTAL, SPECIAL, COVER, PUNITIVE, EXEMPLARY,
RELIANCE, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF 
ANTICIPATED PROFIT), ARISING FROM ANY CAUSE UNDER OR RELATED TO  OR ARISING 
OUT OF THE USE OF OR INABILITY TO USE THE SOFTWARE, EVEN IF IDIOM
TECHNOLOGIES, INC. HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. 

Idiom Technologies, Inc. and its licensors shall not be liable for any
damages suffered by any person as a result of using and/or modifying the
Software or its derivatives. In no event shall Idiom Technologies, Inc.&apos;s
liability for any damages hereunder exceed the amounts received by Idiom
Technologies, Inc. as a result of this transaction.

These terms and conditions supersede the terms and conditions in any
licensing agreement to the extent that such terms and conditions conflict
with those set forth herein.

This file is part of the DITA Open Toolkit project hosted on Sourceforge.net. 
See the accompanying license.txt file for applicable licenses.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0">

    <xsl:attribute-set name="linklist">
    </xsl:attribute-set>

    <xsl:attribute-set name="linkpool">
    </xsl:attribute-set>

    <xsl:attribute-set name="linktext">
    </xsl:attribute-set>

    <xsl:attribute-set name="related-links">
        <xsl:attribute name="space-after.optimum">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="related-links__content">
        <xsl:attribute name="start-indent">25pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="related-links.ul">
		<xsl:attribute name="provisional-distance-between-starts">5mm</xsl:attribute>
		<xsl:attribute name="provisional-label-separation">1mm</xsl:attribute>
		<xsl:attribute name="space-after.optimum">7pt</xsl:attribute>
		<xsl:attribute name="space-before.optimum">7pt</xsl:attribute>
		<xsl:attribute name="start-indent">25pt</xsl:attribute>
	</xsl:attribute-set>

    <xsl:attribute-set name="related-links.ul.li">
		<xsl:attribute name="space-after.optimum">1.5pt</xsl:attribute>
		<xsl:attribute name="space-before.optimum">1.5pt</xsl:attribute>
	</xsl:attribute-set>

    <xsl:attribute-set name="related-links.ul.li__label">
		<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
		<xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
		<xsl:attribute name="end-indent">label-end()</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="related-links.ul.li__label__content">
		<xsl:attribute name="text-align">left</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="related-links.ul.li__body">
		<xsl:attribute name="start-indent">body-start()</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="related-links.ul.li__content">
	</xsl:attribute-set>

	<xsl:attribute-set name="related-links.ol">
		<xsl:attribute name="provisional-distance-between-starts">5mm</xsl:attribute>
		<xsl:attribute name="provisional-label-separation">1mm</xsl:attribute>
		<xsl:attribute name="space-after.optimum">7pt</xsl:attribute>
		<xsl:attribute name="space-before.optimum">7pt</xsl:attribute>
		<xsl:attribute name="start-indent">25pt</xsl:attribute>
	</xsl:attribute-set>

    <xsl:attribute-set name="related-links.ol.li">
		<xsl:attribute name="space-after.optimum">1.5pt</xsl:attribute>
		<xsl:attribute name="space-before.optimum">1.5pt</xsl:attribute>
	</xsl:attribute-set>

    <xsl:attribute-set name="related-links.ol.li__label">
		<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
		<xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
		<xsl:attribute name="end-indent">label-end()</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="related-links.ol.li__label__content">
		<xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="related-links.ol.li__body">
		<xsl:attribute name="start-indent">body-start()</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="related-links.ol.li__content">
	</xsl:attribute-set>

    <xsl:attribute-set name="related-links.title">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

    <xsl:attribute-set name="linkinfo">
    </xsl:attribute-set>

    <xsl:attribute-set name="linkinfo">
    </xsl:attribute-set>

    <xsl:attribute-set name="linkinfo">
    </xsl:attribute-set>

    <xsl:attribute-set name="linkinfo">
    </xsl:attribute-set>

    <xsl:attribute-set name="linkinfo">
    </xsl:attribute-set>

    <xsl:attribute-set name="linkinfo">
    </xsl:attribute-set>

    <xsl:attribute-set name="link">
        <xsl:attribute name="space-after.optimum">2pt</xsl:attribute>
        <xsl:attribute name="space-before.optimum">2pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="link__content">
        <xsl:attribute name="color">blue</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
        <!--<xsl:attribute name="margin-left">8pt</xsl:attribute>-->
    </xsl:attribute-set>

    <xsl:attribute-set name="link__shortdesc">
        <xsl:attribute name="margin-left">15pt</xsl:attribute>
        <xsl:attribute name="font-size"><xsl:value-of select="$default-font-size"/></xsl:attribute>
        <xsl:attribute name="space-after.optimum">5pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="linkpool">
    </xsl:attribute-set>

    <xsl:attribute-set name="xref">
        <xsl:attribute name="color">blue</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>