<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:anim="urn:oasis:names:tc:opendocument:xmlns:animation:1.0" xmlns:smil="urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0" xmlns:prodtools="http://www.ibm.com/xmlns/prodtools" xmlns:random="org.dita.dost.util.RandomUtils" exclude-result-prefixes="random" version="1.0">
  
  
  <xsl:import href="common/output-message.xsl"></xsl:import>
  <xsl:import href="common/dita-utilities.xsl"></xsl:import>
  <xsl:import href="common/related-links.xsl"></xsl:import>
  <xsl:import href="xslodt/flag-old.xsl"></xsl:import>
  <xsl:import href="xslodt/dita2odt-utilities.xsl"></xsl:import>
  <xsl:import href="xslodt/dita2odt-table.xsl"></xsl:import>
  <xsl:import href="xslodt/dita2odt-lists.xsl"></xsl:import>
  <xsl:import href="xslodt/dita2odt-img.xsl"></xsl:import>
  
  <xsl:import href="xslodt/dita2odt-map.xsl"></xsl:import>
  <xsl:import href="xslodt/dita2odtImpl.xsl"></xsl:import>
  <xsl:import href="xslodt/dita2odt-concept.xsl"></xsl:import>
  <xsl:import href="xslodt/dita2odt-gloss.xsl"></xsl:import>
  <xsl:import href="xslodt/dita2odt-task.xsl"></xsl:import>
  <xsl:import href="xslodt/dita2odt-reference.xsl"></xsl:import>
  <xsl:import href="xslodt/hi-d.xsl"></xsl:import>
  <xsl:import href="xslodt/pr-d.xsl"></xsl:import>
  <xsl:import href="xslodt/sw-d.xsl"></xsl:import>
  <xsl:import href="xslodt/ui-d.xsl"></xsl:import>
  
  <xsl:include href="xslodt/dita2odt-relinks.xsl"></xsl:include>
  <xsl:include href="xslodt/flag.xsl"></xsl:include>
  

<xsl:param name="disableRelatedLinks" select="'no'"></xsl:param>

<xsl:output method="xml" encoding="UTF-8" indent="yes"></xsl:output>
<xsl:strip-space elements="*"></xsl:strip-space>

  <xsl:attribute-set name="root">
    <xsl:attribute name="office:version">1.1</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:template match="/">
    <office:document-content xsl:use-attribute-sets="root">
      <xsl:call-template name="root"></xsl:call-template>
    </office:document-content>
  </xsl:template>
  
  <xsl:template name="root">
    
    <office:scripts></office:scripts>
    <xsl:choose>
      <xsl:when test="//*[contains(@class, ' topic/table ')]|//*[contains(@class, ' topic/simpletable ')]">
        <office:automatic-styles>
          <xsl:call-template name="create_table_cell_styles"></xsl:call-template>
        </office:automatic-styles>
      </xsl:when>
    </xsl:choose>
    <office:body>
      <office:text>
        <text:sequence-decls>
          <text:sequence-decl text:display-outline-level="0" text:name="Illustration"></text:sequence-decl>
          <text:sequence-decl text:display-outline-level="0" text:name="Table"></text:sequence-decl>
          <text:sequence-decl text:display-outline-level="0" text:name="Text"></text:sequence-decl>
          <text:sequence-decl text:display-outline-level="0" text:name="Drawing"></text:sequence-decl>
        </text:sequence-decls>
        <xsl:apply-templates></xsl:apply-templates>
      </office:text>
    </office:body>
  </xsl:template>
  

</xsl:stylesheet>