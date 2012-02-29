<?xml version="1.0" encoding="UTF-8"?>
<?cocoon-disable-caching?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:nuds="http://nomisma.org/nuds" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="nuds cinclude"
	version="2.0">
	<xsl:include href="header.xsl"/>
	<xsl:include href="footer.xsl"/>
	<xsl:include href="display/nuds/html.xsl"/>
	<xsl:include href="display/nudsHoard/html.xsl"/>
	<xsl:include href="display/shared.xsl"/>

	<xsl:param name="pipeline"/>
	<xsl:param name="solr-url"/>
	<xsl:param name="mode"/>

	<xsl:variable name="flickr-api-key" select="/content/config/flickr_api_key"/>
	<xsl:variable name="has_mint_geo" select="/content/response-mint"/>
	<xsl:variable name="has_findspot_geo" select="/content/response-findspot"/>

	<!-- get layout -->
	<xsl:variable name="orientation" select="/content/config/theme/layouts/display/nuds/orientation"/>
	<xsl:variable name="image_location" select="/content/config/theme/layouts/display/nuds/image_location"/>

	<xsl:param name="display_path">
		<xsl:if test="not(string($mode))">
			<xsl:text>../</xsl:text>
		</xsl:if>
	</xsl:param>

	<xsl:variable name="id" select="normalize-space(//nuds:nudsid)"/>

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="not(string($mode))">
				<html>
					<head>
						<title>
							<xsl:value-of select="//config/title"/>
							<xsl:text>: </xsl:text>
							<xsl:value-of
								select="if (descendant::nuds:nuds) then descendant::nuds:nuds/nuds:descMeta/nuds:title else if (descendant::*[local-name()='nudsHoard']) then descendant::nuds:nudsid else ''"
							/>
						</title>
						<link rel="shortcut icon" type="image/x-icon" href="{$display_path}images/favicon.png"/>
						<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.8.2r1/build/grids/grids-min.css"/>
						<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.8.2r1/build/reset-fonts-grids/reset-fonts-grids.css"/>
						<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.8.2r1/build/base/base-min.css"/>
						<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.8.2r1/build/fonts/fonts-min.css"/>
						<!-- Core + Skin CSS -->
						<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.8.2r1/build/menu/assets/skins/sam/menu.css"/>
						<link type="text/css" href="{$display_path}themes/{//config/theme/jquery_ui_theme}.css" rel="stylesheet"/>
						<link type="text/css" href="{$display_path}style.css" rel="stylesheet"/>
						<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"/>
						<script type="text/javascript" src="{$display_path}javascript/jquery-ui-1.8.10.custom.min.js"/>
						<script type="text/javascript" src="{$display_path}javascript/numishare-menu.js"/>
						<xsl:if test="//nuds:nuds/@recordType='conceptual'">
							<link type="text/css" href="{$display_path}jquery.fancybox-1.3.4.css" rel="stylesheet"/>
							<link type="text/css" href="{$display_path}visualize.css" rel="stylesheet"/>
							<link type="text/css" href="{$display_path}visualize-light.css" rel="stylesheet"/>
							<script type="text/javascript" src="{$display_path}javascript/jquery.fancybox-1.3.4.min.js"/>
							<script type="text/javascript" src="{$display_path}javascript/visualize.jQuery.js"/>
							<script type="text/javascript" src="{$display_path}javascript/excanvas.js"/>
							<script type="text/javascript" src="{$display_path}javascript/display_functions.js"/>
						</xsl:if>
						<xsl:if test="string(/config/google_analytics/script)">
							<script type="text/javascript">
								<xsl:value-of select="/config/google_analytics/script"/>
							</script>
						</xsl:if>
					</head>
					<body class="yui-skin-sam">
						<div id="doc4" class="{//config/theme/layouts/*[name()=$pipeline]/yui_class}">
							<xsl:call-template name="header"/>
							<xsl:call-template name="display"/>
							<xsl:call-template name="footer"/>
						</div>
					</body>
				</html>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="display"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="display">
		<xsl:choose>
			<xsl:when test="$mode='compare'">
				<xsl:choose>
					<xsl:when test="count(/content/*[local-name()='nuds']) &gt; 0">
						<xsl:call-template name="nuds"/>
					</xsl:when>
					<xsl:otherwise> false </xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<div id="bd">
					<xsl:choose>
						<xsl:when test="count(/content/*[local-name()='nuds']) &gt; 0">
							<xsl:call-template name="nuds"/>
						</xsl:when>
						<xsl:when test="count(/content/*[local-name()='nudsHoard']) &gt; 0">
							<xsl:call-template name="nudsHoard"/>
						</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
