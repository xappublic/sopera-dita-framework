<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="1.0">

    <xsl:attribute-set name="__body__odd__footer">
        <xsl:attribute name="text-align">right</xsl:attribute>
		<xsl:attribute name="margin-right">0pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">15pt</xsl:attribute>
		<xsl:attribute name="margin-left">20mm</xsl:attribute>
		<xsl:attribute name="margin-right">20mm</xsl:attribute>
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-width">1pt</xsl:attribute>
        <xsl:attribute name="border-top-color">gray</xsl:attribute>
		<xsl:attribute name="text-align-last">justify</xsl:attribute>
		<xsl:attribute name="font-size">9pt</xsl:attribute>
		<xsl:attribute name="padding-top">1mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__body__even__footer">
        <xsl:attribute name="margin-left">0pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">15pt</xsl:attribute>
		<xsl:attribute name="margin-left">20mm</xsl:attribute>
		<xsl:attribute name="margin-right">20mm</xsl:attribute>	
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-width">1pt</xsl:attribute>
        <xsl:attribute name="border-top-color">gray</xsl:attribute>
		<xsl:attribute name="text-align-last">justify</xsl:attribute>
		<xsl:attribute name="font-size">9pt</xsl:attribute>
		<xsl:attribute name="padding-top">1mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__body__odd__header">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="margin-right">0pt</xsl:attribute>
        <xsl:attribute name="margin-top">35pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">15mm</xsl:attribute>
		<xsl:attribute name="margin-left">20mm</xsl:attribute>
		<xsl:attribute name="margin-right">20mm</xsl:attribute>	
		<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
        <xsl:attribute name="border-top-color">gray</xsl:attribute>
		<xsl:attribute name="font-size">9pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__body__even__header">
        <xsl:attribute name="margin-left">0pt</xsl:attribute>
        <xsl:attribute name="margin-top">35pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">15mm</xsl:attribute>
		<xsl:attribute name="margin-left">20mm</xsl:attribute>
		<xsl:attribute name="margin-right">20mm</xsl:attribute>	
        <xsl:attribute name="padding-bottom">1mm</xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
        <xsl:attribute name="border-top-color">gray</xsl:attribute>
		<xsl:attribute name="font-size">9pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__body__first__header">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="margin-right">0pt</xsl:attribute>
        <xsl:attribute name="margin-top">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__odd__footer">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="margin-right">0pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__odd__footer__pagenum">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__even__footer">
        <xsl:attribute name="margin-left">0pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__even__footer__pagenum">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__odd__header">
        <xsl:attribute name="text-align">right</xsl:attribute>        
        <xsl:attribute name="margin-top">35pt</xsl:attribute>
		<xsl:attribute name="margin-left">20mm</xsl:attribute>
		<xsl:attribute name="margin-right">20mm</xsl:attribute>	
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__odd__header__pagenum">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__even__header">
        <xsl:attribute name="margin-top">35pt</xsl:attribute>
		<xsl:attribute name="margin-left">20mm</xsl:attribute>
		<xsl:attribute name="margin-right">20mm</xsl:attribute>	
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__even__header__pagenum">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

        <xsl:attribute-set name="__index__odd__footer">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="margin-right">0pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__index__odd__footer__pagenum">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__index__even__footer">
        <xsl:attribute name="margin-left">0pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__index__even__footer__pagenum">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__index__odd__header">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="margin-right">0pt</xsl:attribute>
        <xsl:attribute name="margin-top">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__index__odd__header__pagenum">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__index__even__header">
        <xsl:attribute name="margin-left">0pt</xsl:attribute>
        <xsl:attribute name="margin-top">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__body__footnote__separator">
        <xsl:attribute name="leader-pattern">rule</xsl:attribute>
        <xsl:attribute name="leader-length">25%</xsl:attribute>
        <xsl:attribute name="rule-thickness">0.5pt</xsl:attribute>
        <xsl:attribute name="rule-style">solid</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__chapter__frontmatter__name__container">
        <xsl:attribute name="font-size">20pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-width">2pt</xsl:attribute>
        <xsl:attribute name="border-bottom-width">2pt</xsl:attribute>
        <xsl:attribute name="padding-top">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__chapter__frontmatter__number__container">
        <xsl:attribute name="font-size">40pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>