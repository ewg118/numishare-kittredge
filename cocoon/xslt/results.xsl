<?xml version="1.0" encoding="UTF-8"?>
<?cocoon-disable-caching?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:exsl="http://exslt.org/common" xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:numishare="http://code.google.com/p/numishare/" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:include href="results_generic.xsl"/>
	<xsl:include href="search_segments.xsl"/>

	<xsl:param name="q"/>
	<xsl:param name="sort"/>
	<xsl:param name="rows">20</xsl:param>
	<xsl:param name="start"/>
	<xsl:param name="tokenized_q" select="tokenize($q, ' AND ')"/>
	<xsl:param name="mode"/>

	<xsl:variable name="numFound" select="//result[@name='response']/@numFound" as="xs:integer"/>

	<xsl:template name="results">
		<div id="backgroundPopup"/>
		<div id="bd">
			<div id="yui-main">
				<div class="yui-b">
					<div style="{if (//config/theme/layouts/*[name()=$pipeline]/yui_class = 'yui-t2') then 'margin-left:20px' else ''}">
						<xsl:call-template name="remove_facets"/>
						<xsl:choose>
							<xsl:when test="$numFound &gt; 0">
								<!-- include resultMap div when there are geographical results-->
								<xsl:if test="//lst[@name='mint_geo']/int[@name='numFacetTerms'] &gt; 0">
									<div style="display:none">
										<div id="resultMap"/>
									</div>
								</xsl:if>
								<xsl:call-template name="paging"/>
								<xsl:call-template name="sort"/>
								<table>
									<xsl:apply-templates select="descendant::doc"/>
								</table>
								<xsl:call-template name="paging"/>
							</xsl:when>
							<xsl:otherwise>
								<h2> No results found. <a href="results?q=*:*">Start over.</a></h2>
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</div>
			</div>
			<div class="yui-b">
				<xsl:if test="//result[@name='response']/@numFound &gt; 0">
					<div class="data_options">
						<h2>Data Options</h2>
						<a href="{$display_path}feed/?q={$q}">
							<img src="{$display_path}images/atom-medium.png" title="Atom" alt="Atom"/>
						</a>
						<xsl:if test="//lst[@name='mint_geo']/int[@name='numFacetTerms'] &gt; 0">
							<a href="{$display_path}query.kml?q={$q}">
								<img src="{$display_path}images/googleearth.png" alt="KML" title="KML: Limit, 500 objects"/>
							</a>
						</xsl:if>
						<a href="{$display_path}data.csv?q={$q}">
							<!-- the image below is copyright of Silvestre Herrera, available freely on wikimedia commons: http://commons.wikimedia.org/wiki/File:X-office-spreadsheet_Gion.svg -->
							<img src="{$display_path}images/spreadsheet.png" title="CSV" alt="CSV"/>
						</a>
						<a href="{$display_path}visualize?q={$q}">
							<!-- the image below is copyright of Mark James, available freely on wikimedia commons: http://commons.wikimedia.org/wiki/File:Chart_bar.png -->
							<img src="{$display_path}images/visualize.png" title="Visualize" alt="Visualize"/>
						</a>
					</div>
					<h2>Refine Results</h2>
					<xsl:call-template name="quick_search"/>
					<xsl:apply-templates select="descendant::lst[@name='facet_fields']"/>
				</xsl:if>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
