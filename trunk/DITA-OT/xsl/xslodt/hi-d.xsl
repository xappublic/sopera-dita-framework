<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
     Sourceforge.net. See the accompanying license.txt file for 
     applicable licenses.-->
<!-- (c) Copyright IBM Corp. 2005 All Rights Reserved. -->

<xsl:stylesheet
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
     xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
     xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
     xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
     xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
     xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
     xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/"
     xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
     xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0"
     xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
     xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0"
     xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0"
     xmlns:math="http://www.w3.org/1998/Math/MathML"
     xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0"
     xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
     xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms"
     xmlns:xsd="http://www.w3.org/2001/XMLSchema"
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xmlns:anim="urn:oasis:names:tc:opendocument:xmlns:animation:1.0"
     xmlns:smil="urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0"
     xmlns:prodtools="http://www.ibm.com/xmlns/prodtools"
     version="1.0">

<xsl:output method="xml"/>
<xsl:output indent="yes"/>
<xsl:strip-space elements="*"/>

<xsl:template match="*[contains(@class,' hi-d/b ')]">
     <xsl:element name="text:span">
          <xsl:attribute name="text:style-name">bold</xsl:attribute>
          <xsl:apply-templates/>
     </xsl:element>
</xsl:template>

<xsl:template match="*[contains(@class,' hi-d/i ')]">
     
     <xsl:choose>
          <xsl:when test="parent::*[contains(@class, ' topic/li ')]">
               <xsl:element name="text:p">
                    <xsl:element name="text:span">
                         <xsl:attribute name="text:style-name">italic</xsl:attribute>
                         <xsl:apply-templates/>
                    </xsl:element>
               </xsl:element>
          </xsl:when>
          <!-- nested by entry -->
          <xsl:when test="parent::*[contains(@class, ' topic/entry ')]">
               <!-- create p tag -->
               <xsl:element name="text:p">
                    <!-- alignment styles -->
                    <xsl:if test="parent::*[contains(@class, ' topic/entry ')]/@align">
                         <xsl:call-template name="set_align_value"/>
                    </xsl:if>
                    <!-- cell belongs to thead -->
                    <xsl:choose>
                         <xsl:when test="parent::*[contains(@class, ' topic/entry ')]
                              /parent::*[contains(@class, ' topic/row ')]/parent::*[contains(@class, ' topic/thead ')]">
                              <xsl:element name="text:span">
                                   <xsl:attribute name="text:style-name">bold</xsl:attribute>
                                   <xsl:element name="text:span">
                                        <xsl:attribute name="text:style-name">italic</xsl:attribute>
                                        <xsl:apply-templates/>
                                   </xsl:element>
                              </xsl:element>
                         </xsl:when>
                         <xsl:otherwise>
                              <xsl:element name="text:span">
                                   <xsl:attribute name="text:style-name">italic</xsl:attribute>
                                   <xsl:apply-templates/>
                              </xsl:element>
                         </xsl:otherwise>
                    </xsl:choose>
               </xsl:element>
          </xsl:when>
          <!-- nested by stentry -->
          <xsl:when test="parent::*[contains(@class, ' topic/stentry ')]">
               <xsl:element name="text:p">
                    <!-- cell belongs to sthead -->
                    <xsl:choose>
                         <xsl:when test="parent::*[contains(@class, ' topic/stentry ')]/
                              parent::*[contains(@class, ' topic/sthead ')]">
                              <xsl:element name="text:span">
                                   <xsl:attribute name="text:style-name">bold</xsl:attribute>
                                   <xsl:element name="text:span">
                                        <xsl:attribute name="text:style-name">italic</xsl:attribute>
                                        <xsl:apply-templates/>
                                   </xsl:element>
                              </xsl:element>
                         </xsl:when>
                         <xsl:otherwise>
                              <xsl:element name="text:span">
                                   <xsl:attribute name="text:style-name">italic</xsl:attribute>
                                   <xsl:apply-templates/>
                              </xsl:element>
                         </xsl:otherwise>
                    </xsl:choose>
               </xsl:element>
          </xsl:when>
          <!-- nested by other tags -->
          <xsl:otherwise>
               <xsl:element name="text:span">
                    <xsl:attribute name="text:style-name">italic</xsl:attribute>
                    <xsl:apply-templates/>
               </xsl:element>
          </xsl:otherwise>
     </xsl:choose>
     
