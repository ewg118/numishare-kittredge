<?xml version="1.0" encoding="UTF-8"?>
<?cocoon-disable-caching?>
<xsl:stylesheet version="2.0" xmlns:nuds="http://nomisma.org/nuds" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:datetime="http://exslt.org/dates-and-times"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:exsl="http://exslt.org/common" xmlns:mets="http://www.loc.gov/METS/"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gml="http://www.opengis.net/gml/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" exclude-result-prefixes="#all">


	<xsl:template name="nuds">
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

	<xsl:template match="nuds:refDesc">
		<xsl:for-each select="nuds:reference">
			<xsl:sort order="ascending"/>
			<field name="reference_facet">
				<xsl:value-of select="nuds:title"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="nuds:identifier"/>
			</field>
			<xsl:if test="position() = 1">
				<field name="reference_min">
					<xsl:value-of select="nuds:title"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="nuds:identifier"/>
				</field>
			</xsl:if>
			<xsl:if test="position() = last()">
				<field name="reference_max">
					<xsl:value-of select="nuds:title"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="nuds:identifier"/>
				</field>
			</xsl:if>
		</xsl:for-each>
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
