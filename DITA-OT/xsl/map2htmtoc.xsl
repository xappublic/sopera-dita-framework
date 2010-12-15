<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
     Sourceforge.net. See the accompanying license.txt file for 
     applicable licenses.-->
<!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->

<!DOCTYPE xsl:stylesheet [

  <!ENTITY gt            "&gt;">
  <!ENTITY lt            "&lt;">
  <!ENTITY rbl           " ">
  <!ENTITY nbsp          "&#xA0;">    <!-- &#160; -->
  <!ENTITY quot          "&#34;">
  <!ENTITY copyr         "&#169;">
  ]>
  
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                extension-element-prefixes="saxon"
                xmlns:java="org.dita.dost.util.StringUtils"
                exclude-result-prefixes="java"
                >

<!-- map2htmltoc.xsl   main stylesheet
     Convert DITA map to a simple HTML table-of-contents view.
     Input = one DITA map file
     Output = one HTML file for viewing/checking by the author.

     Options:
        OUTEXT  = XHTML output extension (default is '.html')
        WORKDIR = The working directory that contains the document being transformed.
                   Needed as a directory prefix for the @href "document()" function calls.
                   Default is './'
-->
<!-- Include error message template -->
<xsl:import href="common/output-message.xsl"/>
<xsl:import href="common/dita-utilities.xsl"/>

<xsl:output method="html" indent="no" encoding="UTF-8"/>

<!-- Set the prefix for error message numbers -->
<xsl:variable name="msgprefix">DOTX</xsl:variable>

<!-- *************************** Command line parameters *********************** -->
<xsl:param name="OUTEXT" select="'.html'"/><!-- "htm" and "html" are valid values -->
<xsl:param name="WORKDIR" select="'./'"/>
<xsl:param name="DITAEXT" select="'.xml'"/>
<xsl:param name="FILEREF" select="'file://'"/>
<xsl:param name="contenttarget" select="'contentwin'"/>
<xsl:param name="CSS"/>
<xsl:param name="CSSPATH"/>
<xsl:param name="OUTPUTCLASS"/>   <!-- class to put on body element. -->
<!-- the path back to the project. Used for c.gif, delta.gif, css to allow user's to have
  these files in 1 location. -->
<xsl:param name="PATH2PROJ">
  <xsl:apply-templates select="/processing-instruction('path2project')" mode="get-path2project"/>
</xsl:param>
<xsl:param name="genDefMeta" select="'no'"/>
<xsl:param name="YEAR" select="'2005'"/>
<!-- Define a newline character -->
<xsl:variable name="newline"><xsl:text>
</xsl:text></xsl:variable>

<xsl:template match="processing-instruction('path2project')" mode="get-path2project">
  <xsl:value-of select="."/>
</xsl:template>

<!-- *********************************************************************************
     Setup the HTML wrapper for the table of contents
     ********************************************************************************* -->
  <!--Added by William on 2009-11-23 for bug:2900047 extension bug start -->
  <xsl:template match="/">
    <xsl:call-template name="generate-toc"/>
  </xsl:template>
  <!--Added by William on 2009-11-23 for bug:2900047 extension bug end -->