</xsl:template>

<xsl:template match="*[contains(@class,' hi-d/u ')]">
     
     <xsl:choose>
          <xsl:when test="parent::*[contains(@class, ' topic/li ')]">
               <xsl:element name="text:p">
                    <xsl:element name="text:span">
                         <xsl:attribute name="text:style-name">underline</xsl:attribute>
                         <xsl:apply-templates/>
                    </xsl:element>
               </xsl:element>
          </xsl:when>
          <!-- nested by entry -->
          <xsl:when test="parent::*[contains(@class, ' topic/entry ')]">
               <!-- create p tag -->
               <xsl:element name="text:p">
                    <!-- alignment styles -->
                    <xsl:if test="parent::*[contains(@class, ' topic/entry ')]/@align">
                         <xsl:call-template name="set_align_value"/>
                    </xsl:if>
                    <!-- cell belongs to thead -->
                    <xsl:choose>
                         <xsl:when test="parent::*[contains(@class, ' topic/entry ')]
                              /parent::*[contains(@class, ' topic/row ')]/parent::*[contains(@class, ' topic/thead ')]">
                              <xsl:element name="text:span">
                                   <xsl:attribute name="text:style-name">bold</xsl:attribute>
                                   <xsl:element name="text:span">
                                        <xsl:attribute name="text:style-name">underline</xsl:attribute>
                                        <xsl:apply-templates/>
                                   </xsl:element>
                              </xsl:element>
                         </xsl:when>
                         <xsl:otherwise>
                              <xsl:element name="text:span">
                                   <xsl:attribute name="text:style-name">underline</xsl:attribute>
                                   <xsl:apply-templates/>
                              </xsl:element>
                         </xsl:otherwise>
                    </xsl:choose>
               </xsl:element>
          </xsl:when>
          <!-- nested by stentry -->
          <xsl:when test="parent::*[contains(@class, ' topic/stentry ')]">
               <xsl:element name="text:p">
                    <!-- cell belongs to sthead -->
                    <xsl:choose>
                         <xsl:when test="parent::*[contains(@class, ' topic/stentry ')]/
                              parent::*[contains(@class, ' topic/sthead ')]">
                              <xsl:element name="text:span">
                                   <xsl:attribute name="text:style-name">bold</xsl:attribute>
                                   <xsl:element name="text:span">
                                        <xsl:attribute name="text:style-name">underline</xsl:attribute>
                                        <xsl:apply-templates/>
                                   </xsl:element>
                              </xsl:element>
                         </xsl:when>
                         <xsl:otherwise>
                              <xsl:element name="text:span">
                                   <xsl:attribute name="text:style-name">underline</xsl:attribute>
                                   <xsl:apply-templates/>
                              </xsl:element>
                         </xsl:otherwise>
                    </xsl:choose>
               </xsl:element>
          </xsl:when>
          <!-- nested by other tags -->
          <xsl:otherwise>
               <xsl:element name="text:span">
                    <xsl:attribute name="text:style-name">underline</xsl:attribute>
                    <xsl:apply-templates/>
               </xsl:element>
          </xsl:otherwise>
     </xsl:choose>
     
</xsl:template>

