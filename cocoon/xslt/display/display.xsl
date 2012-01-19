<?xml version="1.0" encoding="UTF-8"?>
<?cocoon-disable-caching?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">	
	<xsl:include href="nuds/html.xsl"/>

	<xsl:param name="q"/>	
	<xsl:param name="start"/>
	<xsl:param name="mode"/>
	<xsl:param name="image"/>
	<xsl:param name="side"/>
	
	<!-- comment out the following three params when running in production, i.e. rendering from layout.xsl -->	
	<xsl:param name="display_path">
		<xsl:if test="not(string($mode))">
			<xsl:text>../</xsl:text>
		</xsl:if>
	</xsl:param>
	<xsl:param name="pipeline"/>
	<xsl:param name="solr-url"/>
	
	
	<xsl:variable name="flickr-api-key" select="/content/config/flickr_api_key"/>
	<xsl:variable name="has_mint_geo" select="/content/response-mint"/>
	<xsl:variable name="has_findspot_geo" select="/content/response-findspot"/>
	
	<!-- get layout -->
	<xsl:variable name="orientation" select="/content/config/theme/layouts/display/nuds/orientation"/>
	<xsl:variable name="image_location" select="/content/config/theme/layouts/display/nuds/image_location"/>	

	<xsl:template name="display">		
		<xsl:choose>
			<xsl:when test="$mode='compare'">
				<xsl:choose>
					<xsl:when test="descendant::nuds">
						<xsl:call-template name="nuds"/>
					</xsl:when>
					<xsl:otherwise> false </xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<div id="bd">
					<xsl:choose>
						<xsl:when test="descendant::nuds">
							<xsl:call-template name="nuds"/>
						</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>
				</div>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	
	<!--<xsl:template match="/">
		<html>
			<head>
				<title><xsl:value-of select="/content/config/title"/>: <xsl:value-of select="if (descendant::nuds) then descendant::nuds/descMeta/title else ''"/></title>
				<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.8.2r1/build/grids/grids-min.css"/>
				<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.8.2r1/build/reset-fonts-grids/reset-fonts-grids.css"/>
				<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.8.2r1/build/base/base-min.css"/>
				<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.8.2r1/build/fonts/fonts-min.css"/>
				<!-\- Core + Skin CSS -\->
				<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.8.2r1/build/menu/assets/skins/sam/menu.css"/>
				<link type="text/css" href="{$display_path}themes/{/content/config/theme/jquery_ui_theme}.css" rel="stylesheet"/>
				
				<link type="text/css" href="{$display_path}style.css" rel="stylesheet"/>
				<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"/>
				<script type="text/javascript" src="{$display_path}javascript/jquery-ui-1.8.10.custom.min.js"/>
				<script type="text/javascript" src="{$display_path}javascript/numishare-menu.js"/>
				
				<!-\- if the recordType is conceptual, load fancybox -\->
				<xsl:if test="/nuds/@recordType='conceptual'">
					<link type="text/css" href="{$display_path}jquery.fancybox-1.3.4.css" rel="stylesheet"/>
					<script type="text/javascript" src="{$display_path}javascript/jquery.fancybox-1.3.4.min.js"/>
					<script type="text/javascript">
						$(document).ready(function(){
                                                                		$('a.thumbImage').fancybox();
						});
					</script>
				</xsl:if>
			</head>
			
			<body class="yui-skin-sam">
				<div id="doc4" class="yui-t6">
					<!-\-<xsl:call-template name="header"/>-\->
					<div id="bd">
						<xsl:choose>
							<xsl:when test="descendant::nuds">
								<xsl:call-template name="nuds"/>
							</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</div>
					<!-\-<xsl:call-template name="footer"/>-\->
				</div>
			</body>
		</html>
	</xsl:template>-->
</xsl:stylesheet>