<!--  -->
<xsl:template name="generate-toc">
  <html><xsl:value-of select="$newline"/>
  <head><xsl:value-of select="$newline"/>
    <xsl:if test="string-length($contenttarget)>0 and
	        $contenttarget!='NONE'">
      <base target="{$contenttarget}"/>
      <xsl:value-of select="$newline"/>
    </xsl:if>
    <!-- initial meta information -->
    <xsl:call-template name="generateCharset"/>   <!-- Set the character set to UTF-8 -->
    <xsl:call-template name="generateDefaultCopyright"/> <!-- Generate a default copyright, if needed -->
    <xsl:call-template name="generateDefaultMeta"/> <!-- Standard meta for security, robots, etc -->
    <xsl:call-template name="copyright"/>         <!-- Generate copyright, if specified manually -->
    <xsl:call-template name="generateCssLinks"/>  <!-- Generate links to CSS files -->
    <xsl:call-template name="generateMapTitle"/> <!-- Generate the <title> element -->
    <xsl:call-template name="gen-user-head" />    <!-- include user's XSL HEAD processing here -->
    <xsl:call-template name="gen-user-scripts" /> <!-- include user's XSL javascripts here -->
    <xsl:call-template name="gen-user-styles" />  <!-- include user's XSL style element and content here -->
  </head><xsl:value-of select="$newline"/>

  <body>
	<xsl:if test="string-length($OUTPUTCLASS) &gt; 0">
		<xsl:attribute name="class">
         <xsl:value-of select="$OUTPUTCLASS"/>
		</xsl:attribute>
    </xsl:if>
	<div id="favoritesDialog" title="Favorite documents" style="display: none; font-size: medium;">
	<xsl:value-of select="$newline"/>
        <div style="border: 1px solid #000000">
		<xsl:value-of select="$newline"/>
            <table style="width: 100%">
			<xsl:value-of select="$newline"/>
                <tbody>
				<xsl:value-of select="$newline"/>
                    <tr>
					<xsl:value-of select="$newline"/>
                        <td><input type="text" id="favoriteNow" style="margin: 2px; width: 100%;" /></td>
						<xsl:value-of select="$newline"/>
                        <td style="width: 55px;"><input type="button" id="favoritesAdd" value="Add" style="float: right; margin: 2px;" /></td>
						<xsl:value-of select="$newline"/>
                    </tr>
					<xsl:value-of select="$newline"/>
                </tbody>
				<xsl:value-of select="$newline"/>
            </table>
			<xsl:value-of select="$newline"/>
            <div id="favelements">
			<xsl:value-of select="$newline"/>
			</div>
			<xsl:value-of select="$newline"/>
        </div>
		<xsl:value-of select="$newline"/>
    </div>
	<xsl:value-of select="$newline"/>
	<div>
		<xsl:attribute name="class">navi</xsl:attribute>
		<xsl:value-of select="$newline"/>
		<img>
			<xsl:attribute name="src">logo/soplogo.png</xsl:attribute>
			<xsl:attribute name="alt"></xsl:attribute>
			<xsl:attribute name="style">float: left; margin-left: 10px;</xsl:attribute>
		</img>
		<xsl:value-of select="$newline"/>
		<div>
			<xsl:attribute name="class">naviline</xsl:attribute>
			<xsl:value-of select="$newline"/>
            <span>
				<xsl:attribute name="style">font-size: larger;</xsl:attribute>
				<xsl:choose>
					<xsl:when test="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')] or /*[contains(@class,' map/map ')]/@title">
					<xsl:call-template name="gen-user-panel-title-pfx"/> <!-- hook for a user-XSL title prefix -->
						<xsl:choose>
						  <xsl:when test="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')]">
							<xsl:value-of select="normalize-space(/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')])"/>
						  </xsl:when>
						  <xsl:when test="/*[contains(@class,' map/map ')]/@title">
							<xsl:value-of select="/*[contains(@class,' map/map ')]/@title"/>
						  </xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>SOPERA Documentation</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</span>			
			<xsl:value-of select="$newline"/>
			&nbsp;<span id="favorites" style="float: right;"><img src="logo/favorites.png" alt="" /></span>
            <xsl:value-of select="$newline"/>
			<input>
				<xsl:attribute name="id">searchbox</xsl:attribute>
				<xsl:attribute name="type">text</xsl:attribute>
				<xsl:attribute name="style">float:right; margin-right: 2px;</xsl:attribute>				
			</input>
			<xsl:value-of select="$newline"/>
			<div id="searchOpt" class="searchopt">
				<xsl:value-of select="$newline"/>
                <input type="radio" name="box" id="box1" value="t1" checked="checked" />Only title
                &nbsp;&nbsp;&nbsp;&nbsp;
                <input type="radio" name="box" id="box2" value="t2" />Title and text
				<xsl:value-of select="$newline"/>
            </div>
			<xsl:value-of select="$newline"/>
			<span id="searching" style="float: right; display: none;"><img src="logo/searching.gif" alt="" /></span>
        </div>
		<xsl:value-of select="$newline"/>
	</div>     
    <xsl:value-of select="$newline"/>
	<div>
		<xsl:attribute name="class">screen</xsl:attribute>
		<xsl:value-of select="$newline"/>
		<div>
			<xsl:attribute name="class">menu</xsl:attribute>
			<xsl:value-of select="$newline"/>
			<xsl:apply-templates/>			
		</div>
		<xsl:value-of select="$newline"/>
		<div>
			<xsl:attribute name="class">frm</xsl:attribute>
			<xsl:value-of select="$newline"/>
            <iframe>
				<xsl:attribute name="id">docframe</xsl:attribute>
				<xsl:attribute name="frameborder">0</xsl:attribute>
				<xsl:attribute name="style">width: 100%; display: block; height: 100%; border: 0px solid black;</xsl:attribute>
			</iframe>
			<xsl:value-of select="$newline"/>
        </div>
		<xsl:value-of select="$newline"/>
	</div>
	<xsl:value-of select="$newline"/>
   </body>
   <xsl:value-of select="$newline"/>
  </html>
