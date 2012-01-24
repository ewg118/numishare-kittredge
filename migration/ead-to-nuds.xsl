<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:datetime="http://exslt.org/dates-and-times" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:gsx="http://schemas.google.com/spreadsheets/2006/extended" xmlns:numishare="http://code.google.com/p/numishare/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	exclude-result-prefixes="xs" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:exsl="http://exslt.org/common" version="2.0">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="geonames-url">
		<xsl:text>http://api.geonames.org</xsl:text>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:apply-templates select="/c"/>
	</xsl:template>

	<xsl:template match="c">
		<xsl:variable name="accnum" select="did/unitid[@type='accession']"/>

		<nuds recordType="physical" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:mets="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
			xmlns:gml="http://www.opengis.net/gml">
			<nudsHeader>
				<nudsid>
					<xsl:value-of select="@id"/>
				</nudsid>
				<publicationStmt>
					<publisher>Kittredge Numismatic Foundation</publisher>
					<createdBy>Ethan Gruber</createdBy>
					<date normal="{if(contains(datetime:dateTime(), 'Z')) then datetime:dateTime() else concat(datetime:dateTime(), 'Z')}"/>
					<langUsage>
						<language langcode="en">English</language>
					</langUsage>
				</publicationStmt>
				<rightsStmt>
					<copyrightHolder>Kittredge Numismatic Foundation</copyrightHolder>
					<date normal="2012"/>
				</rightsStmt>
				<revisionStmt>
					<revision>
						<description>Migrated from EAD to NUDS</description>
						<date normal="{if(contains(datetime:dateTime(), 'Z')) then datetime:dateTime() else concat(datetime:dateTime(), 'Z')}"/>
					</revision>
				</revisionStmt>
			</nudsHeader>
			<descMeta>
				<title>
					<xsl:value-of select="descendant::unittitle"/>
				</title>
				<xsl:if test="descendant::materialspec[@type='department']">
					<department>
						<xsl:value-of select="descendant::materialspec[@type='department']"/>
					</department>
				</xsl:if>
				<xsl:if test="descendant::abstract">
					<description>
						<xsl:value-of select="descendant::abstract"/>
					</description>
				</xsl:if>
				<xsl:if test="count(descendant::subject) &gt; 0">
					<subjectSet>
						<xsl:for-each select="descendant::subject">
							<xsl:copy-of select="."/>
						</xsl:for-each>
					</subjectSet>
				</xsl:if>
				<physDesc>
					<xsl:apply-templates select="descendant::physdesc"/>
				</physDesc>
				<typeDesc>
					<objectType>
						<xsl:value-of select="lower-case(descendant::genreform[@type='format'])"/>
					</objectType>
					<xsl:for-each select="descendant::genreform[@type='denomination']">
						<denomination>
							<xsl:value-of select="."/>
						</denomination>
					</xsl:for-each>
					<xsl:for-each select="descendant::physfacet[@type='material']">
						<material>
							<xsl:choose>
								<xsl:when test=". = 'silver'">
									<xsl:attribute name="rdf:resource">http://nomisma.org/id/ar</xsl:attribute>
									<xsl:text>Silver</xsl:text>
								</xsl:when>
								<xsl:when test=". = 'gold'">
									<xsl:attribute name="rdf:resource">http://nomisma.org/id/au</xsl:attribute>
									<xsl:text>Gold</xsl:text>
								</xsl:when>
								<xsl:when test=". = 'copper'">
									<xsl:attribute name="rdf:resource">http://nomisma.org/id/cu</xsl:attribute>
									<xsl:text>Copper</xsl:text>
								</xsl:when>
								<xsl:when test=". = 'bronze'">
									<xsl:attribute name="rdf:resource">http://nomisma.org/id/ae</xsl:attribute>
									<xsl:text>Bronze</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="."/>
								</xsl:otherwise>
							</xsl:choose>
						</material>
					</xsl:for-each>
					<xsl:apply-templates select="descendant::unitdate"/>
					<xsl:if test="count(descendant::*[@role]) &gt; 0 or count(descendant::famname) &gt; 0">
						<authority>
							<xsl:for-each
								select="descendant::*[@role='issuer']|descendant::*[@role='authority']|descendant::*[@role='magistrate']|descendant::*[@role='artist']|descendant::*[@role='engraver']|descendant::*[@role='maker']|descendant::famname">
								<xsl:copy-of select="."/>
							</xsl:for-each>
							<xsl:for-each select="descendant::corpname">
								<corpname role="authority">
									<xsl:value-of select="."/>
								</corpname>
							</xsl:for-each>
						</authority>
					</xsl:if>
					<xsl:if test="count(descendant::geogname) &gt; 0">
						<geographic>
							<xsl:apply-templates select="descendant::geogname[@role='city']"/>
							<xsl:apply-templates select="descendant::geogname[@role='region']"/>
						</geographic>
					</xsl:if>
					<xsl:if test="descendant::physfacet[contains(@type, 'obverse')] or count(descendant::persname[not(@role)]) &gt; 0">
						<obverse>
							<xsl:if test="descendant::physfacet[@type='obverse_iconography']">
								<type>
									<xsl:value-of select="descendant::physfacet[@type='obverse_iconography']"/>
								</type>
							</xsl:if>
							<xsl:if test="descendant::physfacet[@type='obverse_legend']">
								<legend>
									<xsl:value-of select="descendant::physfacet[@type='obverse_legend']"/>
								</legend>
							</xsl:if>
							<xsl:for-each select="descendant::persname[not(@role)]">
								<persname role="portrait">
									<xsl:value-of select="."/>
								</persname>
							</xsl:for-each>
						</obverse>
					</xsl:if>
					<xsl:if test="descendant::physfacet[contains(@type, 'reverse')] or count(descendant::persname[@role='deity']) &gt; 0">
						<reverse>
							<xsl:if test="descendant::physfacet[@type='reverse_iconography']">
								<type>
									<xsl:value-of select="descendant::physfacet[@type='reverse_iconography']"/>
								</type>
							</xsl:if>
							<xsl:if test="descendant::physfacet[@type='reverse_legend']">
								<legend>
									<xsl:value-of select="descendant::physfacet[@type='reverse_legend']"/>
								</legend>
							</xsl:if>
							<xsl:for-each select="descendant::persname[@role='deity']">
								<persname role="deity">
									<xsl:value-of select="."/>
								</persname>
							</xsl:for-each>
						</reverse>
					</xsl:if>
				</typeDesc>
				<adminDesc>
					<xsl:if test="string(//daoloc[@label='screen_obv'])">
						<identifier>
							<xsl:value-of select="substring-after(substring-before(//daoloc[@label='screen_obv'], '_'), 'screen/')"/>
						</identifier>
					</xsl:if>
					<collection>Kittredge Collection</collection>
					<xsl:apply-templates select="descendant::acqinfo"/>
					<xsl:apply-templates select="descendant::altformavail"/>
					<xsl:apply-templates select="descendant::appraisal"/>
					<xsl:apply-templates select="descendant::custodhist"/>
				</adminDesc>
				<xsl:apply-templates select="descendant::bibliography"/>
			</descMeta>
			<xsl:if test="descendant::daogrp[string(daoloc[1]/@href)]">
				<digRep>
					<mets:fileSec>
						<mets:fileGrp USE="obverse">
							<mets:file USE="reference" MIMETYPE="image/jpeg">
								<mets:FLocat LOCTYPE="URL" xlink:href="{descendant::daoloc[@label='screen_obv']/@href}"/>
							</mets:file>
							<mets:file USE="thumbnail" MIMETYPE="image/jpeg">
								<mets:FLocat LOCTYPE="URL" xlink:href="{descendant::daoloc[@label='thumb_obv']/@href}"/>
							</mets:file>
						</mets:fileGrp>
						<mets:fileGrp USE="reverse">
							<mets:file USE="reference" MIMETYPE="image/jpeg">
								<mets:FLocat LOCTYPE="URL" xlink:href="{descendant::daoloc[@label='screen_rev']/@href}"/>
							</mets:file>
							<mets:file USE="thumbnail" MIMETYPE="image/jpeg">
								<mets:FLocat LOCTYPE="URL" xlink:href="{descendant::daoloc[@label='thumb_rev']/@href}"/>
							</mets:file>
						</mets:fileGrp>
					</mets:fileSec>
				</digRep>
			</xsl:if>
		</nuds>
	</xsl:template>

	<xsl:template match="unitdate">
		<date normal="{@normal}">
			<xsl:value-of select="."/>
		</date>
	</xsl:template>

	<xsl:template match="physdesc">
		<xsl:if test="string(physfacet[@type='axis'])">
			<axis>
				<xsl:value-of select="physfacet[@type='axis']"/>
			</axis>
		</xsl:if>
		<xsl:for-each select="physfacet[@type='color']">
			<color>
				<xsl:value-of select="."/>
			</color>
		</xsl:for-each>
		<xsl:for-each select="physfacet[@type='dob']">
			<dateOnObject>
				<date>
					<xsl:value-of select="."/>
				</date>
			</dateOnObject>
		</xsl:for-each>
		<xsl:if test="number(dimensions) or number(physfacet[@type='weight'])">
			<measurementsSet>
				<xsl:if test="number(dimensions)">
					<diameter units="mm">
						<xsl:value-of select="dimensions"/>
					</diameter>
				</xsl:if>
				<xsl:if test="number(physfacet[@type='weight'])">
					<weight units="g">
						<xsl:value-of select="physfacet[@type='weight']"/>
					</weight>
				</xsl:if>
			</measurementsSet>
		</xsl:if>
		<xsl:for-each select="physfacet[@type='shape']">
			<shape>
				<xsl:value-of select="."/>
			</shape>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="acqinfo">
		<acquiredFrom>
			<xsl:value-of select="p"/>
		</acquiredFrom>
	</xsl:template>

	<xsl:template match="appraisal">
		<appraisal>
			<xsl:value-of select="p"/>
		</appraisal>
	</xsl:template>

	<xsl:template match="altformavail">
		<acknowledgment>
			<xsl:value-of select="p"/>
		</acknowledgment>
	</xsl:template>

	<!-- suppress findspot -->
	<xsl:template match="geogname[@role='findspot']"/>

	<xsl:template match="bibliography">
		<refDesc>
			<xsl:for-each select="bibref[not(@type='citation')][string(.)]">
				<reference>
					<xsl:choose>
						<xsl:when test="child::*">
							<xsl:if test="title">
								<title>
									<xsl:value-of select="title"/>
								</title>
							</xsl:if>
							<xsl:if test="num">
								<identifier>
									<xsl:value-of select="num"/>
								</identifier>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</reference>
			</xsl:for-each>
			<xsl:for-each select="bibref[@type='published'][string(.)]">
				<citation>
					<xsl:value-of select="."/>
				</citation>
			</xsl:for-each>
		</refDesc>
	</xsl:template>

	<xsl:template match="geogname[@role='city']">
		<xsl:variable name="mint" select="normalize-space(.)"/>
		<xsl:variable name="states">
			<xsl:for-each select="//geogname[@role='state']">
				<xsl:value-of select="."/>
				<xsl:if test="not(position()=last())">
					<xsl:text>|</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="spreadsheet">
			<xsl:text>https://spreadsheets.google.com/feeds/list/0Avp6BVZhfwHAdHQ5UE01dDAxOWFsWjJ2UGtiMmRCSnc/od6/public/values</xsl:text>
		</xsl:variable>
		<xsl:variable name="uri">
			<xsl:choose>
				<xsl:when test="count(document(concat($spreadsheet, '?sq=mint%3d%22', encode-for-uri($mint), '%22'))//atom:entry) = 1">
					<xsl:value-of select="document(concat($spreadsheet, '?sq=mint%3d%22', encode-for-uri($mint), '%22'))//atom:entry/gsx:uri"/>
				</xsl:when>
				<xsl:when test="count(document(concat($spreadsheet, '?sq=mint%3d%22', encode-for-uri($mint), '%22'))//atom:entry) &gt; 1">
					<xsl:for-each select="document(concat($spreadsheet, '?sq=mint%3d%22', encode-for-uri($mint), '%22'))//atom:entry[contains($states, gsx:state)]">
						<xsl:value-of select="gsx:uri"/>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<geogname role="mint">
			<xsl:choose>
				<xsl:when test="string($uri)">
					<xsl:attribute name="rdf:resource" select="$uri"/>

					<xsl:variable name="geonameId" select="substring-before(substring-after($uri, 'geonames.org/'), '/')"/>
					<xsl:variable name="geonames_data" select="document(concat($geonames-url, '/get?geonameId=', $geonameId, '&amp;username=anscoins&amp;style=full'))"/>

					<!-- get place name-->
					<xsl:variable name="countryCode" select="exsl:node-set($geonames_data)/geoname/countryCode"/>
					<xsl:variable name="countryName" select="exsl:node-set($geonames_data)/geoname/countryName"/>
					<xsl:variable name="name" select="exsl:node-set($geonames_data)/geoname/name"/>
					<xsl:variable name="adminName1" select="exsl:node-set($geonames_data)/geoname/adminName1"/>
					<xsl:variable name="fcode" select="exsl:node-set($geonames_data)/geoname/fcode"/>


					<xsl:choose>
						<xsl:when test="$countryCode = 'US' or $countryCode = 'AU' or $countryCode = 'CA'">
							<xsl:choose>
								<xsl:when test="$fcode = 'ADM1'">
									<xsl:value-of select="$name"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$name"/>
									<xsl:text> (</xsl:text>
									<xsl:value-of select="numishare:get-region($countryCode, $adminName1)"/>
									<xsl:text>)</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$countryCode='GB'">
							<xsl:choose>
								<xsl:when test="$fcode = 'ADM1'">
									<xsl:value-of select="$name"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat($name, ' (', $adminName1, ')')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$fcode='PCLI'">
							<xsl:value-of select="$name"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($name, ' (', $countryName, ')')"/>
						</xsl:otherwise>
					</xsl:choose>

				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$mint"/>
				</xsl:otherwise>
			</xsl:choose>
		</geogname>
	</xsl:template>

	<xsl:template match="geogname[@role='region']">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:function name="numishare:get-region">
		<xsl:param name="countryCode"/>
		<xsl:param name="adminName1"/>

		<xsl:choose>
			<xsl:when test="$countryCode='US'">
				<xsl:choose>
					<xsl:when test="$adminName1='Alabama'">Ala.</xsl:when>
					<xsl:when test="$adminName1='Alaska'">Alaska</xsl:when>
					<xsl:when test="$adminName1='Arizona'">Ariz.</xsl:when>
					<xsl:when test="$adminName1='Arkansas'">Ark.</xsl:when>
					<xsl:when test="$adminName1='California'">Calif.</xsl:when>
					<xsl:when test="$adminName1='Colorado'">Colo.</xsl:when>
					<xsl:when test="$adminName1='Connecticut'">Conn.</xsl:when>
					<xsl:when test="$adminName1='Delaware'">Del.</xsl:when>
					<xsl:when test="$adminName1='Washington, D.C.'">D.C.</xsl:when>
					<xsl:when test="$adminName1='Florida'">Fla.</xsl:when>
					<xsl:when test="$adminName1='Georgia'">Ga.</xsl:when>
					<xsl:when test="$adminName1='Hawaii'">Hawaii</xsl:when>
					<xsl:when test="$adminName1='Idaho'">Idaho</xsl:when>
					<xsl:when test="$adminName1='Illinois'">Ill.</xsl:when>
					<xsl:when test="$adminName1='Indiana'">Ind.</xsl:when>
					<xsl:when test="$adminName1='Iowa'">Iowa</xsl:when>
					<xsl:when test="$adminName1='Kansas'">Kans.</xsl:when>
					<xsl:when test="$adminName1='Kentucky'">Ky.</xsl:when>
					<xsl:when test="$adminName1='Louisiana'">La.</xsl:when>
					<xsl:when test="$adminName1='Maine'">Maine</xsl:when>
					<xsl:when test="$adminName1='Maryland'">Md.</xsl:when>
					<xsl:when test="$adminName1='Massachusetts'">Mass.</xsl:when>
					<xsl:when test="$adminName1='Michigan'">Mich.</xsl:when>
					<xsl:when test="$adminName1='Minnesota'">Minn.</xsl:when>
					<xsl:when test="$adminName1='Mississippi'">Miss.</xsl:when>
					<xsl:when test="$adminName1='Missouri'">Mo.</xsl:when>
					<xsl:when test="$adminName1='Montana'">Mont.</xsl:when>
					<xsl:when test="$adminName1='Nebraska'">Nebr.</xsl:when>
					<xsl:when test="$adminName1='Nevada'">Nev.</xsl:when>
					<xsl:when test="$adminName1='New Hampshire'">N.H.</xsl:when>
					<xsl:when test="$adminName1='New Jersey'">N.J.</xsl:when>
					<xsl:when test="$adminName1='New Mexico'">N.M.</xsl:when>
					<xsl:when test="$adminName1='New York'">N.Y.</xsl:when>
					<xsl:when test="$adminName1='North Carolina'">N.C.</xsl:when>
					<xsl:when test="$adminName1='North Dakota'">N.D.</xsl:when>
					<xsl:when test="$adminName1='Ohio'">Ohio</xsl:when>
					<xsl:when test="$adminName1='Oklahoma'">Okla.</xsl:when>
					<xsl:when test="$adminName1='Oregon'">Oreg.</xsl:when>
					<xsl:when test="$adminName1='Pennsylvania'">Pa.</xsl:when>
					<xsl:when test="$adminName1='Rhode Island'">R.I.</xsl:when>
					<xsl:when test="$adminName1='South Carolina'">S.C.</xsl:when>
					<xsl:when test="$adminName1='South Dakota'">S.D</xsl:when>
					<xsl:when test="$adminName1='Tennessee'">Tenn.</xsl:when>
					<xsl:when test="$adminName1='Texas'">Tex.</xsl:when>
					<xsl:when test="$adminName1='Utah'">Utah</xsl:when>
					<xsl:when test="$adminName1='Vermont'">Vt.</xsl:when>
					<xsl:when test="$adminName1='Virginia'">Va.</xsl:when>
					<xsl:when test="$adminName1='Washington'">Wash.</xsl:when>
					<xsl:when test="$adminName1='West Virginia'">W.Va.</xsl:when>
					<xsl:when test="$adminName1='Wisconsin'">Wis.</xsl:when>
					<xsl:when test="$adminName1='Wyoming'">Wyo.</xsl:when>
					<xsl:when test="$adminName1='American Samoa'">A.S.</xsl:when>
					<xsl:when test="$adminName1='Guam'">Guam</xsl:when>
					<xsl:when test="$adminName1='Northern Mariana Islands'">M.P.</xsl:when>
					<xsl:when test="$adminName1='Puerto Rico'">P.R.</xsl:when>
					<xsl:when test="$adminName1='U.S. Virgin Islands'">V.I.</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$countryCode='CA'">
				<xsl:choose>
					<xsl:when test="$adminName1='Alberta'">Alta.</xsl:when>
					<xsl:when test="$adminName1='British Columbia'">B.C.</xsl:when>
					<xsl:when test="$adminName1='Manitoba'">Alta.</xsl:when>
					<xsl:when test="$adminName1='Alberta'">Man.</xsl:when>
					<xsl:when test="$adminName1='New Brunswick'">N.B.</xsl:when>
					<xsl:when test="$adminName1='Newfoundland and Labrador'">Nfld.</xsl:when>
					<xsl:when test="$adminName1='Northwest Territories'">N.W.T.</xsl:when>
					<xsl:when test="$adminName1='Nova Scotia'">N.S.</xsl:when>
					<xsl:when test="$adminName1='Nunavut'">NU</xsl:when>
					<xsl:when test="$adminName1='Ontario'">Ont.</xsl:when>
					<xsl:when test="$adminName1='Prince Edward Island'">P.E.I.</xsl:when>
					<xsl:when test="$adminName1='Quebec'">Que.</xsl:when>
					<xsl:when test="$adminName1='Saskatchewan'">Sask.</xsl:when>
					<xsl:when test="$adminName1='Yukon'">Y.T.</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$countryCode='AU'">
				<xsl:choose>
					<xsl:when test="$adminName1='Australian Capital Territory'">A.C.T.</xsl:when>
					<xsl:when test="$adminName1='Jervis Bay Territory'">J.B.T.</xsl:when>
					<xsl:when test="$adminName1='New South Wales'">N.S.W.</xsl:when>
					<xsl:when test="$adminName1='Northern Territory'">N.T.</xsl:when>
					<xsl:when test="$adminName1='Queensland'">Qld.</xsl:when>
					<xsl:when test="$adminName1='South Australia'">S.A.</xsl:when>
					<xsl:when test="$adminName1='Tasmania'">Tas.</xsl:when>
					<xsl:when test="$adminName1='Victoria'">Vic.</xsl:when>
					<xsl:when test="$adminName1='Western Australia'">W.A.</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:function>

</xsl:stylesheet>
