<?xml version="1.0" encoding="UTF-8"?>
<?cocoon-disable-caching?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" indent="yes" encoding="UTF-8" media-type="text/html"/>
	<xsl:include href="search_segments.xsl"/>

	<xsl:template name="compare">
		<div id="bd">
			<div id="yui-main">
				<div class="yui-g">
					<h1>Compare</h1>
					<p>This feature allows you to compare the results of conducting two separate searches of the database. The results of the searches are displayed on the results page in
						parallel columns and may be sorted separately. <a href="#instructions" id="show_instructions">Show search instructions.</a></p>
					<div style="display:none">
						<div id="instructions">
							<h1>Search Instructions</h1>
							<h2>Accession Number</h2>
							<p>If you know the ANS’ unique accession number for the object select ‘Accession number’ on the drop-down menu above and enter the accession number in the
								following format: http://code.google.com/p/numishare/.nnn.nnn.</p>
							
							<h2>Free Text Searching</h2>
							<p>To conduct a free text search select ‘Keyword’ on the drop-down menu above and enter the text for which you wish to search.</p>
							
							<h2>Other Searches</h2>
							<p>The drop down menu above also allows basic searches on other categories of information (list from drop down here). Searches across multiple categories may be
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
					<div class="yui-u first">
						
						<div class="compare-form">
							<form id="dataset1" method="GET">
								<div id="searchItemTemplate_1" class="searchItemTemplate">
									<select id="search_option_1" class="category_list">
										<xsl:call-template name="search_options"/>
									</select>
									<div style="display:inline;" class="option_container">
										<input type="text" id="search_text" class="search_text" style="display: inline;"/>
									</div>
									<a class="gateTypeBtn" href="#">add »</a>
									<a id="removeBtn_1" class="removeBtn" href="#">« remove</a>
								</div>
							</form>
						</div>
						<table id="search1"/>
					</div>
					<div class="yui-u">
						<div class="compare-form">
							<form id="dataset2" method="GET">
								<div id="searchItemTemplate_1" class="searchItemTemplate">
									<select id="search_option_1" class="category_list">
										<xsl:call-template name="search_options"/>
									</select>
									<div style="display:inline;" class="option_container">
										<input type="text" id="search_text" class="search_text" style="display: inline;"/>
									</div>
									<a class="gateTypeBtn" href="#">add »</a>
									<a id="removeBtn_1" class="removeBtn" href="#">«</a>
								</div>
							</form>
							<div style="display:table;width:100%;">
								<xsl:text>Image: </xsl:text>
								<select id="image" style="width: 200px;">												
									<option value="obverse">Obverse</option>
									<option value="reverse">Reverse</option>
								</select>
								<input class="compare_button" type="submit" value="Compare Data"/>
							</div>
							<div id="searchItemTemplate" class="searchItemTemplate">
								<select id="search_option_1" class="category_list">
									<xsl:call-template name="search_options"/>
								</select>
								<div style="display:inline;" class="option_container">
									<input type="text" id="search_text" class="search_text" style="display: inline;"/>
								</div>
								<a class="gateTypeBtn" href="#">add »</a>
								<a id="removeBtn_1" class="removeBtn" href="#">«</a>
							</div>
						</div>
						<table id="search2"/>
					</div>
				</div>
			</div>
			
		</div>
	</xsl:template>
</xsl:stylesheet>