</xsl:template>

<xsl:template name="generateCharset">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><xsl:value-of select="$newline"/>
</xsl:template>

<!-- If there is no copyright in the document, make the standard one -->
<xsl:template name="generateDefaultCopyright">
  <xsl:if test="not(//*[contains(@class,' topic/copyright ')])">
    <meta name="copyright">
      <xsl:attribute name="content">
        <xsl:text>(C) </xsl:text>
        <xsl:call-template name="getString">
          <xsl:with-param name="stringName" select="'Copyright'"/>
        </xsl:call-template>
        <xsl:text> </xsl:text><xsl:value-of select="$YEAR"/>
      </xsl:attribute>
    </meta>
    <xsl:value-of select="$newline"/>
    <meta name="DC.rights.owner">
      <xsl:attribute name="content">
        <xsl:text>(C) </xsl:text>
        <xsl:call-template name="getString">
          <xsl:with-param name="stringName" select="'Copyright'"/>
        </xsl:call-template>
        <xsl:text> </xsl:text><xsl:value-of select="$YEAR"/>
      </xsl:attribute>
    </meta>
    <xsl:value-of select="$newline"/>
  </xsl:if>
</xsl:template>

<xsl:template name="generateDefaultMeta">
  <xsl:if test="$genDefMeta='yes'">
    <meta name="security" content="public" /><xsl:value-of select="$newline"/>
    <meta name="Robots" content="index,follow" /><xsl:value-of select="$newline"/>
    <xsl:text disable-output-escaping="yes">&lt;meta http-equiv="PICS-Label" content='(PICS-1.1 "http://www.icra.org/ratingsv02.html" l gen true r (cz 1 lz 1 nz 1 oz 1 vz 1) "http://www.rsac.org/ratingsv01.html" l gen true r (n 0 s 0 v 0 l 0) "http://www.classify.org/safesurf/" l gen true r (SS~~000 1))' /></xsl:text>
    <xsl:value-of select="$newline"/>
  </xsl:if>
</xsl:template>

<xsl:template name="copyright">
  
</xsl:template>
<!-- *********************************************************************************
     If processing only a single map, setup the HTML wrapper and output the contents.
     Otherwise, just process the contents.
     ********************************************************************************* -->
<xsl:template match="/*[contains(@class, ' map/map ')]">
  <xsl:param name="pathFromMaplist"/>
  <xsl:if test=".//*[contains(@class, ' map/topicref ')][not(@toc='no')][not(@processing-role='resource-only')]">
    <ul>
	  <xsl:attribute name="style">list-style-type: none; padding-left: 0px;</xsl:attribute>
	  <xsl:value-of select="$newline"/>
	  <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]">
        <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
      </xsl:apply-templates>
    </ul><xsl:value-of select="$newline"/>
  </xsl:if>
</xsl:template>