<xsl:template match="*[contains(@class,' hi-d/tt ')]">
     
     <xsl:choose>
          <xsl:when test="parent::*[contains(@class, ' topic/li ')]">
               <xsl:element name="text:p">
                    <xsl:element name="text:span">
                         <xsl:attribute name="text:style-name">bold</xsl:attribute>
                         <xsl:apply-templates/>
                    </xsl:element>
               </xsl:element>
          </xsl:when>
          <!-- nested by entry -->
          <xsl:when test="parent::*[contains(@class, ' topic/entry ')]">
               <!-- create p tag -->
               <xsl:element name="text:p">
                    <!-- alignment styles -->
                    <xsl:if test="parent::*[contains(@class, ' topic/entry ')]/@align">
                         <xsl:call-template name="set_align_value"/>
                    </xsl:if>
                    
                    <xsl:element name="text:span">
                         <xsl:attribute name="text:style-name">bold</xsl:attribute>
                         <xsl:apply-templates/>
                    </xsl:element>
               </xsl:element>
          </xsl:when>
          <!-- nested by stentry -->
          <xsl:when test="parent::*[contains(@class, ' topic/stentry ')]">
               <xsl:element name="text:p">
                    <xsl:element name="text:span">
                         <xsl:attribute name="text:style-name">bold</xsl:attribute>
                         <xsl:apply-templates/>
                    </xsl:element>
               </xsl:element>
          </xsl:when>
          <!-- nested by other tags -->
          <xsl:otherwise>
               <xsl:element name="text:span">
                    <xsl:attribute name="text:style-name">bold</xsl:attribute>
                    <xsl:apply-templates/>
               </xsl:element>
          </xsl:otherwise>
     </xsl:choose>
     
</xsl:template>

<xsl:template match="*[contains(@class,' hi-d/sup ')]">
     
     <xsl:choose>
          <xsl:when test="parent::*[contains(@class, ' topic/li ')]">
               <xsl:element name="text:p">
                    <xsl:element name="text:span">
                         <xsl:attribute name="text:style-name">sup</xsl:attribute>
                         <xsl:apply-templates/>
                    </xsl:element>
               </xsl:element>
          </xsl:when>
          <!-- nested by entry -->
          <xsl:when test="parent::*[contains(@class, ' topic/entry ')]">
               <!-- create p tag -->
               <xsl:element name="text:p">
                    <!-- alignment styles -->
                    <xsl:if test="parent::*[contains(@class, ' topic/entry ')]/@align">
                         <xsl:call-template name="set_align_value"/>
                    </xsl:if>
                    <!-- cell belongs to thead -->
                    <xsl:choose>
                         <xsl:when test="parent::*[contains(@class, ' topic/entry ')]
                              /parent::*[contains(@class, ' topic/row ')]/parent::*[contains(@class, ' topic/thead ')]">
                              <xsl:element name="text:span">
                                   <xsl:attribute name="text:style-name">bold</xsl:attribute>
                                   <xsl:element name="text:span">
                                        <xsl:attribute name="text:style-name">sup</xsl:attribute>
                                        <xsl:apply-templates/>
                                   </xsl:element>
                              </xsl:element>
                         </xsl:when>
                         <xsl:otherwise>
                              <xsl:element name="text:span">
                                   <xsl:attribute name="text:style-name">sup</xsl:attribute>
                                   <xsl:apply-templates/>
                              </xsl:element>
                         </xsl:otherwise>
                    </xsl:choose>
               </xsl:element>
          </xsl:when>
          <!-- nested by stentry -->
          <xsl:when test="parent::*[contains(@class, ' topic/stentry ')]">
               <xsl:element name="text:p">
                    <!-- cell belongs to sthead -->
                    <xsl:choose>
                         <xsl:when test="parent::*[contains(@class, ' topic/stentry ')]/
                              parent::*[contains(@class, ' topic/sthead ')]">
                              <xsl:element name="text:span">
                                   <xsl:attribute name="text:style-name">bold</xsl:attribute>
                                   <xsl:element name="text:span">
                                        <xsl:attribute name="text:style-name">sup</xsl:attribute>
                                        <xsl:apply-templates/>
                                   </xsl:element>
                              </xsl:element>
                         </xsl:when>
                         <xsl:otherwise>
                              <xsl:element name="text:span">
                                   <xsl:attribute name="text:style-name">sup</xsl:attribute>
                                   <xsl:apply-templates/>
                              </xsl:element>
                         </xsl:otherwise>
                    </xsl:choose>
               </xsl:element>
          </xsl:when>
          <!-- nested by other tags -->
          <xsl:otherwise>
               <xsl:element name="text:span">
                    <xsl:attribute name="text:style-name">sup</xsl:attribute>
                    <xsl:apply-templates/>
               </xsl:element>
          </xsl:otherwise>
     </xsl:choose>
     
