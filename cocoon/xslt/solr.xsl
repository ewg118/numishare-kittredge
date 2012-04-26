<?xml version="1.0" encoding="UTF-8"?>
<!-- Author: Ethan Gruber
	Modified: April 2012
	Function: This stylesheet reads the incoming object model (nuds or nudsHoard)
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:nuds="http://nomisma.org/nuds" xmlns:nh="http://nomisma.org/nudsHoard" exclude-result-prefixes="nuds nudsHoard"
	version="2.0">
	<xsl:output method="xml" encoding="UTF-8"/>

	<xsl:include href="display/nuds/solr.xsl"/>
	<xsl:include href="display/nudsHoard/solr.xsl"/>
	<xsl:include href="display/shared-solr.xsl"/>

	<xsl:variable name="geonames-url">
		<xsl:text>http://api.geonames.org</xsl:text>
	</xsl:variable>
	<xsl:variable name="geonames_api_key" select="/content/config/geonames_api_key"/>

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="count(/content/*[local-name()='nuds']) &gt; 0">
				<xsl:call-template name="nuds"/>
			</xsl:when>
			<xsl:when test="count(/content/*[local-name()='nudsHoard']) &gt; 0">
				<xsl:call-template name="nudsHoard"/>
			</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
