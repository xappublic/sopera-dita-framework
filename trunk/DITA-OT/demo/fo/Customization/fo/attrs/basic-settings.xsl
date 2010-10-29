<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- The default of 215.9mm x 279.4mm is US Letter size (8.5x11in) -->
    <xsl:variable name="page-width">210mm</xsl:variable>
    <xsl:variable name="page-height">297mm</xsl:variable>

    <!-- This is the default, but you can set the margins individually below. -->
    <xsl:variable name="page-margins">20mm</xsl:variable>
    
    <!-- Change these if your page has different margins on different sides. -->
    <xsl:variable name="page-margin-left">10mm</xsl:variable>
    <xsl:variable name="page-margin-right">20mm</xsl:variable>
    <xsl:variable name="page-margin-top">60pt</xsl:variable>
    <xsl:variable name="page-margin-bottom">20mm</xsl:variable>

</xsl:stylesheet>