<?xml version="1.0"?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
     Sourceforge.net. See the accompanying license.txt file for 
     applicable licenses.-->
<!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->

<!-- 
     Conversion from DITA map or maplist to HTML Help contents file.
     Input = one DITA map file, or a maplist pointing to multiple maps
     Output = one HHC contents file for use with the HTML Help compiler.
     
     Options:
        /OUTEXT  = XHTML output extension (default is '.html')
        /WORKDIR = The working directory that contains the document being transformed.
                   Needed as a directory prefix for the @href "document()" function calls. 
                   Default is './'

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
                xmlns:java="org.dita.dost.util.StringUtils"
                exclude-result-prefixes="java"
  >

<!-- Include error message template -->
<xsl:import href="common/output-message.xsl"/>

<xsl:output method="html" indent="no"/>

<!-- Set the prefix for error message numbers -->
<xsl:variable name="msgprefix">DOTX</xsl:variable>

<xsl:variable name="newline"><xsl:text>
</xsl:text></xsl:variable>

<!-- *************************** Command line parameters *********************** -->
<xsl:param name="FILEREF" select="'file://'"/>
<xsl:param name="OUTEXT" select="'.html'"/><!-- "htm" and "html" are valid values -->
<xsl:param name="WORKDIR" select="'./'"/>
<xsl:param name="DITAEXT" select="'.xml'"/>

<!-- *********************************************************************************
     Setup the HTML wrapper for the table of contents
     ********************************************************************************* -->
<xsl:template match="/">
  <xsl:value-of select="$newline"/>
  <html>
    <xsl:value-of select="$newline"/>
    <head>
      <xsl:value-of select="$newline"/>
      <xsl:comment> Sitemap 1.0 </xsl:comment>
      <xsl:value-of select="$newline"/>
    </head>
    <xsl:value-of select="$newline"/>
    <body>
      <xsl:apply-templates/>
      <xsl:value-of select="$newline"/>
    </body>
    <xsl:value-of select="$newline"/>
  </html>
</xsl:template>

<!-- *********************************************************************************
     If processing only a single map, setup the HTML wrapper and output the contents.
     Otherwise, just process the contents.
     ********************************************************************************* -->
<xsl:template match="/*[contains(@class, ' map/map ')]">
  <xsl:param name="pathFromMaplist"/>
  <xsl:if test=".//*[contains(@class, ' map/topicref ')][not(@toc='no')][not(@processing-role='resource-only')]">
    <xsl:value-of select="$newline"/>
    <UL>
      <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]">
        <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
      </xsl:apply-templates>
    </UL>
  </xsl:if>
</xsl:template>
<!-- *********************************************************************************
     Output each topic as an <OBJECT> in an <LI>. Each object takes 2 parameters:
     - A name must be given. If it is specified on <topicref>, use that, otherwise try
       to open the file and retrieve the title. First look for a navigation title,
       followed by the main topic title. Last, try to use <linktext> specified in the map.
       Failing that, use *** and issue a message.
     - An HREF is optional. If none is specified, this will generate a wrapper (which
       shows up as a book instead of a page in the HTML Help viewer). The HREF is only
       valid for inclusion in the HHC if it is not external, and if it points to a DITA
       or HTML file.
     
     If this topicref has any child topicref's that will be part of the navigation,
     output a <UL> around them and process the contents.
     
     Move the real work to the named template, to easily check @format for
     files that cannot be included.
     ********************************************************************************* -->
