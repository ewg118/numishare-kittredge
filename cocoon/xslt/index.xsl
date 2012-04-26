<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" version="2.0">
	<xsl:include href="header.xsl"/>
	<xsl:include href="footer.xsl"/>

	<xsl:param name="pipeline"/>
	<xsl:param name="display_path"/>

	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:value-of select="//config/title"/>
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

				<!-- index script -->
				<script type="text/javascript" src="{$display_path}javascript/quick_search.js"/>
				<script type="text/javascript" src="{$display_path}javascript/get_features.js"/>
				<xsl:if test="string(/config/google_analytics/script)">
					<script type="text/javascript">
						<xsl:value-of select="//config/google_analytics/script"/>
					</script>
				</xsl:if>
			</head>
			<body class="yui-skin-sam">
				<div id="doc4" class="{//config/theme/layouts/*[name()=$pipeline]/yui_class}">
					<xsl:call-template name="header"/>
					<xsl:call-template name="index"/>
					<xsl:call-template name="footer"/>
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="index">
		<div id="bd">
			<div id="yui-main">
				<div class="yui-b">
					<xsl:copy-of select="saxon:parse(concat('&lt;div&gt;', string(//pages/index), '&lt;/div&gt;'))"/>
				</div>
			</div>
			<div class="yui-b" id="numishare-widget">
				<div id="quick_search" style="margin:10px 0;">
					<div class="ui-widget-header ui-helper-clearfix ui-corner-all">Search the Collection</div>
					<form action="results" method="GET" id="qs_form" style="padding:10px 0">
						<input type="text" id="qs_text"/>
						<input type="hidden" name="q" id="qs_query" value="*:*"/>
						<input id="qs_button" type="submit" value="Search"/>
					</form>
				</div>
				<div id="linked_data" style="margin:10px 0;">
					<div class="ui-widget-header ui-helper-clearfix ui-corner-all">Linked Data</div>
					<a href="{$display_path}rdf/">
						<img src="{$display_path}images/rdf-large.gif" title="RDF" alt="PDF"/>
					</a>
					<a href="{$display_path}feed/?q=*:*">
						<img src="{$display_path}images/atom-large.png" title="Atom" alt="Atom"/>
					</a>
				</div>
				<xsl:if test="//config/features_enabled = true()">
					<div id="feature" style="margin:10px 0;">
						<div class="ui-widget-header ui-helper-clearfix ui-corner-all">Featured Object</div>
					</div>
				</xsl:if>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