<xsl:template name="generateMapTitle">
  <!-- Title processing - special handling for short descriptions -->
  <xsl:if test="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')] or /*[contains(@class,' map/map ')]/@title">
  <title>
    <xsl:call-template name="gen-user-panel-title-pfx"/> <!-- hook for a user-XSL title prefix -->
    <xsl:choose>
      <xsl:when test="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')]">
        <xsl:value-of select="normalize-space(/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')])"/>
      </xsl:when>
      <xsl:when test="/*[contains(@class,' map/map ')]/@title">
        <xsl:value-of select="/*[contains(@class,' map/map ')]/@title"/>
      </xsl:when>
    </xsl:choose>
  </title><xsl:value-of select="$newline"/>
  </xsl:if>
</xsl:template>

<xsl:template name="gen-user-panel-title-pfx">
  <xsl:apply-templates select="." mode="gen-user-panel-title-pfx"/>
</xsl:template>
<xsl:template match="/|node()|@*" mode="gen-user-panel-title-pfx">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- It will be placed immediately after TITLE tag, in the title -->
</xsl:template>

<!-- *********************************************************************************
     Output each topic as an <li> with an A-link. Each item takes 2 values:
     - A title. If a navtitle is specified on <topicref>, use that.
       Otherwise try to open the file and retrieve the title. First look for a navigation title in the topic,
       followed by the main topic title. Last, try to use <linktext> specified in the map.
       Failing that, use *** and issue a message.
     - An HREF is optional. If none is specified, this will generate a wrapper.
       Include the HREF if specified.
     - Ignore if TOC=no.

     If this topicref has any child topicref's that will be part of the navigation,
     output a <ul> around them and process the contents.
     ********************************************************************************* -->
<xsl:template match="*[contains(@class, ' map/topicref ')][not(@toc='no')][not(@processing-role='resource-only')]">
  <xsl:param name="pathFromMaplist"/>
  <xsl:variable name="title">
    <xsl:call-template name="navtitle"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$title and $title!=''">
      <li>
        <xsl:choose>
          <!-- If there is a reference to a DITA or HTML file, and it is not external: -->
          <xsl:when test="@href and not(@href='')">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:choose>        <!-- What if targeting a nested topic? Need to keep the ID? -->
                  <!-- edited by william on 2009-08-06 for bug:2832696 start -->
                  <xsl:when test="contains(@copy-to, $DITAEXT) and not(contains(@chunk, 'to-content')) and 
                    (not(@format) or @format = 'dita' or @format='ditamap' ) ">
                  <!-- edited by william on 2009-08-06 for bug:2832696 end -->
                    <xsl:if test="not(@scope='external')"><xsl:value-of select="$pathFromMaplist"/></xsl:if>
                    <!-- added by William on 2009-11-26 for bug:1628937 start-->
                    <xsl:value-of select="java:getFileName(@copy-to,$DITAEXT)"/>
                    <!-- added by William on 2009-11-26 for bug:1628937 end-->
                    <xsl:value-of select="$OUTEXT"/>
                    <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                      <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                    </xsl:if>
                  </xsl:when>
                  <!-- edited by william on 2009-08-06 for bug:2832696 start -->
                  <xsl:when test="contains(@href,$DITAEXT) and (not(@format) or @format = 'dita' or @format='ditamap')">
                  <!-- edited by william on 2009-08-06 for bug:2832696 end -->
                    <xsl:if test="not(@scope='external')"><xsl:value-of select="$pathFromMaplist"/></xsl:if>
                    <!-- added by William on 2009-11-26 for bug:1628937 start-->
                    <!--xsl:value-of select="substring-before(@href,$DITAEXT)"/-->
                    <xsl:value-of select="java:getFileName(@href,$DITAEXT)"/>
                    <!-- added by William on 2009-11-26 for bug:1628937 end-->
                    <xsl:value-of select="$OUTEXT"/>
                    <xsl:if test="contains(@href, '#')">
                      <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>  <!-- If non-DITA, keep the href as-is -->
                    <xsl:if test="not(@scope='external')"><xsl:value-of select="$pathFromMaplist"/></xsl:if>
                    <xsl:value-of select="@href"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:if test="@scope='external' or @type='external' or ((@format='PDF' or @format='pdf') and not(@scope='local'))">
                <xsl:attribute name="target">_blank</xsl:attribute>
              </xsl:if>
              <xsl:value-of select="$title"/>
            </xsl:element>
          </xsl:when>
          
          <xsl:otherwise>
            <xsl:value-of select="$title"/>
          </xsl:otherwise>
        </xsl:choose>
        
        <!-- If there are any children that should be in the TOC, process them -->
        <xsl:if test="descendant::*[contains(@class, ' map/topicref ')][not(contains(@toc,'no'))][not(@processing-role='resource-only')]">
          <xsl:value-of select="$newline"/>
		  <ul><xsl:value-of select="$newline"/>
            <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]">
              <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
            </xsl:apply-templates>
          </ul>
		  <xsl:value-of select="$newline"/>
        </xsl:if>
      </li><xsl:value-of select="$newline"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- if it is an empty topicref -->
      <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]">
        <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
  
