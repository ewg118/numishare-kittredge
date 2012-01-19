<?xml version="1.0" encoding="UTF-8"?>
<?cocoon-disable-caching?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" version="2.0">
	<xsl:output method="xhtml" encoding="UTF-8"/>	
	<xsl:param name="stub"/>

	<xsl:template name="pages">
		<div id="bd">
			<xsl:copy-of select="saxon:parse(concat('&lt;div&gt;', string(//page[@stub = $stub]/text), '&lt;/div&gt;'))"/>
		</div>
	</xsl:template>
</xsl:stylesheet>
