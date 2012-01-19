<?xml version="1.0" encoding="UTF-8"?>
<?cocoon-disable-caching?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" encoding="UTF-8"/>
	<xsl:include href="search_segments.xsl"/>

	<xsl:template name="search">
		<div id="bd">
			<h1>Search</h1>
			<p>This page allows you to search the entire database for specific terms or keywords. It also allows you to finds specific objects through their unique ANS 'accession
				number. <a href="#instructions" id="show_instructions">Show search instructions.</a></p>
			<div style="display:none">
				<div id="instructions">
					<h1>Search Instructions</h1>
					<h2>Accession Number</h2>
					<p>If you know the ANS’ unique accession number for the object select ‘Accession number’ on the drop-down menu above and enter the accession number in the
						following format: http://code.google.com/p/numishare/.nnn.nnn.</p>
					
					<h2>Free Text Searching</h2>
					<p>To conduct a free text search select ‘Keyword’ on the drop-down menu above and enter the text for which you wish to search.</p>
					
					<h2>Other Searches</h2>
					<p>The drop down menu also allows basic searches on other categories of information. Searches across multiple categories may be
						carried out by clicking ‘add’ to the right of the search field. However, if you wish to search for multiple terms or under multiple categories of
						information, we strongly recommend using the faceted search facility for the whole collection or for individual Departments. To conduct a faceted search
						across the whole collection, click ‘Browse’ on the tool bar above. To conduct a faceted search by Department click ‘Collections Home’ on the tool bar
						above</p>
					<p>The search allows wildcard searches with the * and ? characters and exact string matches by surrounding phrases by double quotes (like Google).</p>
					<p>Example: A search for <i>1944.*</i> will yield all coins accessioned in 1944. <a
						href="http://lucene.apache.org/java/2_9_1/queryparsersyntax.html#Term%20Modifiers" target="_blank">See the Lucene query syntax</a> documenation for more
						information.</p>
				</div>
			</div>
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
				<input type="text" id="search_text" class="search_text" style="display: inline;"/>
			</div>
			<a class="gateTypeBtn" href="#">add »</a>
			<a id="removeBtn_1" class="removeBtn" href="#">« remove</a>
		</div>
	</xsl:template>
</xsl:stylesheet>
