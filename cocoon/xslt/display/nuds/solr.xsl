<?xml version="1.0" encoding="UTF-8"?>
<?cocoon-disable-caching?>
<xsl:stylesheet version="2.0" xmlns:nuds="http://nomisma.org/nuds" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:datetime="http://exslt.org/dates-and-times"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:exsl="http://exslt.org/common" xmlns:mets="http://www.loc.gov/METS/"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gml="http://www.opengis.net/gml" xmlns:skos="http://www.w3.org/2008/05/skos#" exclude-result-prefixes="#all">
	<xsl:output method="xml" encoding="UTF-8"/>

	<xsl:variable name="geonames-url">
		<xsl:text>http://api.geonames.org</xsl:text>
	</xsl:variable>
	<xsl:variable name="geonames_api_key" select="/content/config/geonames_api_key"/>

	<xsl:template match="/">
		<add>
			<xsl:apply-templates select="/content/nuds:nuds"/>
		</add>
	</xsl:template>

	<xsl:template match="nuds:nuds">
		<doc>
			<field name="id">
				<xsl:value-of select="nuds:nudsHeader/nuds:nudsid"/>
			</field>
			<field name="recordType">
				<xsl:value-of select="@recordType"/>
			</field>
			<field name="timestamp">
				<xsl:value-of select="if(contains(datetime:dateTime(), 'Z')) then datetime:dateTime() else concat(datetime:dateTime(), 'Z')"/>
			</field>

			<xsl:apply-templates select="nuds:descMeta"/>
			<xsl:apply-templates select="nuds:digRep"/>

			<field name="fulltext">
				<xsl:for-each select="descendant-or-self::text()">
					<xsl:value-of select="normalize-space(.)"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
				<xsl:for-each select="descendant-or-self::node()[@normal]">
					<xsl:value-of select="@normal"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</field>
		</doc>
	</xsl:template>

	<xsl:template match="nuds:descMeta">
		<field name="title_display">
			<xsl:value-of select="normalize-space(nuds:title)"/>
		</field>
		<xsl:if test="string(nuds:department)">
			<field name="department_facet">
				<xsl:value-of select="nuds:department"/>
			</field>
		</xsl:if>
		<xsl:apply-templates select="nuds:physDesc"/>
		<xsl:apply-templates select="nuds:typeDesc"/>
		<xsl:apply-templates select="nuds:adminDesc"/>
		<xsl:apply-templates select="nuds:refDesc"/>
		<xsl:apply-templates select="nuds:findspotDesc"/>
	</xsl:template>

	<xsl:template match="nuds:findspotDesc">
		<xsl:choose>
			<xsl:when test="string(nuds:findspot/@xlink:href)"> </xsl:when>
			<xsl:otherwise>
				<field name="findspot_geo">
					<xsl:value-of select="concat(findspot/name, '|', tokenize(findspot/gml:Point/gml:coordinates, ', ')[2], ',', tokenize(findspot/gml:Point/gml:coordinates, ', ')[1])"/>
				</field>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="nuds:digRep">
		<xsl:apply-templates select="mets:fileSec"/>
		<xsl:for-each select="nuds:associatedObject">
			<xsl:call-template name="associatedObject"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="associatedObject">
		<xsl:variable name="objectDoc">
			<xsl:copy-of select="document(concat(@xlink:href, '.xml'))/nuds:nuds"/>
		</xsl:variable>

		<field name="ao_uri">
			<xsl:value-of select="@xlink:href"/>
		</field>

		<xsl:if test="number(exsl:node-set($objectDoc)//nuds:weight)">
			<field name="ao_weight">
				<xsl:value-of select="exsl:node-set($objectDoc)//nuds:weight"/>
			</field>
		</xsl:if>
		<xsl:if test="number(exsl:node-set($objectDoc)//nuds:diameter)">
			<field name="ao_diameter">
				<xsl:value-of select="exsl:node-set($objectDoc)//nuds:diameter"/>
			</field>
		</xsl:if>
		<xsl:if test="number(exsl:node-set($objectDoc)//nuds:axis)">
			<field name="ao_axis">
				<xsl:value-of select="exsl:node-set($objectDoc)//nuds:axis"/>
			</field>
		</xsl:if>

		<!-- images -->
		<!-- thumbnails-->
		<xsl:if test="string(exsl:node-set($objectDoc)//mets:fileGrp[@USE='obverse']/mets:file[@USE='thumbnail']/mets:FLocat/@xlink:href)">
			<field name="ao_thumbnail_obv">
				<xsl:value-of select="exsl:node-set($objectDoc)//nuds:nudsid"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="exsl:node-set($objectDoc)//mets:fileGrp[@USE='obverse']/mets:file[@USE='thumbnail']/mets:FLocat/@xlink:href"/>
			</field>
		</xsl:if>
		<xsl:if test="string(exsl:node-set($objectDoc)//mets:fileGrp[@USE='reverse']/mets:file[@USE='thumbnail']/mets:FLocat/@xlink:href)">
			<field name="ao_thumbnail_rev">
				<xsl:value-of select="exsl:node-set($objectDoc)//nuds:nudsid"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="exsl:node-set($objectDoc)//mets:fileGrp[@USE='reverse']/mets:file[@USE='thumbnail']/mets:FLocat/@xlink:href"/>
			</field>
		</xsl:if>
		<!-- reference-->
		<xsl:if test="string(exsl:node-set($objectDoc)//mets:fileGrp[@USE='obverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href)">
			<field name="ao_reference_obv">
				<xsl:value-of select="exsl:node-set($objectDoc)//nuds:nudsid"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="exsl:node-set($objectDoc)//mets:fileGrp[@USE='obverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href"/>
			</field>
		</xsl:if>
		<xsl:if test="string(exsl:node-set($objectDoc)//mets:fileGrp[@USE='reverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href)">
			<field name="ao_reference_rev">
				<xsl:value-of select="exsl:node-set($objectDoc)//nuds:nudsid"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="exsl:node-set($objectDoc)//mets:fileGrp[@USE='reverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href"/>
			</field>
		</xsl:if>

		<!-- set imagesavailable to true if there are associated images -->
		<xsl:if test="exsl:node-set($objectDoc)//mets:FLocat/@xlink:href">
			<field name="imagesavailable">true</field>
		</xsl:if>

		<!-- get findspot, if available -->
		<xsl:if test="count(exsl:node-set($objectDoc)//nuds:findspot) &gt; 0">
			<xsl:variable name="name" select="exsl:node-set($objectDoc)//nuds:findspot/nuds:name"/>
			<xsl:variable name="gml-coordinates" select="exsl:node-set($objectDoc)//nuds:findspot/gml:coordinates"/>
			<xsl:variable name="kml-coordinates" select="concat(tokenize($gml-coordinates, ', ')[2], ',', tokenize($gml-coordinates, ', ')[1])"/>

			<xsl:if test="string($kml-coordinates)">
				<field name="ao_findspot_geo">
					<xsl:value-of select="concat($name, '|', @xlink:href, '|', $kml-coordinates)"/>
				</field>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mets:fileSec">
		<xsl:for-each select="mets:fileGrp">
			<xsl:variable name="side" select="substring(@USE, 1, 3)"/>
			<xsl:for-each select="mets:file">
				<field name="{@USE}_{$side}">
					<xsl:value-of select="mets:FLocat/@xlink:href"/>
				</field>
			</xsl:for-each>
		</xsl:for-each>
		<field name="imagesavailable">true</field>
	</xsl:template>

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
		</xsl:for-each>

		<xsl:apply-templates select="exsl:node-set($binding)/nuds:typeDesc/nuds:date"/>

		<xsl:for-each select="exsl:node-set($binding)/descendant::nuds:persname | exsl:node-set($binding)/descendant::nuds:corpname | exsl:node-set($binding)/descendant::nuds:geogname">
			<field name="{@xlink:role}_facet">
				<xsl:value-of select="normalize-space(.)"/>
			</field>
			<field name="{@xlink:role}_text">
				<xsl:value-of select="normalize-space(.)"/>
			</field>
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
						<xsl:variable name="rdf_url" select="concat('http://nomisma.org/cgi-bin/RDFa.py?uri=', encode-for-uri(@xlink:href))"/>
						<xsl:variable name="nomisma_data" select="document($rdf_url)"/>
						<xsl:variable name="coordinates" select="exsl:node-set($nomisma_data)//*[local-name()='pos']"/>
						<field name="nomisma_uri">
							<xsl:value-of select="@xlink:href"/>
						</field>
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
				<field name="mint_uri">
					<xsl:value-of select="@xlink:href"/>
				</field>
			</xsl:if>
		</xsl:for-each>

		<xsl:for-each select="exsl:node-set($binding)/descendant::nuds:famname">
			<field name="dynasty_facet">
				<xsl:value-of select="normalize-space(.)"/>
			</field>
		</xsl:for-each>

		<xsl:for-each select="exsl:node-set($binding)/nuds:typeDesc/nuds:obverse | exsl:node-set($binding)/nuds:typeDesc/nuds:reverse">
			<xsl:variable name="side" select="substring(local-name(), 1, 3)"/>
			<xsl:if test="nuds:type">
				<field name="{$side}_type_display">
					<xsl:value-of select="normalize-space(nuds:type)"/>
				</field>
				<field name="type_text">
					<xsl:value-of select="normalize-space(nuds:type)"/>
				</field>
			</xsl:if>
			<xsl:if test="nuds:legend">
				<field name="{$side}_leg_display">
					<xsl:value-of select="normalize-space(nuds:legend)"/>
				</field>
				<field name="legend_text">
					<xsl:value-of select="normalize-space(nuds:legend)"/>
				</field>
			</xsl:if>
		</xsl:for-each>

		<field name="fulltext">
			<xsl:for-each select="exsl:node-set($binding)/descendant-or-self::text()">
				<xsl:value-of select="normalize-space(.)"/>
				<xsl:text> </xsl:text>
			</xsl:for-each>
			<xsl:for-each select="exsl:node-set($binding)/descendant-or-self::node()[@normal]">
				<xsl:value-of select="@normal"/>
				<xsl:text> </xsl:text>
			</xsl:for-each>
		</field>
	</xsl:template>

	<xsl:template match="nuds:physDesc">
		<xsl:apply-templates select="nuds:axis"/>
		<xsl:apply-templates select="nuds:measurementsSet"/>
		<xsl:for-each select="descendant::nuds:grade">
			<field name="grade_facet">
				<xsl:value-of select="."/>
			</field>
		</xsl:for-each>
		<xsl:apply-templates select="nuds:dateOnObject"/>
	</xsl:template>

	<xsl:template match="nuds:adminDesc">
		<xsl:for-each select="nuds:collection | nuds:repository | nuds:owner">
			<field name="{local-name()}_facet">
				<xsl:value-of select="normalize-space(.)"/>
			</field>
		</xsl:for-each>

		<xsl:if test="nuds:identifier">
			<field name="identifier_display">
				<xsl:value-of select="normalize-space(nuds:identifier)"/>
			</field>
			<field name="identifier_text">
				<xsl:value-of select="normalize-space(nuds:identifier)"/>
			</field>
		</xsl:if>

		<xsl:for-each select="nuds:custodhist/nuds:chronlist/nuds:chronitem">
			<field name="prevcoll_display">
				<xsl:value-of select="date"/>
				<xsl:text> - </xsl:text>
				<xsl:choose>
					<xsl:when test="nuds:prevColl">
						<xsl:value-of select="nuds:prevColl"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="nuds:saleCatalog"/>
						<xsl:if test="nuds:saleItem">
							<xsl:text>: </xsl:text>
							<xsl:value-of select="nuds:saleItem"/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</field>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="nuds:dateOnObject">
		<field name="dob_num">
			<xsl:value-of select="nuds:date"/>
		</field>
	</xsl:template>

	<xsl:template match="nuds:measurementsSet">
		<xsl:for-each select="*">
			<field name="{local-name()}_num">
				<xsl:value-of select="normalize-space(.)"/>
			</field>
		</xsl:for-each>
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
				<xsl:variable name="year_string" select="."/>
				<xsl:variable name="year" select="number($year_string)"/>
				<xsl:variable name="century" select="floor($year div 100)"/>
				<xsl:variable name="decade_digit" select="floor(number(substring($year_string, string-length($year_string) - 1, string-length($year_string))) div 10) * 10"/>
				<xsl:variable name="decade" select="concat($century, if($decade_digit = 0) then '00' else $decade_digit)"/>

				<field name="century_num">
					<xsl:value-of select="$century"/>
				</field>
				<field name="decade_num">
					<xsl:value-of select="$decade"/>
				</field>
				<field name="year_num">
					<xsl:value-of select="$year"/>
				</field>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="nuds:axis">
		<field name="axis_num">
			<xsl:choose>
				<xsl:when test="contains(., ':')">
					<xsl:value-of select="normalize-space(substring-before(., ':'))"/>
					<xsl:value-of select="normalize-space(substring-after(., ':'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="string-length(normalize-space(.)) = 2">
							<xsl:value-of select="normalize-space(.)"/>
							<xsl:text>00</xsl:text>
						</xsl:when>
						<xsl:when test="string-length(normalize-space(.)) = 4">
							<xsl:value-of select="normalize-space(.)"/>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</field>
	</xsl:template>

</xsl:stylesheet>
