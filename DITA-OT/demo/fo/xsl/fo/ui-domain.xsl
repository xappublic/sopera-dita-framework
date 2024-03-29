<?xml version='1.0'?>

<!-- 
Copyright © 2004-2006 by Idiom Technologies, Inc. All rights reserved. 
IDIOM is a registered trademark of Idiom Technologies, Inc. and WORLDSERVER
and WORLDSTART are trademarks of Idiom Technologies, Inc. All other 
trademarks are the property of their respective owners. 

IDIOM TECHNOLOGIES, INC. IS DELIVERING THE SOFTWARE "AS IS," WITH 
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
Software or its derivatives. In no event shall Idiom Technologies, Inc.'s
liability for any damages hereunder exceed the amounts received by Idiom
Technologies, Inc. as a result of this transaction.

These terms and conditions supersede the terms and conditions in any
licensing agreement to the extent that such terms and conditions conflict
with those set forth herein.

This file is part of the DITA Open Toolkit project hosted on Sourceforge.net. 
See the accompanying license.txt file for applicable licenses.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="1.0">

    <xsl:include href="../../cfg/fo/attrs/ui-domain-attr.xsl"/>

    <xsl:template match="*[contains(@class,' ui-d/uicontrol ')]">
        <!-- insert an arrow before all but the first uicontrol in a menucascade -->
        <xsl:if test="ancestor::*[contains(@class,' ui-d/menucascade ')]">
            <xsl:variable name="uicontrolcount">
                <xsl:number count="*[contains(@class,' ui-d/uicontrol ')]"/>
            </xsl:variable>
            <xsl:if test="$uicontrolcount&gt;'1'">
                <xsl:text> &gt; </xsl:text>
            </xsl:if>
        </xsl:if>
        <fo:inline xsl:use-attribute-sets="uicontrol" id="{@id}">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class,' ui-d/wintitle ')]">
        <fo:inline xsl:use-attribute-sets="wintitle" id="{@id}">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class,' ui-d/menucascade ')]">
        <fo:inline xsl:use-attribute-sets="menucascade" id="{@id}">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class,' ui-d/shortcut ')]">
        <fo:inline xsl:use-attribute-sets="shortcut" id="{@id}">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class,' ui-d/screen ')]">
        <xsl:call-template name="generateAttrLabel"/>
        <fo:block xsl:use-attribute-sets="screen" id="{@id}">
            <xsl:call-template name="setScale"/>
            <!-- rules have to be applied within the scope of the PRE box; else they start from page margin! -->
            <xsl:if test="contains(@frame,'top')">
                <fo:block>
                    <fo:leader xsl:use-attribute-sets="screen__top"/>
                </fo:block>
            </xsl:if>
            <xsl:apply-templates/>
            <xsl:if test="contains(@frame,'bot')">
                <fo:block>
                    <fo:leader xsl:use-attribute-sets="screen__bottom"/>
                </fo:block>
            </xsl:if>
        </fo:block>
    </xsl:template>

    <xsl:template name="generateAttrLabel">
        <xsl:if test="@spectitle">
            <fo:block font-weight="bold">
                <xsl:value-of select="@spectitle"/>
            </fo:block>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
