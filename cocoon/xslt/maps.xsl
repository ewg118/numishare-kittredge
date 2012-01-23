<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" version="2.0">
	<xsl:include href="search_segments.xsl"/>
	
	<xsl:param name="mode"/>	

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
