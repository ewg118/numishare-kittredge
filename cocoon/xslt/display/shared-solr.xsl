<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************** SHARED TEMPLATES AND FUNCTIONS *****************************************
	Author: Ethan Gruber
	Function: this XSLT stylesheet is included into xslt/solr.xsl.  It contains shared templates and functions that may be used in object-
	specific stylesheets for creating Solr documents
	Modification date: April 2012
-->
<xsl:stylesheet xmlns:nuds="http://nomisma.org/nuds" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:datetime="http://exslt.org/dates-and-times"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:exsl="http://exslt.org/common" xmlns:mets="http://www.loc.gov/METS/"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gml="http://www.opengis.net/gml" xmlns:skos="http://www.w3.org/2004/02/skos/core#" exclude-result-prefixes="#all" version="2.0">

	<xsl:template match="nuds:typeDesc">
		<xsl:variable name="binding">
			<xsl:choose>
				<xsl:when test="string(@xlink:href)">
					<xsl:copy-of select="document(concat(@xlink:href, '.xml'))/nuds:nuds/nuds:descMeta/nuds:typeDesc"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:for-each
			select="exsl:node-set($binding)/nuds:typeDesc/nuds:objectType | exsl:node-set($binding)/nuds:typeDesc/nuds:denomination | exsl:node-set($binding)/nuds:typeDesc/nuds:manufacture | exsl:node-set($binding)/nuds:typeDesc/nuds:material">
			<field name="{local-name()}_facet">
				<xsl:value-of select="."/>
			</field>
			<xsl:if test="string(@xlink:href)">
				<field name="{local-name()}_uri">
					<xsl:value-of select="@xlink:href"/>
				</field>
			</xsl:if>
		</xsl:for-each>

		<xsl:apply-templates select="exsl:node-set($binding)/nuds:typeDesc/nuds:date"/>

		<xsl:apply-templates select="exsl:node-set($binding)/descendant::nuds:persname | exsl:node-set($binding)/descendant::nuds:corpname | exsl:node-set($binding)/descendant::nuds:geogname"/>

		<xsl:for-each select="exsl:node-set($binding)/descendant::nuds:famname">
			<field name="dynasty_facet">
				<xsl:value-of select="normalize-space(.)"/>
			</field>
			<xsl:if test="string(@xlink:href)">
				<field name="{local-name()}_uri">
					<xsl:value-of select="@xlink:href"/>
				</field>
			</xsl:if>
		</xsl:for-each>

		<xsl:for-each select="exsl:node-set($binding)/nuds:typeDesc/nuds:obverse | exsl:node-set($binding)/nuds:typeDesc/nuds:reverse">
			<xsl:variable name="side" select="substring(local-name(), 1, 3)"/>
			<xsl:if test="nuds:type">
				<field name="{$side}_type_display">
					<xsl:value-of select="normalize-space(nuds:type)"/>
				</field>
				<field name="{$side}_type_text">
					<xsl:value-of select="normalize-space(nuds:type)"/>
				</field>
				<!--<field name="type_text">
					<xsl:value-of select="normalize-space(nuds:type)"/>
					</field>-->
			</xsl:if>
			<xsl:if test="nuds:legend">
				<field name="{$side}_leg_display">
					<xsl:value-of select="normalize-space(nuds:legend)"/>
				</field>
				<field name="{$side}_leg_text">
					<xsl:value-of select="normalize-space(nuds:legend)"/>
				</field>
				<!--<field name="legend_text">
					<xsl:value-of select="normalize-space(nuds:legend)"/>
					</field>-->
			</xsl:if>
		</xsl:for-each>

		<!-- sortable fields -->
		<xsl:variable name="sort-fields">
			<xsl:text>artist,authority,deity,denomination,dynasty,issuer,magistrate,maker,manufacture,material,mint,portrait,region</xsl:text>
		</xsl:variable>

		<xsl:for-each select="tokenize($sort-fields, ',')">
			<xsl:variable name="field" select="."/>
			<!-- for each sortable field which is a multiValued field in Solr (a facet), grab the min and max values -->
			<xsl:for-each select="exsl:node-set($binding)/descendant::*[local-name()=$field]|exsl:node-set($binding)/descendant::*[@xlink:role=$field]">
				<xsl:sort order="ascending"/>
				<xsl:if test="not(local-name()='authority') and position()=1">
					<xsl:variable name="name" select="if(@xlink:role) then @xlink:role else local-name()"/>

					<field name="{$name}_min">
						<xsl:value-of select="normalize-space(.)"/>
					</field>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="exsl:node-set($binding)/descendant::*[local-name()=$field]|exsl:node-set($binding)/descendant::*[@xlink:role=$field]">
				<xsl:sort order="descending"/>
				<xsl:if test="not(local-name()='authority') and position()=1">
					<xsl:variable name="name" select="if(@xlink:role) then @xlink:role else local-name()"/>
					
					<field name="{$name}_max">
						<xsl:value-of select="normalize-space(.)"/>
					</field>
				</xsl:if>
			</xsl:for-each>			
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="nuds:persname|nuds:corpname |*[local-name()='geogname']">
		<field name="{@xlink:role}_facet">
			<xsl:value-of select="normalize-space(.)"/>
		</field>
		<field name="{@xlink:role}_text">
			<xsl:value-of select="normalize-space(.)"/>
		</field>
		<xsl:if test="string(@xlink:href)">
			<field name="{@xlink:role}_uri">
				<xsl:value-of select="@xlink:href"/>
			</field>
		</xsl:if>
		<xsl:if test="local-name()='geogname' and string(@xlink:href)">
			<xsl:choose>
				<xsl:when test="contains(@xlink:href, 'geonames')">
					<xsl:variable name="geonameId" select="substring-before(substring-after(@xlink:href, 'geonames.org/'), '/')"/>
					<xsl:variable name="geonames_data" select="document(concat($geonames-url, '/get?geonameId=', $geonameId, '&amp;username=', $geonames_api_key, '&amp;style=full'))"/>
					<xsl:variable name="coordinates" select="concat(exsl:node-set($geonames_data)//lng, ',', exsl:node-set($geonames_data)//lat)"/>
					<!-- *_geo format is 'mint name|URI of resource|KML-compliant geographic coordinates' -->
					<field name="mint_geo">
						<xsl:value-of select="."/>
						<xsl:text>|</xsl:text>
						<xsl:value-of select="@xlink:href"/>
						<xsl:text>|</xsl:text>
						<xsl:value-of select="$coordinates"/>
					</field>
				</xsl:when>
				<xsl:when test="contains(@xlink:href, 'nomisma')">
					<xsl:variable name="rdf_url" select="concat('http://www.w3.org/2012/pyRdfa/extract?format=xml&amp;uri=', encode-for-uri(@xlink:href))"/>
					<xsl:variable name="nomisma_data" select="document($rdf_url)"/>
					<xsl:variable name="coordinates" select="exsl:node-set($nomisma_data)//*[local-name()='pos']"/>
					<xsl:if test="string($coordinates)">
						<xsl:variable name="lat" select="substring-before($coordinates, ' ')"/>
						<xsl:variable name="lon" select="substring-after($coordinates, ' ')"/>
						<!-- *_geo format is 'mint name|URI of resource|KML-compliant geographic coordinates' -->
						<field name="mint_geo">
							<xsl:value-of select="."/>
							<xsl:text>|</xsl:text>
							<xsl:value-of select="@xlink:href"/>
							<xsl:text>|</xsl:text>
							<xsl:value-of select="concat($lon, ',', $lat)"/>
						</field>
						<xsl:if test="exsl:node-set($nomisma_data)//skos:related[contains(@rdf:resource, 'pleiades')]">
							<field name="pleiades_uri">
								<xsl:value-of select="exsl:node-set($nomisma_data)//skos:related[contains(@rdf:resource, 'pleiades')]/@rdf:resource"/>
							</field>
						</xsl:if>
					</xsl:if>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="nuds:date">
		<field name="date_display">
			<xsl:value-of select="normalize-space(.)"/>
		</field>
		<xsl:if test="string(normalize-space(@normal))">
			<xsl:call-template name="get_date_hierarchy"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="get_date_hierarchy">
		<xsl:variable name="years" select="tokenize(normalize-space(@normal), '/')"/>

		<xsl:for-each select="$years">
			<xsl:if test="number(.)">
				<xsl:variable name="year_string" select="string(abs(number(.)))"/>
				<xsl:variable name="century" select="if(number(.) &gt; 0) then ceiling(number(.) div 100) else floor(number(.) div 100)"/>
				<xsl:variable name="decade_digit" select="floor(number(substring($year_string, string-length($year_string) - 1, string-length($year_string))) div 10) * 10"/>
				<xsl:variable name="decade" select="if($decade_digit = 0) then '00' else $decade_digit"/>

				<field name="century_num">
					<xsl:value-of select="$century"/>
				</field>
				<field name="decade_num">
					<xsl:value-of select="$decade"/>
				</field>
				<field name="year_num">
					<xsl:value-of select="number(.)"/>
				</field>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
