<?xml version="1.0" encoding="UTF-8"?>
<?cocoon-disable-caching?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:datetime="http://exslt.org/dates-and-times" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:exsl="http://exslt.org/common" xmlns:mets="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:gml="http://www.opengis.net/gml" xmlns:skos="http://www.w3.org/2008/05/skos#">
	<xsl:output method="xml" encoding="UTF-8"/>

	<xsl:variable name="geonames-url">
		<xsl:text>http://api.geonames.org</xsl:text>
	</xsl:variable>

	<xsl:template match="/">
		<add>
			<xsl:apply-templates select="nuds"/>
		</add>
	</xsl:template>

	<xsl:template match="nuds">
		<doc>
			<field name="id">
				<xsl:value-of select="nudsHeader/nudsid"/>
			</field>
			<field name="recordType">
				<xsl:value-of select="@recordType"/>
			</field>
			<field name="timestamp">
				<xsl:value-of select="if(contains(datetime:dateTime(), 'Z')) then datetime:dateTime() else concat(datetime:dateTime(), 'Z')"/>
			</field>

			<xsl:apply-templates select="descMeta"/>
			<xsl:apply-templates select="digRep"/>

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

	<xsl:template match="descMeta">
		<field name="title_display">
			<xsl:value-of select="normalize-space(title)"/>
		</field>
		<xsl:if test="string(department)">
			<field name="department_facet">
				<xsl:value-of select="department"/>
			</field>
		</xsl:if>
		<xsl:apply-templates select="physDesc"/>
		<xsl:apply-templates select="typeDesc"/>
		<xsl:apply-templates select="adminDesc"/>
		<xsl:apply-templates select="refDesc"/>
		<xsl:apply-templates select="findspotDesc"/>
	</xsl:template>

	<xsl:template match="findspotDesc">
		<xsl:choose>
			<xsl:when test="string(findspot/@rdf:resource)"> </xsl:when>
			<xsl:otherwise>
				<field name="findspot_geo">
					<xsl:value-of select="concat(findspot/name, '|', tokenize(findspot/gml:Point/gml:coordinates, ', ')[2], ',', tokenize(findspot/gml:Point/gml:coordinates, ', ')[1])"/>
				</field>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="digRep">
		<xsl:apply-templates select="mets:fileSec"/>
		<xsl:for-each select="associatedObject">
			<xsl:call-template name="associatedObject"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="associatedObject">
		<xsl:variable name="objectDoc">
			<xsl:copy-of select="document(concat(@rdf:resource, '.xml'))/nuds"/>
		</xsl:variable>

		<field name="ao_uri">
			<xsl:value-of select="@rdf:resource"/>
		</field>

		<xsl:if test="number(exsl:node-set($objectDoc)//weight)">
			<field name="ao_weight">
				<xsl:value-of select="exsl:node-set($objectDoc)//weight"/>
			</field>
		</xsl:if>
		<xsl:if test="number(exsl:node-set($objectDoc)//diameter)">
			<field name="ao_diameter">
				<xsl:value-of select="exsl:node-set($objectDoc)//diameter"/>
			</field>
		</xsl:if>
		<xsl:if test="number(exsl:node-set($objectDoc)//axis)">
			<field name="ao_axis">
				<xsl:value-of select="exsl:node-set($objectDoc)//axis"/>
			</field>
		</xsl:if>

		<!-- images -->
		<!-- thumbnails-->
		<xsl:if test="string(exsl:node-set($objectDoc)//mets:fileGrp[@USE='obverse']/mets:file[@USE='thumbnail']/mets:FLocat/@xlink:href)">
			<field name="ao_thumbnail_obv">
				<xsl:value-of select="exsl:node-set($objectDoc)//nudsid"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="exsl:node-set($objectDoc)//mets:fileGrp[@USE='obverse']/mets:file[@USE='thumbnail']/mets:FLocat/@xlink:href"/>
			</field>
		</xsl:if>
		<xsl:if test="string(exsl:node-set($objectDoc)//mets:fileGrp[@USE='reverse']/mets:file[@USE='thumbnail']/mets:FLocat/@xlink:href)">
			<field name="ao_thumbnail_rev">
				<xsl:value-of select="exsl:node-set($objectDoc)//nudsid"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="exsl:node-set($objectDoc)//mets:fileGrp[@USE='reverse']/mets:file[@USE='thumbnail']/mets:FLocat/@xlink:href"/>
			</field>
		</xsl:if>
		<!-- reference-->
		<xsl:if test="string(exsl:node-set($objectDoc)//mets:fileGrp[@USE='obverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href)">
			<field name="ao_reference_obv">
				<xsl:value-of select="exsl:node-set($objectDoc)//nudsid"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="exsl:node-set($objectDoc)//mets:fileGrp[@USE='obverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href"/>
			</field>
		</xsl:if>
		<xsl:if test="string(exsl:node-set($objectDoc)//mets:fileGrp[@USE='reverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href)">
			<field name="ao_reference_rev">
				<xsl:value-of select="exsl:node-set($objectDoc)//nudsid"/>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="exsl:node-set($objectDoc)//mets:fileGrp[@USE='reverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href"/>
			</field>
		</xsl:if>

		<!-- set imagesavailable to true if there are associated images -->
		<xsl:if test="exsl:node-set($objectDoc)//mets:FLocat/@xlink:href">
			<field name="imagesavailable">true</field>
		</xsl:if>

		<!-- get findspot, if available -->
		<xsl:if test="count(exsl:node-set($objectDoc)//findspot) &gt; 0">
			<xsl:variable name="name" select="exsl:node-set($objectDoc)//findspot/name"/>
			<xsl:variable name="gml-coordinates" select="exsl:node-set($objectDoc)//findspot/gml:coordinates"/>
			<xsl:variable name="kml-coordinates" select="concat(tokenize($gml-coordinates, ', ')[2], ',', tokenize($gml-coordinates, ', ')[1])"/>

			<xsl:if test="string($kml-coordinates)">
				<field name="ao_findspot_geo">
					<xsl:value-of select="concat($name, '|', @rdf:resource, '|', $kml-coordinates)"/>
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

	<xsl:template match="typeDesc">
		<xsl:variable name="binding">
			<xsl:choose>
				<xsl:when test="string(@rdf:resource)">
					<xsl:copy-of select="document(concat(@rdf:resource, '.xml'))/nuds/descMeta/typeDesc"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:for-each
			select="exsl:node-set($binding)/typeDesc/objectType | exsl:node-set($binding)/typeDesc/denomination | exsl:node-set($binding)/typeDesc/manufacture | exsl:node-set($binding)/typeDesc/material">
			<field name="{name()}_facet">
				<xsl:value-of select="."/>
			</field>
		</xsl:for-each>

		<xsl:apply-templates select="exsl:node-set($binding)/typeDesc/date"/>

		<xsl:for-each select="exsl:node-set($binding)/descendant::persname | exsl:node-set($binding)/descendant::corpname | exsl:node-set($binding)/descendant::geogname">
			<field name="{@role}_facet">
				<xsl:value-of select="normalize-space(.)"/>
			</field>
			<field name="{@role}_text">
				<xsl:value-of select="normalize-space(.)"/>
			</field>
			<xsl:if test="name()='geogname' and string(@rdf:resource)">
				<xsl:choose>
					<xsl:when test="contains(@rdf:resource, 'geonames')">
						<xsl:variable name="geonameId" select="substring-before(substring-after(@rdf:resource, 'geonames.org/'), '/')"/>
						<xsl:variable name="geonames_data" select="document(concat($geonames-url, '/get?geonameId=', $geonameId, '&amp;username=anscoins&amp;style=full'))"/>
						<xsl:variable name="coordinates" select="concat(exsl:node-set($geonames_data)//lng, ',', exsl:node-set($geonames_data)//lat)"/>
						<!-- *_geo format is 'mint name|URI of resource|KML-compliant geographic coordinates' -->
						<field name="mint_geo">
							<xsl:value-of select="."/>
							<xsl:text>|</xsl:text>
							<xsl:value-of select="@rdf:resource"/>
							<xsl:text>|</xsl:text>
							<xsl:value-of select="$coordinates"/>
						</field>
					</xsl:when>
					<xsl:when test="contains(@rdf:resource, 'nomisma')">
						<xsl:variable name="rdf_url" select="concat('http://nomisma.org/cgi-bin/RDFa.py?uri=', encode-for-uri(@rdf:resource))"/>
						<xsl:variable name="nomisma_data" select="document($rdf_url)"/>
						<xsl:variable name="coordinates" select="exsl:node-set($nomisma_data)//*[local-name()='pos']"/>
						<field name="nomisma_uri">
							<xsl:value-of select="@rdf:resource"/>
						</field>
						<xsl:if test="string($coordinates)">
							<xsl:variable name="lat" select="substring-before($coordinates, ' ')"/>
							<xsl:variable name="lon" select="substring-after($coordinates, ' ')"/>
							<!-- *_geo format is 'mint name|URI of resource|KML-compliant geographic coordinates' -->
							<field name="mint_geo">
								<xsl:value-of select="."/>
								<xsl:text>|</xsl:text>
								<xsl:value-of select="@rdf:resource"/>
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
					<xsl:value-of select="@rdf:resource"/>
				</field>
			</xsl:if>
		</xsl:for-each>

		<xsl:for-each select="exsl:node-set($binding)/descendant::famname">
			<field name="dynasty_facet">
				<xsl:value-of select="normalize-space(.)"/>
			</field>
		</xsl:for-each>

		<xsl:for-each select="exsl:node-set($binding)/typeDesc/obverse | exsl:node-set($binding)/typeDesc/reverse">
			<xsl:variable name="side" select="substring(name(), 1, 3)"/>
			<xsl:if test="type">
				<field name="{$side}_type_display">
					<xsl:value-of select="normalize-space(type)"/>
				</field>
				<field name="type_text">
					<xsl:value-of select="normalize-space(type)"/>
				</field>
			</xsl:if>
			<xsl:if test="legend">
				<field name="{$side}_leg_display">
					<xsl:value-of select="normalize-space(legend)"/>
				</field>
				<field name="legend_text">
					<xsl:value-of select="normalize-space(legend)"/>
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

	<xsl:template match="physDesc">
		<xsl:apply-templates select="axis"/>
		<xsl:apply-templates select="measurementsSet"/>
		<xsl:for-each select="descendant::grade">
			<field name="grade_facet">
				<xsl:value-of select="."/>
			</field>
		</xsl:for-each>
		<xsl:apply-templates select="dateOnObject"/>
	</xsl:template>

	<xsl:template match="adminDesc">
		<xsl:for-each select="collection | repository | owner">
			<field name="{name()}_facet">
				<xsl:value-of select="normalize-space(.)"/>
			</field>
		</xsl:for-each>

		<xsl:if test="identifier">
			<field name="identifier_display">
				<xsl:value-of select="normalize-space(identifier)"/>
			</field>
			<field name="identifier_text">
				<xsl:value-of select="normalize-space(identifier)"/>
			</field>
		</xsl:if>

		<xsl:for-each select="custodhist/chronlist/chronitem">
			<field name="prevcoll_display">
				<xsl:value-of select="date"/>
				<xsl:text> - </xsl:text>
				<xsl:choose>
					<xsl:when test="prevColl">
						<xsl:value-of select="prevColl"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="saleCatalog"/>
						<xsl:if test="saleItem">
							<xsl:text>: </xsl:text>
							<xsl:value-of select="saleItem"/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</field>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="dateOnObject">
		<field name="dob_num">
			<xsl:value-of select="date"/>
		</field>
	</xsl:template>

	<xsl:template match="measurementsSet">
		<xsl:for-each select="*">
			<field name="{name()}_num">
				<xsl:value-of select="normalize-space(.)"/>
			</field>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="date">
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

	<xsl:template match="axis">
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
