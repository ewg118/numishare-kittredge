<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:output method="xml" omit-xml-declaration="yes"/>
	<xsl:param name="q"/>

	<xsl:template match="/">
		<div class="departments">
			<h2>Select Departments</h2>
			<xsl:for-each select="//lst[@name='facet_fields']/lst[@name='department_facet']/int">
				<label><xsl:value-of select="@name"/></label>
				<input type="checkbox" name="{@name}" value="{@name}"/>
			</xsl:for-each>
		</div>
	</xsl:template>
</xsl:stylesheet>