<xsl:template match="*[contains(@class, ' map/topicref ')]">
  <xsl:param name="pathFromMaplist"/>
  <xsl:choose>
    <!-- If TOC is no, go ahead and process children; if TOC is turned back on,
         those topics will rise to this level -->
    <xsl:when test="@toc='no' or @processing-role='resource-only'">
      <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]">
        <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
      </xsl:apply-templates>
    </xsl:when>
    <!-- If this this a container (no href or href='', no title), just process children -->
    <xsl:when test="(not(@href) or @href='') and not(@navtitle) and not(*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]) and
                    not(*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')])">
      <xsl:apply-templates select="*[contains(@class, ' map/topicref ')][not(contains(@toc,'no'))][not(@processing-role='resource-only')]">
        <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
      </xsl:apply-templates>
    </xsl:when>
    <!-- If this this a container (no href, with title), output a TOC node with
         the title, and process children -->
    <xsl:when test="not(@href)">
      <xsl:call-template name="output-toc-entry">
        <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="not(@format)">
      <xsl:call-template name="output-toc-entry">
        <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@format='dita' or @format='DITA'">
      <xsl:call-template name="output-toc-entry">
        <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="(contains(@format,'htm') or contains(@format,'HTM')) and (@scope='external' or @scope='peer')">
      <!-- The html file is not available, so of course it cannot be included -->
      <xsl:call-template name="output-toc-entry">
        <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
      </xsl:call-template>
    </xsl:when>    
    <xsl:when test="contains(@format,'htm') or contains(@format,'HTM')">
      <!-- Including a local HTML file: they must recompile to include it -->
      <xsl:call-template name="output-message">
        <xsl:with-param name="msgnum">048</xsl:with-param>
        <xsl:with-param name="msgsev">I</xsl:with-param>
        <xsl:with-param name="msgparams">%1=<xsl:value-of select="@href"/></xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="output-toc-entry">
        <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <!-- @format is not DITA and not HTML, so the target will be ignored for HTML Help -->
      <xsl:call-template name="output-message">
        <xsl:with-param name="msgnum">007</xsl:with-param>
        <xsl:with-param name="msgsev">I</xsl:with-param>
        <xsl:with-param name="msgparams">%1=<xsl:value-of select="@href"/></xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
    
<xsl:template match="processing-instruction('workdir')" mode="get-work-dir">
  <xsl:value-of select="."/><xsl:text>/</xsl:text>
</xsl:template>    
    
<xsl:template name="output-toc-entry">
  <xsl:param name="pathFromMaplist"/>
  <xsl:variable name="WORKDIR">
    <xsl:value-of select="$FILEREF"/>
    <xsl:apply-templates select="/processing-instruction()" mode="get-work-dir"/>
  </xsl:variable>
  <xsl:value-of select="$newline"/>
  <!-- if current node is not topicgroup and not empty or current node 
  is empty but there is a valid child, we will generate
  the entry in toc -->
  <xsl:if test="not(contains(@class,' mapgroup-d/topicgroup '))and (@href and not(@href='') or .//*[@href and not(@href='')])"> 
  <LI> <OBJECT type="text/sitemap">
        <xsl:element name="param">
          <xsl:attribute name="name">Name</xsl:attribute>
          <xsl:attribute name="value">
          <xsl:choose>
           
           <!-- If navtitle is specified, use it -->
            <xsl:when test="*[contains(@class,'- map/topicmeta ')]/*[contains(@class, '- topic/navtitle ')]">
              <xsl:value-of select="*[contains(@class,'- map/topicmeta ')]/*[contains(@class, '- topic/navtitle ')]"/>
            </xsl:when>            
            <xsl:when test="not(*[contains(@class,'- map/topicmeta ')]/*[contains(@class, '- topic/navtitle ')]) and @navtitle"><xsl:value-of select="@navtitle"/></xsl:when>

           <!-- If this references a DITA file (has @href, not "local" or "external"),
                try to open the file and get the title -->
           
           <xsl:when test="@href and not(@href='') and 
                           not ((ancestor-or-self::*/@scope)[last()]='external') and
                           not ((ancestor-or-self::*/@scope)[last()]='peer') and
                           not ((ancestor-or-self::*/@type)[last()]='external') and
                           not ((ancestor-or-self::*/@type)[last()]='local')">
             <!-- Need to worry about targeting a nested topic? Not for now. -->
             <!--<xsl:variable name="FileWithPath"><xsl:value-of select="$WORKDIR"/><xsl:choose>-->
               <xsl:variable name="FileWithPath"><xsl:choose>
               <xsl:when test="@copy-to"><xsl:value-of select="$WORKDIR"/><xsl:value-of select="@copy-to"/></xsl:when>
               <xsl:when test="contains(@href,'#')"><xsl:value-of select="$WORKDIR"/><xsl:value-of select="substring-before(@href,'#')"/></xsl:when>
               <xsl:otherwise><xsl:value-of select="$WORKDIR"/><xsl:value-of select="@href"/></xsl:otherwise></xsl:choose></xsl:variable>
             <xsl:variable name="TargetFile" select="document($FileWithPath,/)"/>
             
             <xsl:choose>
               <xsl:when test="not($TargetFile)">   <!-- DITA file does not exist -->
                 <xsl:choose>
                   <xsl:when test="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]">  <!-- attempt to recover by using linktext -->
                     <xsl:value-of select="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]"/>
                   </xsl:when>
                   <xsl:otherwise>
                     <xsl:call-template name="output-message">
                       <xsl:with-param name="msgnum">008</xsl:with-param>
                       <xsl:with-param name="msgsev">W</xsl:with-param>
                       <xsl:with-param name="msgparams">%1=<xsl:value-of select="@href"/></xsl:with-param>
                     </xsl:call-template>
                   </xsl:otherwise>
                 </xsl:choose>
               </xsl:when>
               <!-- First choice for navtitle: topic/titlealts/navtitle -->
               <xsl:when test="$TargetFile/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/titlealts ')]/*[contains(@class,' topic/navtitle ')]">
                 <xsl:value-of select="$TargetFile/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/titlealts ')]/*[contains(@class,' topic/navtitle ')]"/>
               </xsl:when>
               <!-- Second choice for navtitle: topic/title -->
               <xsl:when test="$TargetFile/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/title ')]">
                 <xsl:value-of select="$TargetFile/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/title ')]"/>
               </xsl:when>
               <!-- This might be a combo article; modify the same queries: dita/topic/titlealts/navtitle -->
               <xsl:when test="$TargetFile/dita/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/titlealts ')]/*[contains(@class,' topic/navtitle ')]">
                 <xsl:value-of select="$TargetFile/dita/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/titlealts ')]/*[contains(@class,' topic/navtitle ')]"/>
               </xsl:when>
               <!-- Second choice: dita/topic/title -->
               <xsl:when test="$TargetFile/dita/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/title ')]">
                 <xsl:value-of select="$TargetFile/dita/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/title ')]"/>
               </xsl:when>
               <!-- Last choice: use the linktext specified within the topicref -->
               <xsl:when test="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]">
                 <xsl:value-of select="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]"/>
               </xsl:when>
               <xsl:otherwise>
                 <xsl:call-template name="output-message">
                   <xsl:with-param name="msgnum">009</xsl:with-param>
                   <xsl:with-param name="msgsev">W</xsl:with-param>
                   <xsl:with-param name="msgparams">%1=<xsl:value-of select="@TargetFile"/>;%2=***</xsl:with-param>
                 </xsl:call-template>
                 <xsl:text>***</xsl:text>
               </xsl:otherwise>
             </xsl:choose>
           </xsl:when>

           <!-- If there is no title and none can be retrieved, check for <linktext> -->
           <xsl:when test="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]">
             <xsl:value-of select="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]"/>
           </xsl:when>

           <!-- No local title, and not targeting a DITA file. Could be just a container setting
                metadata, or a file reference with no title. Issue message for the second case. -->
           <xsl:otherwise>
             <xsl:if test="@href and not(@href='')">
                 <xsl:call-template name="output-message">
                   <xsl:with-param name="msgnum">009</xsl:with-param>
                   <xsl:with-param name="msgsev">W</xsl:with-param>
                   <xsl:with-param name="msgparams">%1=<xsl:value-of select="@href"/>;%2=<xsl:value-of select="@href"/></xsl:with-param>
                 </xsl:call-template>
                 <xsl:value-of select="@href"/>
             </xsl:if>
           </xsl:otherwise>
           </xsl:choose>
          </xsl:attribute>       <!-- End of @value (the title) -->
        </xsl:element>           <!-- End of <param> element -->

        <!-- If there is a reference to a DITA or HTML file, and it is not external: 
             allow non-dita, external values in navigation.  -->
        <xsl:if test="@href">
          <xsl:variable name="topicID">
            <xsl:choose>
              <xsl:when test="contains(@href, '#')">
                <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="''"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:element name="param">
            <xsl:attribute name="name">Local</xsl:attribute>
            <xsl:choose> <!-- What if targeting a nested topic? Need to keep the ID? -->
              <xsl:when test="contains(@copy-to, $DITAEXT)">
                <xsl:attribute name="value">
                  <xsl:value-of select="$pathFromMaplist"/>
                  <!-- added by William on 2009-11-26 for bug:1628937 start-->
                  <!--xsl:value-of select="substring-before(@copy-to,$DITAEXT)"/-->
                  <xsl:value-of select="java:getFileName(@copy-to,$DITAEXT)"/>
                  <!-- added by William on 2009-11-26 for bug:1628937 end-->
                  
                  <xsl:value-of select="$OUTEXT"/><xsl:value-of select="$topicID"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="contains(@href, $DITAEXT)">
                <xsl:attribute name="value">
                  <xsl:value-of select="$pathFromMaplist"/>
                  <!-- added by William on 2009-11-26 for bug:1628937 start-->
                  <!--xsl:value-of select="substring-before(@href,$DITAEXT)"/-->
                  <xsl:value-of select="java:getFileName(@href,$DITAEXT)"/>
                  <!-- added by William on 2009-11-26 for bug:1628937 end-->
                  <xsl:value-of select="$OUTEXT"/>
                  <xsl:value-of select="$topicID"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="contains(@href,'.htm') and @scope!='external'">
                <xsl:attribute name="value"><xsl:value-of select="$pathFromMaplist"/><xsl:value-of select="@href"/></xsl:attribute>
              </xsl:when>
              <!--<xsl:when test="not(@href) or @href=''">
                <xsl:variable name="parentHREF" select="parent::*[contains(@class, ' map/topicref ')]/@href"/>
                <xsl:if test="$parentHREF!=''">
                  <xsl:attribute name="value"><xsl:value-of select="$pathFromMaplist"/><xsl:value-of select="substring-before($parentHREF, $DITAEXT)"/><xsl:value-of select="$OUTEXT"/></xsl:attribute>
                </xsl:if>
              </xsl:when>-->
              <xsl:otherwise> <!-- If non-DITA, keep the href as-is -->
                <xsl:attribute name="value"><xsl:value-of select="@href"/></xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:if>
       </OBJECT>

       <!-- If there are any children that should be in the TOC, process them -->
       <xsl:if test="descendant::*[contains(@class, ' map/topicref ')][not(contains(@toc,'no'))][not(@processing-role='resource-only')]">
         <UL>
           <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]">
             <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
           </xsl:apply-templates>
         </UL>
       </xsl:if>
  <xsl:value-of select="$newline"/>
  </LI>
  </xsl:if>
</xsl:template>

<!-- These are here just to prevent accidental fallthrough -->
<xsl:template match="*[contains(@class, ' map/navref ')]"/>
<xsl:template match="*[contains(@class, ' map/anchor ')]"/>
<xsl:template match="*[contains(@class, ' map/reltable ')]"/>
<xsl:template match="*[contains(@class, ' map/topicmeta ')]"/>

<xsl:template match="*">
  <xsl:apply-templates/>
</xsl:template>

<!-- Template to get the relative path to a map -->
<xsl:template name="getRelativePath">
  <xsl:param name="remainingPath" select="@file"/>
  <xsl:choose>
    <xsl:when test="contains($remainingPath,'/')">
      <xsl:value-of select="substring-before($remainingPath,'/')"/><xsl:text>/</xsl:text>
      <xsl:call-template name="getRelativePath">
        <xsl:with-param name="remainingPath" select="substring-after($remainingPath,'/')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="contains($remainingPath,'\')">
      <xsl:value-of select="substring-before($remainingPath,'\')"/><xsl:text>/</xsl:text>
      <xsl:call-template name="getRelativePath">
        <xsl:with-param name="remainingPath" select="substring-after($remainingPath,'\')"/>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
