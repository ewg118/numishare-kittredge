<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:numishare="http://code.google.com/p/numishare/" exclude-result-prefixes="xs numishare" version="2.0">
	<xsl:include href="../search_segments.xsl"/>
	<xsl:param name="q"/>

	<xsl:template match="/">
		<xsl:for-each
			select="//lst[@name='facet_fields']/lst[number(int[@name='numFacetTerms']) &gt; 0 and @name !='mint_facet']">
			<li class="filter_facet ui-widget ui-state-default ui-corner-all" id="{@name}_link" label="{$q}">
				<div class="filter_heading">
					<xsl:value-of select="numishare:normalize_fields(@name)"/>
				</div>
				<ul class="filter_terms ui-widget ui-widget-content ui-corner-all hidden" id="{@name}-list"/>
			</li>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
