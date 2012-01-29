<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:numishare="http://code.google.com/p/numishare/">
	<xsl:template name="search_options">
		<option value="fulltext" class="search_option" id="keyword_option">Keyword</option>
		<option value="identifier_display" class="search_option" id="identifier_option">Accession Number</option>
		<option value="century_num" class="search_option" id="century_option">Century</option>
		<option value="color_text" class="search_option" id="color_option">Color</option>
		<option value="collection_facet" class="search_option" id="collection_option">Collection</option>
		<!--<option value="decoration_facet" class="search_option" id="decoration_option">Decoration</option>-->
		<option value="degree_facet" class="search_option" id="degree_option">Degree</option>
		<option value="deity_text" class="search_option" id="deity_option">Deity</option>
		<option value="denomination_facet" class="search_option" id="denomination_option">Denomination</option>
		<option value="department_facet" class="search_option" id="department_option">Department</option>
		<option value="dimensions_display" class="search_option" id="dimensions_option">Dimensions</option>
		<option value="dynasty_facet" class="search_option" id="dynasty_option">Dynasty</option>
		<option value="findspot_text" class="search_option" id="findspot_option">Findspot</option>
		<!--<option value="era_facet" class="search_option" id="era_option">Era</option>-->
		<option value="objectType_facet" class="search_option" id="dynasty_option">Format</option>
		<!--<option value="geogname_text" class="search_option" id="geogname_option">Geographical Location</option>-->
		<option value="institution_facet" class="search_option" id="institution_option">Institution</option>
		<option value="legend_text" class="search_option" id="legend_option">Legend</option>
		<option value="locality_text" class="search_option" id="locality_option">Locality</option>
		<option value="manufacture_facet" class="search_option" id="manufacture_option">Manufacture</option>
		<option value="material_facet" class="search_option" id="material_option">Material</option>
		<option value="mint_text" class="search_option" id="mint_option">Mint</option>
		<option value="persname_text" class="search_option" id="persname_option">Name</option>
		<!--<option value="script_facet" class="search_option" id="script_option">Script</option>-->
		<!--<option value="style_facet" class="search_option" id="script_option">Style</option>-->
		<option value="reference_display" class="search_option" id="reference_option">Reference</option>
		<option value="region_text" class="search_option" id="region_option">Region</option>
		<option value="subject_facet" class="search_option" id="subject_option">Subject</option>
		<option value="type_text" class="search_option" id="type_option">Type</option>
		<!--<option value="technique_facet" class="search_option" id="script_option">Technique</option>-->
		<option value="weight_num" class="search_option" id="weight_option">Weight</option>
		<option value="year_num" class="search_option" id="year_option">Year</option>
	</xsl:template>
	
	<xsl:function name="numishare:normalize_century">
		<xsl:param name="name"/>
		<xsl:value-of select="concat($name, '00s')"/>
	</xsl:function>

	<xsl:function name="numishare:normalize_fields">
		<xsl:param name="field"/>
		<xsl:choose>
			<xsl:when test="$field = 'identifier_display'">Identifier</xsl:when>
			<xsl:when test="$field = 'identifier_text'">Identifier</xsl:when>
			<xsl:when test="$field = 'artist_facet'">Artist</xsl:when>
			<xsl:when test="$field = 'authority_facet'">Authority</xsl:when>
			<xsl:when test="$field = 'category_facet'">Category</xsl:when>
			<xsl:when test="$field = 'century_num'">Century</xsl:when>
			<xsl:when test="$field = 'city_facet'">City</xsl:when>
			<xsl:when test="$field = 'collection_facet'">Collection</xsl:when>
			<xsl:when test="$field = 'color_display'">Color</xsl:when>
			<xsl:when test="$field = 'color_text'">Color</xsl:when>
			<xsl:when test="$field = 'decade_num'">Decade</xsl:when>
			<xsl:when test="$field = 'timestamp'">Date Record Modified</xsl:when>
			<xsl:when test="$field = 'deity_facet' or $field = 'deity_text'">Deity</xsl:when>
			<xsl:when test="$field = 'denomination_facet'">Denomination</xsl:when>
			<xsl:when test="$field = 'department_facet'">Department</xsl:when>
			<xsl:when test="$field = 'dimensions_display'">Dimensions</xsl:when>
			<xsl:when test="$field = 'dob_num'">Date on Object</xsl:when>
			<xsl:when test="$field = 'decoration_facet'">Decoration</xsl:when>
			<xsl:when test="$field = 'degree_facet'">Degree</xsl:when>
			<xsl:when test="$field = 'engraver_facet'">Engraver</xsl:when>
			<xsl:when test="$field = 'era_facet'">Era</xsl:when>
			<xsl:when test="$field = 'dynasty_facet'">Dynasty</xsl:when>
			<xsl:when test="$field = 'findspot_facet'">Findspot</xsl:when>
			<xsl:when test="$field = 'findspot_text'">Findspot</xsl:when>
			<xsl:when test="$field = 'geonames_uri'">Geonames URI</xsl:when>
			<xsl:when test="$field = 'geogname_text'">Geographical Location</xsl:when>
			<xsl:when test="$field = 'grade_facet'">Grade</xsl:when>
			<xsl:when test="$field = 'objectType_facet'">Object Type</xsl:when>
			<xsl:when test="$field = 'fulltext'">Keyword</xsl:when>
			<xsl:when test="$field = 'imagesavailable'">Has Images</xsl:when>
			<xsl:when test="$field = 'imagesponsor_display'">Image Sponsor</xsl:when>
			<xsl:when test="$field = 'institution_facet'">Institution</xsl:when>
			<xsl:when test="$field = 'issuer_facet'">Issuer</xsl:when>
			<xsl:when test="$field = 'legend_text'">Legend</xsl:when>
			<xsl:when test="$field = 'locality_facet'">Locality</xsl:when>
			<xsl:when test="$field = 'locality_text'">Locality</xsl:when>
			<xsl:when test="$field = 'material_facet'">Material</xsl:when>
			<xsl:when test="$field = 'manufacture_facet'">Manufacture</xsl:when>
			<xsl:when test="$field = 'maker_facet'">Maker</xsl:when>
			<xsl:when test="$field = 'mint_facet'">Mint</xsl:when>
			<xsl:when test="$field = 'mint_text'">Mint</xsl:when>
			<xsl:when test="$field = 'nomisma_uri'">Nomisma URI</xsl:when>
			<xsl:when test="$field = 'obv_leg_display'">Obv. Legend</xsl:when>
			<xsl:when test="$field = 'owner_facet'">Owner</xsl:when>
			<xsl:when test="$field = 'persname_facet'">Person</xsl:when>
			<xsl:when test="$field = 'pleiades_uri'">Pleiades URI</xsl:when>
			<xsl:when test="$field = 'prevcoll_display'">Previous Collection</xsl:when>
			<xsl:when test="$field = 'portrait_facet'">Portrait</xsl:when>
			<xsl:when test="$field = 'reference_display'">Reference</xsl:when>
			<xsl:when test="$field = 'region_facet'">Region</xsl:when>
			<xsl:when test="$field = 'region_text'">Region</xsl:when>
			<xsl:when test="$field = 'repository_facet'">Repository</xsl:when>
			<xsl:when test="$field = 'rev_leg_display'">Rev. Legend</xsl:when>
			<xsl:when test="$field = 'script_facet'">Script</xsl:when>
			<xsl:when test="$field = 'series_facet'">Series</xsl:when>
			<xsl:when test="$field = 'sernum_display'">Serial Number</xsl:when>
			<xsl:when test="$field = 'subjectPerson_facet'">Subject-Person</xsl:when>
			<xsl:when test="$field = 'subjectIssuer_facet'">Subject-Issuer</xsl:when>
			<xsl:when test="$field = 'subjectEvent_facet'">Subject-Event</xsl:when>
			<xsl:when test="$field = 'subjectPlace_facet'">Subject-Place</xsl:when>
			<xsl:when test="$field = 'state_facet'">State</xsl:when>
			<xsl:when test="$field = 'style_facet'">Style</xsl:when>
			<xsl:when test="$field = 'technique_facet'">Technique</xsl:when>
			<xsl:when test="$field = 'title_display'">Title</xsl:when>
			<xsl:when test="$field = 'type_text'">Type</xsl:when>
			<xsl:when test="$field = 'weight_num'">Weight</xsl:when>
			<xsl:when test="$field = 'year_num'">Year</xsl:when>
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
