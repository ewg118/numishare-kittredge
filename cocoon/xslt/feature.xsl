<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:param name="display_path">./</xsl:param>
	<xsl:output encoding="UTF-8" method="xhtml"/>

	<xsl:template match="/">
		<xsl:apply-templates select="//doc"/>
	</xsl:template>

	<xsl:template match="doc">
		<div>
		<xsl:choose>
			<xsl:when test="str[@name='objectType_facet'] = 'coin'">
				<img src="{str[@name='reference_obv']}" style="width:250px;"/>
			</xsl:when>
			<xsl:otherwise>
				<img src="{arr[@name='reference_image']/str[1]}" style="width:250px;"/>
			</xsl:otherwise>
		</xsl:choose>
			<br/>
			<a href="display/{str[@name='source_meta']}/{str[@name='id']}">
				<xsl:value-of
					select="concat(upper-case(substring(str[@name='objectType_facet'], 1, 1)), substring(str[@name='objectType_facet'], 2))"/>
				<xsl:text>: </xsl:text>
				<xsl:value-of select="str[@name='title_display']"/>
				<xsl:if test="string(normalize-space(str[@name='date_display']))">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="str[@name='date_display']"/>
				</xsl:if>
			</a>
		</div>
	</xsl:template>

</xsl:stylesheet>
