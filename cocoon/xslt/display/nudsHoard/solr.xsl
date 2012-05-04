<?xml version="1.0" encoding="UTF-8"?>
<?cocoon-disable-caching?>
<xsl:stylesheet version="2.0" xmlns:nh="http://nomisma.org/nudsHoard" xmlns:nuds="http://nomisma.org/nuds" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:datetime="http://exslt.org/dates-and-times"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:exsl="http://exslt.org/common" xmlns:mets="http://www.loc.gov/METS/"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gml="http://www.opengis.net/gml/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" exclude-result-prefixes="#all">
	<xsl:output method="xml" encoding="UTF-8"/>

	<xsl:template name="nudsHoard">
		<add>
			<xsl:apply-templates select="/content/nh:nudsHoard"/>
		</add>
	</xsl:template>

	<xsl:template match="nh:nudsHoard">
		<doc>
			<field name="id">
				<xsl:value-of select="nh:nudsHeader/nh:nudsid"/>
			</field>
			<field name="title_display">
				<xsl:value-of select="nh:nudsHeader/nh:nudsid"/>
			</field>
			<field name="recordType">hoard</field>
			<field name="timestamp">
				<xsl:value-of select="if(contains(datetime:dateTime(), 'Z')) then datetime:dateTime() else concat(datetime:dateTime(), 'Z')"/>
			</field>
			
			<xsl:apply-templates select="nh:descMeta"/>

			<field name="fulltext">
				<xsl:for-each select="descendant-or-self::text()">
					<xsl:value-of select="normalize-space(.)"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</field>
		</doc>
	</xsl:template>

	<xsl:template match="nh:descMeta">
		<xsl:apply-templates select="nh:hoardDesc"/>
		<xsl:apply-templates select="nh:contentsDesc"/>
	</xsl:template>
	
	<xsl:template match="nh:hoardDesc">
		<xsl:apply-templates select="nh:findspot/nh:geogname[@xlink:role='findspot']"/>
	</xsl:template>
	
	<xsl:template match="nh:contentsDesc">
		<xsl:apply-templates select="descendant::nuds:typeDesc"/>
	</xsl:template>
</xsl:stylesheet>
