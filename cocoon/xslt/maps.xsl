<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" version="2.0">
	<!-- includes -->
	<xsl:include href="header.xsl"/>
	<xsl:include href="footer.xsl"/>
	<xsl:include href="search_segments.xsl"/>
	
	<xsl:param name="pipeline"/>
	<xsl:param name="mode"/>	
	<xsl:param name="display_path"/>
	
	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:value-of select="//config/title"/><xsl:text>: Map the Collection</xsl:text>					
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
				
				<!-- maps -->
				<link type="text/css" href="{$display_path}jquery.fancybox-1.3.4.css" rel="stylesheet"/>
				<script type="text/javascript" src="{$display_path}javascript/jquery.fancybox-1.3.4.min.js"/>
				<script type="text/javascript" src="{$display_path}javascript/jquery.livequery.js"/>
				<script type="text/javascript">
					$(document).ready(function(){
						$('a.thumbImage').livequery(function(){
							$(this).fancybox();
						});
					});
				</script>
				<script type="text/javascript" src="http://www.openlayers.org/api/OpenLayers.js"/>
				<script type="text/javascript" src="http://maps.google.com/maps/api/js?v=3.2&amp;sensor=false"/>
				<script type="text/javascript" src="{$display_path}javascript/maps_get_facets.js"/>
				<script type="text/javascript" src="{$display_path}javascript/map_functions.js"/>
			</head>
			<body class="yui-skin-sam">
				<div id="doc4" class="{//config/theme/layouts/*[name()=$pipeline]/yui_class}">
					<xsl:call-template name="header"/>
					<xsl:call-template name="maps"/>
					<xsl:call-template name="footer"/>
				</div>
			</body>
		</html>
	</xsl:template>	

	<xsl:template name="maps">
		<div id="bd">
			<div id="backgroundPopup"/>
			<h1>Maps</h1>				
			<!--<cinclude:include src="cocoon:/get_department_checkbox"/>-->
			<div class="remove_facets"/>
			
			<xsl:choose>
				<xsl:when test="//result[@name='response']/@numFound &gt; 0">
					<div style="display:table;width:100%">
						<ul id="filter_list" section="maps"/>
					</div>
					<div id="basicMap"/>									
					<a name="results"/>
					<div id="results"/>
				</xsl:when>
				<xsl:otherwise>
					<h2> No results found.</h2>
				</xsl:otherwise>
			</xsl:choose>
			<input id="query" name="q" value="*:*" type="hidden"/>
		</div>
	</xsl:template>
</xsl:stylesheet>
