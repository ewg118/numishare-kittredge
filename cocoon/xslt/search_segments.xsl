<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:numishare="http://code.google.com/p/numishare/"
	exclude-result-prefixes="#all">
	<xsl:template name="search_options">
		<xsl:variable name="fields">
			<xsl:text>fulltext,artist_text,authority_text,color_text,deity_text,denomination_facet,department_facet,diameter_num,dynasty_facet,findspot_text,objectType_facet,identifier_display,issuer_text,legend_text,obv_leg_text,rev_leg_text,maker_text,manufacture_facet,material_facet,mint_text,portrait_text,reference_facet,region_text,type_text,obv_type_text,rev_type_text,weight_num,year_num</xsl:text>
		</xsl:variable>
		
		<xsl:for-each select="tokenize($fields, ',')">
			<option value="{.}" class="search_option"><xsl:value-of select="numishare:normalize_fields(.)"/></option>
		</xsl:for-each>
	</xsl:template>

	<xsl:function name="numishare:normalize_century">
		<xsl:param name="name"/>
		<xsl:value-of select="concat($name, '00s')"/>
	</xsl:function>

	<xsl:function name="numishare:normalize_fields">
		<xsl:param name="field"/>
		<xsl:choose>
			<xsl:when test="contains($field, '_uri')">
				<xsl:variable name="name" select="substring-before($field, '_uri')"/>
				<xsl:value-of select="concat(upper-case(substring($name, 1, 1)), substring($name, 2))"/>
				<xsl:text> URI</xsl:text>
			</xsl:when>
			<xsl:when test="contains($field, '_facet')">
				<xsl:variable name="name" select="substring-before($field, '_facet')"/>
				<xsl:value-of select="concat(upper-case(substring($name, 1, 1)), substring($name, 2))"/>
			</xsl:when>
			<xsl:when test="contains($field, '_num')">
				<xsl:variable name="name" select="substring-before($field, '_num')"/>
				<xsl:value-of select="concat(upper-case(substring($name, 1, 1)), substring($name, 2))"/>
			</xsl:when>
			<xsl:when test="$field = 'timestamp'">Date Record Modified</xsl:when>	
			<xsl:when test="$field = 'fulltext'">Keyword</xsl:when>
			<xsl:when test="$field = 'imagesavailable'">Has Images</xsl:when>
			<xsl:when test="$field = 'imagesponsor_display'">Image Sponsor</xsl:when>
			<xsl:when test="$field = 'obv_leg_display'">Obv. Legend</xsl:when>	
			<xsl:when test="$field = 'obv_leg_text'">Obv. Legend</xsl:when>		
			<xsl:when test="$field = 'obv_type_text'">Obv. Type</xsl:when>				
			<xsl:when test="$field = 'prevcoll_display'">Previous Collection</xsl:when>			
			<xsl:when test="$field = 'rev_leg_display'">Rev. Legend</xsl:when>
			<xsl:when test="$field = 'rev_leg_text'">Rev. Legend</xsl:when>
			<xsl:when test="$field = 'rev_type_text'">Rev. Type</xsl:when>			
			<xsl:when test="contains($field, '_text')">
				<xsl:variable name="name" select="substring-before($field, '_text')"/>
				<xsl:value-of select="concat(upper-case(substring($name, 1, 1)), substring($name, 2))"/>
			</xsl:when>
			<xsl:when test="contains($field, '_display')">
				<xsl:variable name="name" select="substring-before($field, '_display')"/>
				<xsl:value-of select="concat(upper-case(substring($name, 1, 1)), substring($name, 2))"/>
			</xsl:when>
			<xsl:otherwise>Undefined Category</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<xsl:template name="recompile_category">
		<xsl:param name="level" as="xs:integer"/>
		<xsl:param name="category_fragment"/>
		<xsl:param name="tokenized_fragment"/>
		<xsl:value-of select="substring-after(replace($tokenized_fragment[contains(., concat('L', $level, '|'))], '&#x022;', ''), '|')"/>
		<!--<xsl:value-of select="substring-after(replace(., '&#x022;', ''), '|')"/>-->
		<xsl:if test="contains($category_fragment, concat('L', $level + 1, '|'))">
			<xsl:text>--</xsl:text>
			<xsl:call-template name="recompile_category">
				<xsl:with-param name="tokenized_fragment" select="$tokenized_fragment"/>
				<xsl:with-param name="category_fragment" select="$category_fragment"/>
				<xsl:with-param name="level" select="$level + 1"/>
			</xsl:call-template>
		</xsl:if>

	</xsl:template>
</xsl:stylesheet>