</xsl:template>

<!-- If toc=no, but a child has toc=yes, that child should bubble up to the top -->
<xsl:template match="*[contains(@class, ' map/topicref ')][@toc='no'][not(@processing-role='resource-only')]">
  <xsl:param name="pathFromMaplist"/>
  <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]">
    <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="processing-instruction('workdir')" mode="get-work-dir">
  <xsl:value-of select="."/><xsl:text>/</xsl:text>
</xsl:template>  

<xsl:template name="navtitle">
  <xsl:variable name="WORKDIR">
    <xsl:value-of select="$FILEREF"/>
    <xsl:apply-templates select="/processing-instruction()" mode="get-work-dir"/>
  </xsl:variable>
  <xsl:choose>

    <!-- If navtitle is specified, use it (!?but it should only be used when locktitle=yes is specifed?!) -->
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
      <xsl:variable name="FileWithPath">
	    <xsl:choose>
	      <xsl:when test="@copy-to and not(contains(@chunk, 'to-content'))">
	        <xsl:value-of select="$WORKDIR"/><xsl:value-of select="@copy-to"/>
	        <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
	          <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
	        </xsl:if>
	      </xsl:when>
	      <xsl:when test="contains(@href,'#')">
	        <xsl:value-of select="$WORKDIR"/><xsl:value-of select="substring-before(@href,'#')"/>
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:value-of select="$WORKDIR"/><xsl:value-of select="@href"/>
	      </xsl:otherwise>
	    </xsl:choose>
      </xsl:variable>
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
</xsl:template>

<!-- Link to user CSS. -->
<!-- Test for URL: returns "url" when the content starts with a URL;
  Otherwise, leave blank -->
<xsl:template name="url-string">
  <xsl:param name="urltext"/>
  <xsl:choose>
    <xsl:when test="contains($urltext,'http://')">url</xsl:when>
    <xsl:when test="contains($urltext,'https://')">url</xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>

<!-- Can't link to commonltr.css or commonrtl.css because we don't know what language the map is in. -->
<xsl:template name="generateCssLinks">
  <xsl:variable name="urltest">
    <xsl:call-template name="url-string">
      <xsl:with-param name="urltext">
        <xsl:value-of select="concat($CSSPATH,$CSS)"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="string-length($CSS)>0">
  <xsl:choose>
    <xsl:when test="$urltest='url'">
      <link rel="stylesheet" type="text/css" href="{$CSSPATH}{$CSS}" />
    </xsl:when>
    <xsl:otherwise>
      <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$CSS}" />
    </xsl:otherwise>
  </xsl:choose><xsl:value-of select="$newline"/>   
  </xsl:if>
</xsl:template>

<!-- To be overridden by user shell. -->

<xsl:template name="gen-user-head">
  <xsl:apply-templates select="." mode="gen-user-head"/>