</xsl:template>

<xsl:template match="*[contains(@class,' hi-d/sub ')]">
     
     <xsl:choose>
          <xsl:when test="parent::*[contains(@class, ' topic/li ')]">
               <xsl:element name="text:p">
                    <xsl:element name="text:span">
                         <xsl:attribute name="text:style-name">sub</xsl:attribute>
                         <xsl:apply-templates/>
                    </xsl:element>
               </xsl:element>
          </xsl:when>
          <!-- nested by entry -->
          <xsl:when test="parent::*[contains(@class, ' topic/entry ')]">
               <!-- create p tag -->
               <xsl:element name="text:p">
                    <!-- alignment styles -->
                    <xsl:if test="parent::*[contains(@class, ' topic/entry ')]/@align">
                         <xsl:call-template name="set_align_value"/>
                    </xsl:if>
                    <!-- cell belongs to thead -->
                    <xsl:choose>
                         <xsl:when test="parent::*[contains(@class, ' topic/entry ')]
                              /parent::*[contains(@class, ' topic/row ')]/parent::*[contains(@class, ' topic/thead ')]">
                              <xsl:element name="text:span">
                                   <xsl:attribute name="text:style-name">bold</xsl:attribute>
                                   <xsl:element name="text:span">
                                        <xsl:attribute name="text:style-name">sub</xsl:attribute>
                                        <xsl:apply-templates/>
                                   </xsl:element>
                              </xsl:element>
                         </xsl:when>
                         <xsl:otherwise>
                              <xsl:element name="text:span">
                                   <xsl:attribute name="text:style-name">sub</xsl:attribute>
                                   <xsl:apply-templates/>
                              </xsl:element>
                         </xsl:otherwise>
                    </xsl:choose>
               </xsl:element>
          </xsl:when>
          <!-- nested by stentry -->
          <xsl:when test="parent::*[contains(@class, ' topic/stentry ')]">
               <xsl:element name="text:p">
                    <!-- cell belongs to sthead -->
                    <xsl:choose>
                         <xsl:when test="parent::*[contains(@class, ' topic/stentry ')]/
                              parent::*[contains(@class, ' topic/sthead ')]">
                              <xsl:element name="text:span">
                                   <xsl:attribute name="text:style-name">bold</xsl:attribute>
                                   <xsl:element name="text:span">
                                        <xsl:attribute name="text:style-name">sub</xsl:attribute>
                                        <xsl:apply-templates/>
                                   </xsl:element>
                              </xsl:element>
                         </xsl:when>
                         <xsl:otherwise>
                              <xsl:element name="text:span">
                                   <xsl:attribute name="text:style-name">sub</xsl:attribute>
                                   <xsl:apply-templates/>
                              </xsl:element>
                         </xsl:otherwise>
                    </xsl:choose>
               </xsl:element>
          </xsl:when>
          <!-- nested by other tags -->
          <xsl:otherwise>
               <xsl:element name="text:span">
                    <xsl:attribute name="text:style-name">sub</xsl:attribute>
                    <xsl:apply-templates/>
               </xsl:element>
          </xsl:otherwise>
     </xsl:choose>    
     
</xsl:template>

</xsl:stylesheet>