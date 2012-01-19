<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="cinclude">
	<xsl:include href="../search_segments.xsl"/>
	<xsl:param name="q"/>
	<xsl:param name="category"/>
	
	<xsl:template match="/">
		<select class="search_text">
			<option value="">Select option from list...</option>
			<xsl:apply-templates select="descendant::lst[@name=$category]/int"/>
		</select>
	</xsl:template>

	<xsl:template match="int">
		<xsl:choose>
			<xsl:when test="$category = 'century_num'">
				<option value="&#x0022;{@name}&#x0022;" class="term">
					<xsl:call-template name="regularize_century">
						<xsl:with-param name="term" select="@name"/>
					</xsl:call-template>
				</option>
			</xsl:when>
			<xsl:otherwise>
				<option value="&#x0022;{@name}&#x0022;" class="term">
					<xsl:value-of select="@name"/>
				</option>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
