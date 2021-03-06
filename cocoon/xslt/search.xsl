<?xml version="1.0" encoding="UTF-8"?>
<?cocoon-disable-caching?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" encoding="UTF-8"/>
	<xsl:include href="search_segments.xsl"/>
	<xsl:include href="header.xsl"/>
	<xsl:include href="footer.xsl"/>

	<xsl:param name="pipeline"/>
	<xsl:param name="display_path"/>

	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:value-of select="//config/title"/>
					<xsl:text>: Search</xsl:text>
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

				<script type="text/javascript" src="{$display_path}javascript/jquery.livequery.js"/>
				<script type="text/javascript" src="{$display_path}javascript/search.js"/>
				<script type="text/javascript" src="{$display_path}javascript/toggle_search_options.js"/>
				<xsl:if test="string(//config/google_analytics/script)">
					<script type="text/javascript">
								<xsl:value-of select="//config/google_analytics/script"/>
							</script>
				</xsl:if>
			</head>
			<body class="yui-skin-sam">
				<div id="doc4" class="{//config/theme/layouts/*[name()=$pipeline]/yui_class}">
					<xsl:call-template name="header"/>
					<xsl:call-template name="search"/>
					<xsl:call-template name="footer"/>
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="search">
		<div id="bd">
			<h1>Search</h1>
			<p>This page allows you to search the entire collection for specific terms or keywords. To conduct a free text search select ‘Keyword’ on the drop-down menu above and enter the text for
				which you wish to search. The search allows wildcard searches with the * and ? characters and exact string matches by surrounding phrases by double quotes (like Google). <a
					href="http://lucene.apache.org/java/2_9_1/queryparsersyntax.html#Term%20Modifiers" target="_blank">See the Lucene query syntax</a> documenation for more information.</p>
			<xsl:call-template name="search_forms"/>
		</div>
	</xsl:template>

	<xsl:template name="search_forms">
		<div class="search-form">
			<form id="advancedSearchForm" method="GET" action="results">
				<div id="searchItemTemplate_1" class="searchItemTemplate">
					<select id="search_option_1" class="category_list">
						<xsl:call-template name="search_options"/>
					</select>
					<div style="display:inline;" class="option_container" id="container_1">
						<input type="text" id="search_text" class="search_text" style="display: inline;"/>
					</div>
					<a class="gateTypeBtn" href="#">add »</a>
					<a id="removeBtn_1" class="removeBtn" href="#">« remove</a>
				</div>
				<input name="q" id="q_input" type="hidden"/>
				<input type="submit" value="Search" id="search_button"/>
			</form>
		</div>

		<div id="searchItemTemplate" class="searchItemTemplate">
			<select id="search_option" class="category_list">
				<xsl:call-template name="search_options"/>
			</select>
			<div style="display:inline;" class="option_container" id="container">
				<input type="text" class="search_text" style="display: inline;"/>
			</div>
			<a class="gateTypeBtn" href="#">add »</a>
			<a id="removeBtn_1" class="removeBtn" href="#">« remove</a>
		</div>
	</xsl:template>
</xsl:stylesheet>
