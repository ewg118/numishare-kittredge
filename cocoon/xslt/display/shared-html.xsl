<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************** SHARED TEMPLATES AND FUNCTIONS *****************************************
	Author: Ethan Gruber
	Function: this XSLT stylesheet is included into display.xsl.  It contains shared templates and functions that may be used in object-
	specific stylesheets
	Modification date: Febrary 2012
-->
<xsl:stylesheet xmlns:nuds="http://nomisma.org/nuds" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:numishare="http://code.google.com/p/numishare/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xlink="http://www.w3.org/1999/xlink"
	exclude-result-prefixes="#all" version="2.0">

	<!--***************************************** ELEMENT TEMPLATES **************************************** -->
	<xsl:template match="nuds:refDesc">
		<h2>References</h2>
		<ul>
			<xsl:apply-templates mode="descMeta"/>
		</ul>
	</xsl:template>
	
	<xsl:template match="nuds:physDesc[child::*]">
		<h2>Physical Attributes</h2>
		<ul>
			<xsl:apply-templates mode="descMeta"/>
		</ul>
	</xsl:template>
	
	<xsl:template match="nuds:typeDesc">		
		<xsl:param name="typeDesc_resource"/>
		<h2>Typological Attributes</h2>
		<xsl:if test="string($typeDesc_resource)">
			<p>Source: <a href="{$typeDesc_resource}"><xsl:value-of select="$typeDesc_resource"/></a></p>
		</xsl:if>
		<ul>
			<xsl:apply-templates mode="descMeta"/>
		</ul>
	</xsl:template>
	
	<xsl:template match="*" mode="descMeta">
		<xsl:variable name="facets">
			<xsl:text>artist,authority,category,collection,decoration,deity,degree,denomination,department,dynasty,engraver,era,findspot,grade,institution,issuer,portrait,manufacture,maker,material,mint,objectType,owner,region,repository,script,state,subject</xsl:text>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="not(child::*)">
				<xsl:variable name="href" select="@xlink:href"/>
				
				<!-- the facet field is the @xlink:role if it exists, otherwise it is the name of the nuds element -->
				<xsl:variable name="field">
					<xsl:choose>
						<xsl:when test="string(@xlink:role)">
							<xsl:value-of select="@xlink:role"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="local-name()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<li>
					<b>
						<xsl:choose>
							<xsl:when test="string(@xlink:role)">
								<xsl:value-of select="concat(upper-case(substring(@xlink:role, 1, 1)), substring(@xlink:role, 2))"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="numishare:regularize_node(local-name())"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text>: </xsl:text>
					</b>
					
					<!-- create link from facet, if applicable -->
					
					<!-- pull language from nomisma, if available -->
					<xsl:variable name="value">
						<xsl:choose>
							<xsl:when test="string($lang) and contains($href, 'nomisma.org')">
								<xsl:variable name="rdf_url" select="concat('http://www.w3.org/2012/pyRdfa/extract?format=xml&amp;uri=', encode-for-uri($href))"/>
								<xsl:choose>
									<xsl:when test="string(document($rdf_url)//skos:prefLabel[@xml:lang=$lang])">
										<xsl:value-of select="document($rdf_url)//skos:prefLabel[@xml:lang=$lang]"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="document($rdf_url)//skos:prefLabel[@xml:lang='en']"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:choose>
						<xsl:when test="contains($facets, $field)">
							<a href="{$display_path}results?q={$field}_facet:&#x022;{normalize-space(.)}&#x022;">
								<xsl:value-of select="$value"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$value"/>
						</xsl:otherwise>
					</xsl:choose>
					
					<!-- display title -->
					<xsl:if test="string(@title)">
						<xsl:text> (</xsl:text>
						<xsl:value-of select="@title"/>
						<xsl:text>)</xsl:text>
					</xsl:if>
					
					<!-- display certainty -->
					<xsl:if test="string(@certainty)">
						<xsl:text> (</xsl:text>
						<xsl:value-of select="@certainty"/>
						<xsl:text>)</xsl:text>
					</xsl:if>
					
					<!-- create links to resources -->
					<xsl:if test="string($href)">
						
						
						<a href="{$href}" target="_blank" title="{if (contains($href, 'geonames')) then 'geonames' else if (contains($href, 'nomisma')) then 'nomisma' else ''}">
							<img src="{$display_path}images/external.png" alt="external link" class="external_link"/>
							
						</a>
						<!-- parse nomisma RDFa, create links for pleiades and wikipedia -->
						<xsl:if test="contains($href, 'nomisma.org')">
							<xsl:variable name="rdf_url" select="concat('http://www.w3.org/2012/pyRdfa/extract?format=xml&amp;uri=', encode-for-uri($href))"/>
							<xsl:for-each select="document($rdf_url)//skos:related">
								<xsl:variable name="source">
									<xsl:choose>
										<xsl:when test="contains(@rdf:resource, 'pleiades')">
											<xsl:text>pleiades</xsl:text>
										</xsl:when>
										<xsl:when test="contains(@rdf:resource, 'wikipedia')">
											<xsl:text>wikipedia</xsl:text>
										</xsl:when>
									</xsl:choose>
								</xsl:variable>
								
								<a href="{@rdf:resource}" target="_blank" title="{$source}">
									<img src="{$display_path}images/{$source}.png" alt="{$source}" class="external_link"/>									
								</a>
							</xsl:for-each>
						</xsl:if>
					</xsl:if>
				</li>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$recordType='conceptual'">
						<xsl:if test="child::*">
							<li>
								<xsl:choose>
									<xsl:when test="parent::physDesc">
										<h3>
											<xsl:value-of select="numishare:regularize_node(local-name())"/>
										</h3>
									</xsl:when>
									<xsl:otherwise>
										<h4>
											<xsl:value-of select="numishare:regularize_node(local-name())"/>
										</h4>
									</xsl:otherwise>
								</xsl:choose>
								<ul>
									<xsl:apply-templates select="*" mode="descMeta"/>
								</ul>
							</li>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="child::*[not(local-name()='type' or local-name()='legend')]">
							<li>
								<xsl:choose>
									<xsl:when test="parent::physDesc">
										<h3>
											<xsl:value-of select="numishare:regularize_node(local-name())"/>
										</h3>
									</xsl:when>
									<xsl:otherwise>
										<h4>
											<xsl:value-of select="numishare:regularize_node(local-name())"/>
										</h4>
									</xsl:otherwise>
								</xsl:choose>
								<ul>
									<xsl:apply-templates select="*[not(local-name()='type' or local-name()='legend')]" mode="descMeta"/>
								</ul>
							</li>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<!--***************************************** CREATE LINK FROM CATEGORY **************************************** -->
	<xsl:template name="assemble_category_query">
		<xsl:param name="level"/>
		<xsl:param name="tokenized-category"/>

		<xsl:for-each select="$tokenized-category[position() &lt;= $level]">
			<xsl:value-of select="concat('+&#x022;L', position(), '|', ., '&#x022;')"/>
		</xsl:for-each>

		<xsl:if test="position() &lt;= $level">
			<xsl:variable name="category-query">
				<xsl:call-template name="assemble_category_query">
					<xsl:with-param name="level" as="xs:integer" select="$level + 1"/>
					<xsl:with-param name="tokenized-category" select="$tokenized-category"/>
				</xsl:call-template>
			</xsl:variable>
		</xsl:if>
	</xsl:template>
	<!--***************************************** EXTERNAL LINKS **************************************** -->

	<xsl:template name="external_links">
		<div class="metadata_section">
			<h2>External Links</h2>
			<ul>
				<xsl:for-each select="document(concat($solr-url, 'select?q=id:&#x022;', $id, '&#x022;))//arr[@name='nomisma_uri']/str">
					<li>
						<b>Nomisma: </b>
						<a href="{.}" target="_blank">
							<xsl:value-of select="."/>
						</a>
					</li>
				</xsl:for-each>
				<xsl:for-each select="document(concat($solr-url, 'select?q=id:&#x022;', $id, '&#x022;))//arr[@name='pleiades_uri']/str">
					<li>
						<b>Pleiades: </b>
						<a href="{.}" target="_blank">
							<xsl:value-of select="."/>
						</a>
					</li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>
	<!--***************************************** OPTIONS BAR **************************************** -->
	<xsl:template name="icons">

		<div class="submenu">
			<div class="icon">
				<a href="{$id}.xml">
					<img src="{$display_path}images/xml.png" title="XML" alt="XML"/>
				</a>
			</div>
			<div class="icon">
				<a href="{$id}.rdf">
					<img src="{$display_path}images/rdf.gif" title="RDF" alt="RDF"/>
				</a>
			</div>
			<div class="icon">
				<a href="{$id}.atom">
					<img src="{$display_path}images/atom.png" title="Atom" alt="Atom"/>
				</a>
			</div>
			<div class="icon">AddThis could go here...</div>
		</div>
	</xsl:template>

	<!--***************************************** FUNCTIONS **************************************** -->
	<xsl:function name="numishare:get_flickr_uri">
		<xsl:param name="photo_id"/>
		<xsl:value-of
			select="document(concat('http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&amp;api_key=', $flickr-api-key, '&amp;photo_id=', $photo_id, '&amp;format=rest'))/rsp/photo/urls/url[@type='photopage']"
		/>
	</xsl:function>

	<xsl:function name="numishare:regularize_node">
		<xsl:param name="name"/>
		<xsl:choose>
			<xsl:when test="$name='acknowledgment'">Acknowledgment</xsl:when>
			<xsl:when test="$name='acqinfo'">Aquisitition Information</xsl:when>
			<xsl:when test="$name='acquiredFrom'">Acquired From</xsl:when>
			<xsl:when test="$name='appraisal'">Appraisal</xsl:when>
			<xsl:when test="$name='appraiser'">Appraiser</xsl:when>
			<xsl:when test="$name='authority'">Authority</xsl:when>
			<xsl:when test="$name='axis'">Axis</xsl:when>
			<xsl:when test="$name='collection'">Collection</xsl:when>
			<xsl:when test="$name='completeness'">Completeness</xsl:when>
			<xsl:when test="$name='condition'">Condition</xsl:when>
			<xsl:when test="$name='conservationState'">Conservation State</xsl:when>
			<xsl:when test="$name='coordinates'">Coordinates</xsl:when>
			<xsl:when test="$name='countermark'">Countermark</xsl:when>
			<xsl:when test="$name='custodhist'">Custodial History</xsl:when>
			<xsl:when test="$name='date'">Date</xsl:when>
			<xsl:when test="$name='dateOnObject'">Date on Object</xsl:when>
			<xsl:when test="$name='denomination'">Denomination</xsl:when>
			<xsl:when test="$name='department'">Department</xsl:when>
			<xsl:when test="$name='deposit'">Deposit</xsl:when>
			<xsl:when test="$name='description'">Description</xsl:when>
			<xsl:when test="$name='diameter'">Diameter</xsl:when>
			<xsl:when test="$name='discovery'">Discovery</xsl:when>
			<xsl:when test="$name='disposition'">Disposition</xsl:when>
			<xsl:when test="$name='edge'">Edge</xsl:when>
			<xsl:when test="$name='era'">Era</xsl:when>
			<xsl:when test="$name='finder'">Finder</xsl:when>
			<xsl:when test="$name='findspot'">Findspot</xsl:when>			
			<xsl:when test="$name='geographic'">Geographic</xsl:when>
			<xsl:when test="$name='grade'">Grade</xsl:when>
			<xsl:when test="$name='height'">Height</xsl:when>
			<xsl:when test="$name='identifier'">Identifier</xsl:when>
			<xsl:when test="$name='landowner'">Landowner</xsl:when>
			<xsl:when test="$name='legend'">Legend</xsl:when>
			<xsl:when test="$name='material'">Material</xsl:when>
			<xsl:when test="$name='measurementsSet'">Measurements</xsl:when>
			<xsl:when test="$name='note'">Note</xsl:when>
			<xsl:when test="$name='objectType'">Object Type</xsl:when>
			<xsl:when test="$name='obverse'">Obverse</xsl:when>
			<xsl:when test="$name='owner'">Owner</xsl:when>
			<xsl:when test="$name='private'">Private</xsl:when>
			<xsl:when test="$name='public'">Public</xsl:when>
			<xsl:when test="$name='reference'">Reference</xsl:when>
			<xsl:when test="$name='repository'">Repository</xsl:when>
			<xsl:when test="$name='reverse'">Reverse</xsl:when>
			<xsl:when test="$name='saleCatalog'">Sale Catalog</xsl:when>
			<xsl:when test="$name='saleItem'">Sale Item</xsl:when>
			<xsl:when test="$name='salePrice'">Sale Price</xsl:when>
			<xsl:when test="$name='shape'">Shape</xsl:when>
			<xsl:when test="$name='symbol'">Symbol</xsl:when>
			<xsl:when test="$name='testmark'">Test Mark</xsl:when>
			<xsl:when test="$name='title'">Title</xsl:when>
			<xsl:when test="$name='type'">Type</xsl:when>
			<xsl:when test="$name='thickness'">Thickness</xsl:when>
			<xsl:when test="$name='wear'">Wear</xsl:when>
			<xsl:when test="$name='weight'">Weight</xsl:when>
			<xsl:when test="$name='width'">Width</xsl:when>
			<xsl:otherwise>Unlabeled Category</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
</xsl:stylesheet>
