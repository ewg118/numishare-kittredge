<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:include href="../search_segments.xsl"/>
	<xsl:param name="q"/>

	<xsl:template match="/">
		<xsl:for-each
			select="//lst[@name='facet_fields']/lst[number(int[@name='numFacetTerms']) &gt; 0 and @name !='mint_facet']">
			<li class="filter_facet ui-widget ui-state-default ui-corner-all" id="{@name}_link" label="{$q}">
				<div class="filter_heading">
					<xsl:call-template name="normalize_fields">
						<xsl:with-param name="field" select="@name"/>
					</xsl:call-template>
				</div>
				<ul class="filter_terms ui-widget ui-widget-content ui-corner-all hidden" id="{@name}-list"/>
			</li>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
