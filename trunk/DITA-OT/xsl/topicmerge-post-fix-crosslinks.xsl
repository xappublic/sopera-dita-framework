<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
		<xsl:apply-templates select="node()"/>
	</xsl:template>
	<xsl:template match="@href">
		<xsl:choose>
			<!--xsl:when test="contains(.,'://') or ../@scope='external' or ../@scope='peer'">
				<xsl:copy/>
			</xsl:when-->
			<xsl:when test="(parent::*[contains(@class,' topic/xref ')] or parent::*[contains(@class,' topic/link ')]) and (not(../@format) or ../@format='dita' or ../@format='DITA')">
				<xsl:choose>
					<xsl:when test="starts-with(.,'#')">
						<xsl:variable name="refer-path" select="substring-after(.,'#')"/>
						<xsl:choose>
							<xsl:when test="contains($refer-path,'/')">
								<xsl:variable name="topic-id" select="substring-before($refer-path,'/')"/>
								<xsl:variable name="target-id" select="substring-after($refer-path,'/')"/>
								<xsl:choose>
									<xsl:when test="//*[contains(@class,' topic/topic ')][@id=$topic-id]//*[@id=$target-id]/@id">
										<xsl:copy/>
										<xsl:attribute name="aaa">aaa</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy/>
										<xsl:attribute name="zzz">zzz</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="//*[contains(@class,' topic/topic ')][@id=$refer-path]/@id">
										<xsl:copy/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="origin-href" select="../@ohref"/>

										<xsl:variable name="file-name" select="substring-before($origin-href, '#')"/>
										<xsl:variable name="topic-id" select="substring-after($origin-href, '#')"/>

										<xsl:variable name="xtrf" select="../@xtrf"/>

										<xsl:variable name="file-path">
											<xsl:call-template name="get-file-path">
											  <xsl:with-param name="src-file"><xsl:value-of select="$xtrf"/></xsl:with-param>
											</xsl:call-template>
										</xsl:variable>

										<xsl:variable name="xtrf-ref" select="concat($file-path, $file-name)"/>

										<xsl:choose>
											<xsl:when test="//*[contains(@class,' topic/topic ')][@xtrf = $xtrf-ref][@keyref = $topic-id]">
												<xsl:apply-templates select="//*[contains(@class,' topic/topic ')][@xtrf = $xtrf-ref][@keyref = $topic-id]" mode="id-fix"/>
											</xsl:when>
											<xsl:when test="//*[contains(@class,' topic/topic ')][@xtrf = $xtrf-ref][@oid = $topic-id]">
												<xsl:apply-templates select="//*[contains(@class,' topic/topic ')][@xtrf = $xtrf-ref][@oid = $topic-id]" mode="id-fix"/>
											</xsl:when>
											<xsl:when test="count(//*[contains(@class,' topic/topic ')][@oid = $topic-id]) = 1">
												<!-- nested conref -->
												<xsl:apply-templates select="//*[contains(@class,' topic/topic ')][@oid = $topic-id]" mode="id-fix"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:copy/>
												<xsl:attribute name="yyy"><xsl:value-of select="$xtrf-ref"/></xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<!--xsl:when test="contains(.,'#')">
						<xsl:variable name="file-name" select="substring-before(.,'#')"/>
						<xsl:variable name="refer-path" select="substring-after(.,'#')"/>
						<xsl:variable name="file-name-doc" select="document($file-name,/)"/>
						<xsl:if test="$file-name-doc and not($file-name-doc='')">
							<xsl:choose>
								<xsl:when test="contains($refer-path,'/')">
									<xsl:variable name="topic-id" select="substring-before($refer-path,'/')"/>
									<xsl:variable name="target-id" select="substring-after($refer-path,'/')"/>
									<xsl:variable name="href-value">
										<xsl:value-of select="generate-id($file-name-doc//*[contains(@class,' topic/topic ')][@id=$topic-id]//*[@id=$target-id]/@id)"/>
									</xsl:variable>
									<xsl:if test="not($href-value='')">
										<xsl:attribute name="href"><xsl:text>#</xsl:text><xsl:value-of select="$href-value"/></xsl:attribute>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="href-value">
										<xsl:value-of select="generate-id($file-name-doc//*[contains(@class,' topic/topic ')][@id=$refer-path]/@id)"/>
									</xsl:variable>
									<xsl:if test="not($href-value='')">
										<xsl:attribute name="href"><xsl:text>#</xsl:text><xsl:value-of select="$href-value"/></xsl:attribute>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:when-->
					<xsl:otherwise>
						<!--xsl:variable name="current-doc" select="document(.,/)"/>
						<xsl:if test="$current-doc and not($current-doc='')">
							<xsl:choose>
								<xsl:when test="$current-doc//*[contains(@class,' topic/topic ')]/@id">
									<xsl:attribute name="href"><xsl:text>#</xsl:text><xsl:value-of select="generate-id($current-doc//*[contains(@class,' topic/topic ')][1]/@id)"/></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>#</xsl:text>
									<xsl:value-of select="generate-id($current-doc//*[contains(@class,' topic/topic ')][1])"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if-->

						<xsl:copy/>
						<xsl:attribute name="xxx">xxx</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="node()[@id]" mode="id-fix">
		<xsl:attribute name="href"><xsl:value-of select="concat('#', @id)"/></xsl:attribute>
	</xsl:template>

<xsl:template name="get-file-path">
  <xsl:param name="src-file"/>
  <!--xsl:variable name="sep" select="'/'"/-->
  <xsl:variable name="sep" select="'\'"/>
  <xsl:if test="contains($src-file, $sep)">
    <xsl:value-of select="substring-before($src-file, $sep)"/>
    <xsl:value-of select="$sep"/>
    <xsl:call-template name="get-file-path">
      <xsl:with-param name="src-file">
        <xsl:value-of select="substring-after($src-file, $sep)"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>  
</xsl:template>

<!--+
	| identity transform
	+-->
	<xsl:template match="@* | node()[not(self::text()) and not(self::comment()) and not(self::processing-instruction())]">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="* | text() | comment() | processing-instruction()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="text()">
		<xsl:if test="preceding-sibling::node()[1][not(self::text())]">
			<xsl:if test="starts-with(., ' ')">
				<xsl:value-of select="' '"/>
			</xsl:if>
		</xsl:if>
		<xsl:value-of select="normalize-space(.)"/>
		<xsl:if test="following-sibling::node()[1][not(self::text())]">
			<xsl:if test="substring(., string-length(.)) = ' '">
				<xsl:value-of select="' '"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!--xsl:template match="codeblock/text()">
		<xsl:value-of select="."/>
	</xsl:template-->
	<xsl:template match="text()[parent::node()/@xml:space = 'preserve']">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="comment()">
		<xsl:comment><xsl:value-of select="."/></xsl:comment>
	</xsl:template>
	<xsl:template match="processing-instruction()">
		<xsl:processing-instruction name="{name()}"><xsl:value-of select="."/></xsl:processing-instruction>
	</xsl:template>

</xsl:stylesheet>
