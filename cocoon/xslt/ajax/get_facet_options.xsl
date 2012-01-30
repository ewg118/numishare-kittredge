<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:numishare="http://code.google.com/p/numishare/" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes=" numishare xs" version="2.0">
	<xsl:include href="../search_segments.xsl"/>
	<xsl:param name="q"/>
	<xsl:param name="start"/>
	<xsl:param name="category"/>
	<xsl:param name="sort"/>
	<xsl:param name="offset" as="xs:integer"/>
	<xsl:param name="limit" as="xs:integer"/>
	<xsl:param name="solr-url"/>
	<xsl:param name="section"/>
	<xsl:param name="tokenized_q" select="tokenize($q, ' AND ')"/>

	<xsl:template match="/">
		<xsl:apply-templates select="descendant::lst[@name='facet_fields']/lst[@name=$category]"/>
	</xsl:template>

	<xsl:template match="lst[@name=$category]">
		<xsl:if test="$category != 'category_facet'">
			<xsl:for-each select="int">
				<xsl:variable name="matching_term">
					<xsl:value-of select="concat($category, ':&#x022;', @name, '&#x022;')"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="contains($q, $matching_term)">
						<option value="{@name}" selected="selected">
							<xsl:choose>
								<xsl:when test="$category = 'century_num'">
									<xsl:value-of select="numishare:normalize_century(@name)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@name"/>
								</xsl:otherwise>
							</xsl:choose>
						</option>
					</xsl:when>
					<xsl:otherwise>
						<option value="{@name}">
							<xsl:choose>
								<xsl:when test="$category = 'century_num'">
									<xsl:value-of select="numishare:normalize_century(@name)"/>									
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@name"/>									
								</xsl:otherwise>
							</xsl:choose>
						</option>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
