<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0" xmlns="http://www.w3.org/2005/Atom"
	xmlns:gml="http://www.opengis.net/gml/" xmlns:georss="http://www.georss.org/georss" xmlns:gx="http://www.google.com/kml/ext/2.2">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

	<xsl:param name="q"/>
	<xsl:param name="section"/>
	<xsl:param name="rows" as="xs:integer">100</xsl:param>
	<xsl:param name="start"/>
	<xsl:variable name="start_var" as="xs:integer">
		<xsl:choose>
			<xsl:when test="number($start)">
				<xsl:value-of select="$start"/>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="url">
		<xsl:value-of select="//config/url"/>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:variable name="numFound">
			<xsl:value-of select="number(//result[@name='response']/@numFound)"/>
		</xsl:variable>
		<xsl:variable name="last" select="number(concat(substring($numFound, 1, string-length($numFound) - 2), '00'))"/>
		<xsl:variable name="next" select="$start_var + 100"/>

		<feed xmlns="http://www.w3.org/2005/Atom">
			<title>
				<xsl:value-of select="//config/title"/>
			</title>
			<xsl:if test="not($section = 'display')">
				<link href="{$url}feed/?q={$q}&amp;start={$start_var}" rel="self"/>
			</xsl:if>
			<link href="{$url}"/>
			<id>numishare:atom</id>
			<xsl:if test="not($section = 'display')">
				<xsl:if test="not($next = $last)">
					<link rel="next" href="{$url}feed/?q={$q}&amp;start={$next}"/>
				</xsl:if>
				<link rel="last" href="{$url}feed/?q={$q}&amp;start={$last}"/>
			</xsl:if>
			<author>
				<name>
					<xsl:value-of select="//config/templates/publisher"/>
				</name>
			</author>

			<xsl:apply-templates select="//doc"/>
		</feed>
	</xsl:template>

	<xsl:template match="doc">
		<entry>
			<title>
				<xsl:value-of select="str[@name='title_display']"/>
			</title>
			<link href="{$url}display/{str[@name='id']}"/>
			<link rel="alternate xml" type="text/xml" href="{$url}collection/{str[@name='id']}.xml"/>
			<link rel="alternate atom" type="application/atom+xml" href="{$url}collection/{str[@name='id']}.atom"/>
			<link rel="alternate rdf" type="application/rdf+xml" href="{$url}collection/{str[@name='id']}.rdf"/>
			<xsl:if test="str[@name='mint_geo']">
				<link rel="alternate kml" type="application/vnd.google-earth.kml+xml" href="{$url}collection/{str[@name='id']}.kml"/>
			</xsl:if>

			<id>
				<xsl:value-of select="str[@name='id']"/>
			</id>
			<xsl:if test="arr[@name='authority_facet']/str[1]">
				<creator>
					<name>
						<xsl:for-each select="arr[@name='authority_facet']/str">
							<xsl:value-of select="."/>
							<xsl:if test="not(position()=last())">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>

						<xsl:if test="arr[@name='mint_facet']/str[1]">
							<xsl:text>: </xsl:text>
							<xsl:value-of select="arr[@name='mint_facet']/str[1]"/>
						</xsl:if>
					</name>
				</creator>
			</xsl:if>
			<updated>
				<xsl:value-of select="date[@name='timestamp']"/>
			</updated>
			<xsl:if test="count(arr[@name='mint_geo']/str) &gt; 0">
				<georss:where>
					<xsl:for-each select="arr[@name='mint_geo']/str">
						<xsl:variable name="tokenized_georef" select="tokenize(., '\|')"/>
						<xsl:variable name="coordinates" select="$tokenized_georef[3]"/>
						<xsl:variable name="lon" select="substring-before($coordinates, ',')"/>
						<xsl:variable name="lat" select="substring-after($coordinates, ',')"/>
						<gml:Point>
							<gml:pos>
								<xsl:value-of select="concat($lat, ' ', $lon)"/>
							</gml:pos>
						</gml:Point>
					</xsl:for-each>
				</georss:where>
			</xsl:if>
			<xsl:if test="count(arr[@name='year_num']/int) &gt; 1">
				<gx:TimeSpan>
					<begin>
						<xsl:value-of select="arr[@name='year_num']/int[1]"/>
					</begin>
					<end>
						<xsl:value-of select="arr[@name='year_num']/int[2]"/>
					</end>
				</gx:TimeSpan>
			</xsl:if>
			<xsl:if test="count(arr[@name='year_num']/int) = 1">
				<gx:TimeStamp>
					<when>
						<xsl:value-of select="arr[@name='year_num']/int"/>
					</when>
				</gx:TimeStamp>
			</xsl:if>
		</entry>
	</xsl:template>
</xsl:stylesheet>
