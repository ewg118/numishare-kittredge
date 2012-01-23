<?xml version="1.0" encoding="UTF-8"?>
<!-- Master layout for all HTML pages of Numishare
	Author: Ethan Gruber
	Last Modified: July 2011
	
This file is the master layout stylesheet for all public HTML pages in Numishare.  It includes yui and jquery-ui css, the Numishare-specific style.css, and templates for yui grids.  
Components of the layout are modified in the Numishare XForms Theme section.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs cinclude" version="2.0"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0">
	<!-- includes -->
	<xsl:include href="header.xsl"/>
	<xsl:include href="footer.xsl"/>
	<!-- pipelines -->
	<xsl:include href="index.xsl"/>
	<xsl:include href="search.xsl"/>
	<xsl:include href="compare.xsl"/>
	<xsl:include href="maps.xsl"/>
	<xsl:include href="pages.xsl"/>
	<xsl:include href="results.xsl"/>
	<xsl:include href="visualize.xsl"/>
	<xsl:include href="display/display.xsl"/>

	<!-- params -->
	<xsl:param name="pipeline"/>
	<xsl:param name="solr-url"/>

	<xsl:param name="display_path">
		<xsl:choose>
			<xsl:when test="$pipeline='index' or $pipeline='compare' or $pipeline='search' or $pipeline='maps' or $pipeline='results' or $pipeline='visualize'"/>
			<xsl:when test="$pipeline='display'">
				<xsl:if test="not(string($mode))">
					<xsl:text>../</xsl:text>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$pipeline='pages'">
				<xsl:text>../</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:param>

	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:value-of select="//config/title"/>
					<!-- pipeline-specific titles -->
					<xsl:if test="not($pipeline='index')">
						<xsl:text>: </xsl:text>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$pipeline='display'">
							<xsl:value-of select="if (descendant::nuds) then descendant::nuds/descMeta/title else ''"/>
						</xsl:when>
						<xsl:when test="$pipeline='search'">
							<xsl:text>Search</xsl:text>
						</xsl:when>
						<xsl:when test="$pipeline='compare'">
							<xsl:text>Compare Coins</xsl:text>
						</xsl:when>
						<xsl:when test="$pipeline='maps'">
							<xsl:text>Map the Collection</xsl:text>
						</xsl:when>
						<xsl:when test="$pipeline='pages'">
							<xsl:value-of select="//page[@stub = $stub]/title"/>
						</xsl:when>
						<xsl:when test="$pipeline='results'">
							<xsl:text>Browse Collection</xsl:text>
						</xsl:when>
						<xsl:when test="$pipeline='visualize'">
							<xsl:text>Visualize</xsl:text>
						</xsl:when>
					</xsl:choose>
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

				<!-- pipeline-specific javascript includes -->
				<xsl:choose>
					<xsl:when test="$pipeline='index'">
						<script type="text/javascript" src="{$display_path}javascript/get_features.js"/>
					</xsl:when>
					<xsl:when test="$pipeline='compare'">
						<script type="text/javascript" src="{$display_path}javascript/jquery.livequery.js"/>
						<script type="text/javascript" src="{$display_path}javascript/compare.js"/>
						<script type="text/javascript" src="{$display_path}javascript/compare_functions.js"/>
						<script type="text/javascript" src="{$display_path}javascript/numishare-menu.js"/>
					</xsl:when>
					<xsl:when test="$pipeline='maps'">						
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
					</xsl:when>
					<xsl:when test="$pipeline='search'">
						<script type="text/javascript" src="{$display_path}javascript/jquery.livequery.js"/>
						<script type="text/javascript" src="{$display_path}javascript/search.js"/>
						<script type="text/javascript" src="{$display_path}javascript/toggle_search_options.js"/>
					</xsl:when>
					<xsl:when test="$pipeline='results'">
						<link type="text/css" href="{$display_path}jquery.multiselect.css" rel="stylesheet"/>
						<link type="text/css" href="{$display_path}jquery.fancybox-1.3.4.css" rel="stylesheet"/>
						<script type="text/javascript" src="{$display_path}javascript/jquery.multiselect.min.js"/>
						<script type="text/javascript" src="{$display_path}javascript/jquery.multiselectfilter.js"/>
						<script type="text/javascript" src="{$display_path}javascript/jquery.livequery.js"/>
						<script type="text/javascript" src="{$display_path}javascript/jquery.fancybox-1.3.4.min.js"/>
						<script type="text/javascript" src="{$display_path}javascript/get_facets.js"/>
						<script type="text/javascript" src="{$display_path}javascript/sort_results.js"/>
						<script type="text/javascript" src="{$display_path}javascript/numishare-menu.js"/>
						<script type="text/javascript">
							$(document).ready(function(){
								$('a.thumbImage').fancybox();
							});
						</script>
						<xsl:if test="//lst[@name='mint_geo']/int[@name='numFacetTerms'] &gt; 0">
							<script src="http://www.openlayers.org/api/OpenLayers.js" type="text/javascript">//</script>
							<script src="http://maps.google.com/maps/api/js?v=3.2&amp;sensor=false">//</script>
							<script type="text/javascript" src="{$display_path}javascript/result_map_functions.js"/>
							<script type="text/javascript">
								$(document).ready(function() {
									$("#map_results").fancybox({
										onComplete: function(){
											if  ($('#resultMap').html().length == 0){								
												$('#resultMap').html('');
												initialize_map('<xsl:value-of select="$q"/>');
											}
										}
									});
								});
							</script>
						</xsl:if>
						<script type="text/javascript" src="javascript/quick_search.js"/>
					</xsl:when>
					<xsl:when test="$pipeline='display'">
						<xsl:if test="//nuds/@recordType='conceptual'">
							<link type="text/css" href="{$display_path}jquery.fancybox-1.3.4.css" rel="stylesheet"/>
							<script type="text/javascript" src="{$display_path}javascript/jquery.fancybox-1.3.4.min.js"/>
							<script type="text/javascript">
								$(document).ready(function(){
		                                                                		$('a.thumbImage').fancybox();
								});
							</script>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$pipeline='visualize'">
						<link type="text/css" href="{$display_path}visualize.css" rel="stylesheet"/>
						<link type="text/css" href="{$display_path}visualize-light.css" rel="stylesheet"/>
						<script type="text/javascript" src="{$display_path}javascript/visualize.jQuery.js"/>
						<script type="text/javascript" src="{$display_path}javascript/excanvas.js"/>
						<script type="text/javascript">
							$(document).ready(function() {
								$('table').visualize({
									width: 800<xsl:value-of select="if(string($type)) then concat(', type:&#x022;', $type, '&#x022;') else ''"/>
									<xsl:value-of select="if(string($pieMargin)) then concat(', pieMargin:', $pieMargin) else ''"/>
									<xsl:value-of select="if(string($lineWeight)) then concat(', lineWeight:', $lineWeight) else ''"/>
									<xsl:value-of select="if(string($pieLabelPos)) then concat(', pieLabelPos:&#x022;', $pieLabelPos, '&#x022;') else ''"/>
									<xsl:value-of select="if(string($barMargin)) then concat(', barMargin:', $barMargin) else ''"/>
									<xsl:value-of select="if(string($barGroupMargin)) then concat(', barGroupMargin:', $barGroupMargin) else ''"/>
								});
								//hide table
								$('table').addClass('accessHide');
							});
						</script>
						<script type="text/javascript" src="javascript/visualize_functions.js"/>
					</xsl:when>
				</xsl:choose>


			</head>
			<body class="yui-skin-sam">
				<div id="doc4" class="{//config/theme/layouts/*[name()=$pipeline]/yui_class}">
					<xsl:call-template name="header"/>
					<xsl:choose>
						<xsl:when test="$pipeline='index'">
							<xsl:call-template name="index"/>
						</xsl:when>
						<xsl:when test="$pipeline='search'">
							<xsl:call-template name="search"/>
						</xsl:when>
						<xsl:when test="$pipeline='compare'">
							<xsl:call-template name="compare"/>
						</xsl:when>
						<xsl:when test="$pipeline='maps'">
							<xsl:call-template name="maps"/>
						</xsl:when>
						<xsl:when test="$pipeline='pages'">
							<xsl:call-template name="pages"/>
						</xsl:when>
						<xsl:when test="$pipeline='results'">
							<xsl:call-template name="results"/>
						</xsl:when>
						<xsl:when test="$pipeline='visualize'">
							<xsl:call-template name="visualize"/>
						</xsl:when>
						<xsl:when test="$pipeline='display'">
							<xsl:call-template name="display"/>
						</xsl:when>
					</xsl:choose>
					<xsl:call-template name="footer"/>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