</xsl:template>
<xsl:template match="/|node()|@*" mode="gen-user-head">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- it will be placed in the HEAD section of the XHTML. -->
  <link type="text/css" href="jquery/css/sopera/jquery-ui-1.8.4.sopera.css" rel="stylesheet" />
  <xsl:value-of select="$newline"/>
  <script type="text/javascript" src="jquery/js/jquery-1.4.2.min.js"></script>
  <xsl:value-of select="$newline"/>
  <script type="text/javascript" src="jquery/js/jquery-ui-1.8.4.custom.min.js"></script>
  <xsl:value-of select="$newline"/>
  <script type="text/javascript" src="jquery/js/jquery.corner.js"></script>
  <xsl:value-of select="$newline"/>
  <script type="text/javascript" src="jquery/js/jquery.cookie.js"></script>
  <xsl:value-of select="$newline"/>
  <script type="text/javascript" src="jquery/js/jquery.jstree.js"></script>
  <xsl:value-of select="$newline"/>
  <script type="text/javascript">
		<xsl:text disable-output-escaping="yes"><![CDATA[
			$(document).ready(function () {

			$('#screen').attr('style', 'height: ' + ($(window).height() - 135) + 'px'); // Set height screen div
			$('.menu').attr('style', 'height: ' + ($(window).height() - 160) + 'px'); // Set height menu div
			$('.frm').attr('style', 'height: ' + ($(window).height() - 160) + 'px'); // Set height frame div

			$('.navi').corner("top");
			$('.menu').corner("bl");
			$('.frm').corner("br");

			var files = new Array();

			function xmlParser(xml) {
				var findFiles = new Array();
				$(xml).find("file").each(function () {
					var name = $(this).find("name").text();
					var text = $(this).find("text").text();
					if (name.toLowerCase().indexOf($('#searchbox').val().toLowerCase()) != -1) {
						findFiles.push(name);
					}
					else if (text.toLowerCase().indexOf($('#searchbox').val().toLowerCase()) != -1) {
						findFiles.push(name);
					}
				});
				menuFilter(findFiles)
			}

			function runSearch() {
				if ($('#searchbox').val() == '') {
					$('.menu ul li').each(function (index) {
						$(this).show();
					});
					$('#searchOpt').hide(200);
				}
				else if ($("input:radio[name=box]").filter(":checked").val() == 't2') {
					//Profesional search
					if ($('#searchbox').val().length >= 3) {
						$('#searchOpt').show(200);
						$('#searching').show();
						$(document).ready(function () {
							$.ajax({
								type: "GET",
								url: "searchdata.xml",
								dataType: "xml",
								success: xmlParser
							});
						});
					}
				}
				else {
					//Simple search
					$('#searchOpt').show(200);
					$('.menu ul li').each(function (index) {
						if ($('#searchbox').val() != '') {
							if ($(this).text().toLowerCase().indexOf($('#searchbox').val().toLowerCase()) < 0) {
								$(this).hide();
							}
							else {
								$(this).show();
							}
						}
						else {
							$(this).show();
						}
					});
				}
			}

			$('#searchbox').autocomplete({
				delay: 500,
				minLength: 0,
				search: function (event, ui) {
					runSearch();
				}
			});

			$('#searchbox').css('color', '#808080');
			$('#searchbox').val('menu filter');

			$('#searchbox').focusin(function myfunction() {
				if ($('#searchbox').val() == 'menu filter') {
					$('#searchbox').css('color', '#000000');
					$('#searchbox').val('');
				}
				$('#searchbox').animate({
					width: '500px'
				}, 200, function () {

				})
			});

			$('#searchbox').focusout(function myfunction() {
				if ($('#searchbox').val() == '') {
					$('#searchbox').css('color', '#808080');
					$('#searchbox').val('menu filter');
					$('#searchbox').animate({
						width: '150px'
					}, 200, function () {

					});
					$('.menu ul li').each(function (index) {
						$(this).show();
					});
					$('#searchOpt').hide(200);
				}
			});

			$('.navi').css('border', '1px solid #6F6C67'); // fix border for ie;

			$('#favoritesDialog').dialog({
				autoOpen: false,
				//draggable: false,
				//resizable: false,
				modal: true,
				open: function (event, ui) {
					var framesrc = $('#docframe').attr('src');
					$(files).each(function (index) {
						if (this.href == framesrc) $('#favoriteNow').val(this.text);
					});
					var favoritesData = $.cookie("favorites");
					if (favoritesData != null) {
						var favs = favoritesData.split("\|\*\|");
						$('#favelements').html('');
						// for each pair "name|-|link"
						$(favs).each(function (index) {
							var fav = this.split("\|-\|");
							//alert(fav[0] + " and " + fav[1]);
							var favDiv = $('<div class="favorite"></div>');
							var favAnchor = $('<a href="' + fav[1] + '">' + fav[0] + '</a>');
							$(favAnchor).click(function (event) {
								$('#docframe').attr('src', $(this).attr('href'));
								$('#favoritesDialog').dialog('close');
								return false;
							});
							$(favAnchor).appendTo(favDiv);
							$(favDiv).append('&nbsp;');
							var favAnchorDel = $('<a href="' + fav[1] + '">[x]</a>');
							$(favAnchorDel).click(function (event) {
								//Deleting bookmark
								var bDelName = $(this).attr('href');
								var divToDel = $(this).parent();
								var favoritesData = $.cookie("favorites");
								var favoritesDataNew = "";
								if ((favoritesData != null) && (favoritesData != "")) {
									var favsDel = favoritesData.split("\|\*\|");
									// for each pair "name|-|link"
									$(favsDel).each(function (index) {
										var favDel = this.split("\|-\|");
										if (favDel[1] != bDelName) {
											if (favoritesDataNew == "") {
												favoritesDataNew += favDel[0] + "|-|" + favDel[1];
											}
											else {
												favoritesDataNew += "|*|" + favDel[0] + "|-|" + favDel[1];
											}
										}
									});
								}
								if (favoritesDataNew == "") { $.cookie("favorites", null); }
								else { $.cookie("favorites", favoritesDataNew, { expires: 365 }); }
								$(divToDel).hide();
								return false;
							});
							$(favAnchorDel).appendTo(favDiv);
							$(favDiv).appendTo($('#favelements'));
						});
					}
				}
			});

			$('#favorites').click(function (event) {
				if ($('#favoritesDialog').dialog('isOpen') == false) { $('#favoritesDialog').dialog('open'); }
				else { $('#favoritesDialog').dialog('close'); }
			});

			$('#favoritesAdd').click(function (event) {
				var flink = $('#docframe').attr('src');
				var fname = $('#favoriteNow').val();
				var favoritesData = $.cookie("favorites");
				if ((favoritesData != null) && favoritesData != "") {
					favoritesData += "|*|" + fname + "|-|" + flink;
				}
				else {
					favoritesData = fname + "|-|" + flink;
				}
				$.cookie("favorites", favoritesData, { expires: 365 });
				$('#favoritesDialog').dialog('close');
			});

			$('input:radio[name=box]').click(function (event) {
				runSearch();
			});

			$('.menu > ul').jstree({
				"core": { "initially_open": ["root"] },
				"html_data": {
					"data": $('.menu > ul').html()
				},
				"themes": {
					"theme": "default"
				},
				"callback": {
					onselect: function (NODE, TREE_OBJ) {
						
					}
				},
				"types": {
					"types": {
						"default": {
							"icon": {
								"image": "jquery/js/themes/default/file.png"
							}
						}
					}
				},
				"plugins": ["themes", "types", "html_data"]
			});


			$('.menu ul li a').each(function (index) {
				var el = new Object();
				el.href = $(this).attr('href');
				el.text = $(this).text();
				files.push(el);
				if (index == 0) $('#docframe').attr('src', $(this).attr('href')); //in frame show first element

				$(this).click(function (event) {
					$('iframe').attr('src', $(this).attr('href')); return false;
				});
			});
			
			function menuFilter(findFiles) {
				$('.menu ul li').each(function (index) {
					if (findInArr($(this).text(), findFiles)) {
						$(this).show();
					}
					else {
						$(this).hide();
					}
				});
				$('#searching').hide();
			}
			
			function findInArr(text, findFiles) {
				var res = false;
				$(findFiles).each(function (index) {
					var txt1 = new String(findFiles[index]).toLowerCase().trim().replace("\r","").replace("\n","").replace("\t","");
					var txt2 = new String(text).toLowerCase().trim().replace("\r","").replace("\n","").replace("\t","");
					if(txt1 == txt2) { res = true; }
				});
				return res;
			}
		});
		]]>
		</xsl:text>
    </script>
    <xsl:value-of select="$newline"/>
	<style type="text/css">
        <![CDATA[
		*
        {
            font-family: "Trebuchet MS" , Verdana, Arial, Helvetica, sans-serif;
        }
        
        body
        {
            background-color: #83827C;
        }
        
        .menu
        {
			overflow: auto;
            border: 1px solid #6F6C67;
            background: #A5C85A;
            float: left;
            width: 272px;
            padding: 10px;
            height: 500px;
        }
        
        .menu ul
        {
            margin-top: 5px;
        }
        
        .menu a
        {
            color: #FFFFFF;
            font-weight: 600;
        }
        
        .frm
        {
            border: 1px solid #6F6C67;
            margin-left: 300px;
            background-color: #FFFFFF;
            height: 100%;
            padding: 10px;
        }
        
        .navi
        {
            border: 1px solid #6F6C67;
            height: 110px;
            margin-bottom: 5px;
            background-color: #FFFFFF;
        }
        
        .naviline
        {
            margin-top: 55px;
            padding: 2px 0px 2px 0px;
            background-color: #83B817;
            height: 24px;
        }
        
        .favorite
        {
            border: 1px solid #000000; 
            margin: 2px; 
            padding: 2px;
        } 
		
        .searchopt
        {
            display: none;
            position: absolute;
            top: 93px;
            right: 35px;
            border: 1px solid #7F9DB9;
            width: 300px;
            background-color: #FFFFFF;
        }
		]]>
    </style>
	<xsl:value-of select="$newline"/>
