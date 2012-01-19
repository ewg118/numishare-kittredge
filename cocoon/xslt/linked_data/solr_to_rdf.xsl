<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

	<xsl:param name="url">
		<xsl:value-of select="/content/config/url"/>
	</xsl:param>

	<xsl:template match="/">
		<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/">
			<xsl:apply-templates select="//doc"/>
		</rdf:RDF>
	</xsl:template>

	<xsl:template match="doc">
		<rdf:Description rdf:about="{$url}display/{str[@name='id']}">
			<dc:title>
				<xsl:value-of select="str[@name='title_display']"/>
			</dc:title>		
			<dc:format>
				<xsl:value-of select="str[@name='objectType_facet']"/>
			</dc:format>
			<xsl:if test="str[@name='date_display']">
				<dc:date>
					<xsl:value-of select="str[@name='date_display']"/>
				</dc:date>
			</xsl:if>
			<xsl:if test="str[@name='origination_display']">
				<dc:coverage>
					<xsl:value-of select="str[@name='origination_display']"/>
				</dc:coverage>
			</xsl:if>
			<xsl:for-each select="arr[@name='subject_facet']/str">
				<dc:subject>
					<xsl:value-of select="."/>
				</dc:subject>
			</xsl:for-each>
			<xsl:for-each select="arr[@name='reference_display']/str">
				<dc:source>
					<xsl:value-of select="."/>
				</dc:source>
			</xsl:for-each>
		</rdf:Description>
	</xsl:template>
</xsl:stylesheet>