</xsl:template>

<xsl:template name="gen-user-header">
  <xsl:apply-templates select="." mode="gen-user-header"/>
</xsl:template>
<xsl:template match="/|node()|@*" mode="gen-user-header">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- it will be placed in the running heading section of the XHTML. -->
</xsl:template>

<xsl:template name="gen-user-footer">
  <xsl:apply-templates select="." mode="gen-user-footer"/>
</xsl:template>
<xsl:template match="/|node()|@*" mode="gen-user-footer">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- it will be placed in the running footing section of the XHTML. -->
</xsl:template>

<xsl:template name="gen-user-sidetoc">
  <xsl:apply-templates select="." mode="gen-user-sidetoc"/>
</xsl:template>
<xsl:template match="/|node()|@*" mode="gen-user-sidetoc">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- Uncomment the line below to have a "freebie" table of contents on the top-right -->
</xsl:template>

<xsl:template name="gen-user-scripts">
  <xsl:apply-templates select="." mode="gen-user-scripts"/>
</xsl:template>
<xsl:template match="/|node()|@*" mode="gen-user-scripts">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- It will be placed before the ending HEAD tag -->
  <!-- see (or enable) the named template "script-sample" for an example -->
</xsl:template>

<xsl:template name="gen-user-styles">
  <xsl:apply-templates select="." mode="gen-user-styles"/>
</xsl:template>
<xsl:template match="/|node()|@*" mode="gen-user-styles">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- It will be placed before the ending HEAD tag -->
</xsl:template>

<xsl:template name="gen-user-external-link">
  <xsl:apply-templates select="." mode="gen-user-external-link"/>
</xsl:template>
<xsl:template match="/|node()|@*" mode="gen-user-external-link">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- It will be placed after an external LINK or XREF -->
</xsl:template>

<!-- These are here just to prevent accidental fallthrough -->
<xsl:template match="*[contains(@class, ' map/navref ')]"/>
<xsl:template match="*[contains(@class, ' map/anchor ')]"/>
<xsl:template match="*[contains(@class, ' map/reltable ')]"/>
<xsl:template match="*[contains(@class, ' map/topicmeta ')]"/>
<!--xsl:template match="*[contains(@class, ' map/topicref ') and contains(@class, '/topicgroup ')]"/-->

<xsl:template match="*">
  <xsl:apply-templates/>
</xsl:template>

<!-- Convert the input value to lowercase & return it -->
<xsl:template name="convert-to-lower">
 <xsl:param name="inputval"/>
 <xsl:value-of select="translate($inputval,
                                  '-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
                                  '-abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz')"/>
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
