<?xml version="1.0" encoding="UTF-8"?>
<?cocoon-disable-caching?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" version="2.0"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mets="http://www.loc.gov/METS/" xmlns:exsl="http://exslt.org/common" xmlns:numishare="http://code.google.com/p/numishare/"
	xmlns:skos="http://www.w3.org/2008/05/skos#" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="xs rdf xlink mets exsl numishare xsl skos xlink cinclude">

	<xsl:variable name="id" select="normalize-space(/content/nuds/nudsHeader/nudsid)"/>
	<xsl:variable name="recordType" select="/content/nuds/@recordType"/>
	<xsl:variable name="typeDesc_resource">
		<xsl:if test="string(/content/nuds/descMeta/typeDesc/@rdf:resource)">
			<xsl:value-of select="/content/nuds/descMeta/typeDesc/@rdf:resource"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="typeDesc">
		<xsl:choose>
			<xsl:when test="string($typeDesc_resource)">
				<xsl:copy-of select="document(concat($typeDesc_resource, '.xml'))/nuds/descMeta/typeDesc"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="/content/nuds/descMeta/typeDesc"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template name="nuds">
		<xsl:apply-templates select="/content/nuds"/>
	</xsl:template>

	<xsl:template match="nuds">
		<xsl:if test="$mode = 'compare'">
			<div class="compare_options">
				<a href="compare_results?q={$q}&amp;start={$start}&amp;image={$image}&amp;side={$side}&amp;mode=compare" class="back_results">« Search results</a>
				<xsl:text> | </xsl:text>
				<a href="display/{$id}">Full record »</a>
			</div>
		</xsl:if>

		<!-- below is a series of conditionals for forming the image boxes and displaying obverse and reverse images, iconography, and legends if they are available within the EAD document -->
		<xsl:choose>
			<xsl:when test="not($mode = 'compare')">
				<!-- determine whether the document has published findspots or associated object findspots -->
				<xsl:variable name="findspot_field">
					<xsl:if test="$has_findspot_geo = 'true'">
						<xsl:value-of select="if ($recordType = 'conceptual') then 'ao_findspot_geo' else 'findspot_geo'"/>
					</xsl:if>
				</xsl:variable>

				<script type="text/javascript" langage="javascript">
                                                        $(function () {
                                                                $("#tabs").tabs({
                                                                        show: function (event, ui) {
                                                                                if (ui.panel.id == "map" &amp;&amp; $('#basicMap').html().length == 0) {
                                                                                        $('#basicMap').html('');
                                                                                        initialize_map('<xsl:value-of select="$has_mint_geo"/>', 'id:"<xsl:value-of select="$id"/>"', '<xsl:value-of select="$display_path"/>', '<xsl:value-of select="$findspot_field"/>');
                                                                                }
                                                                        }
                                                                });
                                                        });
                                                </script>
				<xsl:if test="$has_mint_geo = 'true' or $has_findspot_geo = 'true'">
					<script src="http://www.openlayers.org/api/OpenLayers.js" type="text/javascript">
                                                        //</script>
					<script src="http://maps.google.com/maps/api/js?v=3.2&amp;sensor=false">//</script>
					<script type="text/javascript" src="{$display_path}javascript/display_map_functions.js"/>
				</xsl:if>

				<xsl:call-template name="icons"/>
				<xsl:choose>
					<xsl:when test="$recordType='conceptual'">
						<h1 id="object_title">
							<xsl:value-of select="normalize-space(descMeta/title)"/>
						</h1>
						<xsl:call-template name="page_content"/>
						<xsl:if test="digRep/associatedObject">
							<div class="objects">
								<h2>Examples of this type</h2>
								<xsl:apply-templates select="digRep/associatedObject"/>
							</div>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$recordType='physical'">
						<xsl:choose>
							<xsl:when test="$orientation = 'vertical'">
								<div class="yui-g">
									<div class="yui-u first">
										<xsl:choose>
											<xsl:when test="$image_location = 'left'">
												<xsl:call-template name="obverse_image"/>
												<xsl:call-template name="reverse_image"/>
											</xsl:when>
											<xsl:when test="$image_location = 'right'">
												<h1 id="object_title">
													<xsl:value-of select="normalize-space(descMeta/title)"/>
												</h1>
												<xsl:call-template name="page_content"/>
											</xsl:when>
										</xsl:choose>
									</div>
									<div class="yui-u">
										<xsl:choose>
											<xsl:when test="$image_location = 'left'">
												<h1 id="object_title">
													<xsl:value-of select="normalize-space(descMeta/title)"/>
												</h1>
												<xsl:call-template name="page_content"/>
											</xsl:when>
											<xsl:when test="$image_location = 'right'">
												<xsl:call-template name="obverse_image"/>
												<xsl:call-template name="reverse_image"/>
											</xsl:when>
										</xsl:choose>
									</div>
								</div>
							</xsl:when>
							<xsl:when test="$orientation = 'horizontal'">
								<h1 id="object_title">
									<xsl:value-of select="normalize-space(descMeta/title)"/>
								</h1>
								<xsl:choose>
									<xsl:when test="$image_location = 'top'">
										<div class="yui-g">
											<div class="yui-u first">
												<xsl:call-template name="obverse_image"/>
											</div>
											<div class="yui-u">
												<xsl:call-template name="reverse_image"/>
											</div>
										</div>
										<div>
											<xsl:call-template name="page_content"/>
										</div>
									</xsl:when>
									<xsl:when test="$image_location = 'bottom'">
										<div>
											<xsl:call-template name="page_content"/>
										</div>
										<div class="yui-g">
											<div class="yui-u first">
												<xsl:call-template name="obverse_image"/>
											</div>
											<div class="yui-u">
												<xsl:call-template name="reverse_image"/>
											</div>
										</div>
									</xsl:when>
								</xsl:choose>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
				<xsl:call-template name="icons"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="obverse_image"/>
				<xsl:call-template name="reverse_image"/>
				<xsl:call-template name="page_content"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="page_content">
		<!--********************************* MENU ******************************************* -->
		<xsl:choose>
			<xsl:when test="$mode = 'compare'">
				<!-- process $typeDesc differently -->
				<div>
					<xsl:if test="descMeta/physDesc">
						<div class="metadata_section">
							<xsl:apply-templates select="descMeta/physDesc"/>
						</div>
					</xsl:if>
					<!-- process $typeDesc differently -->
					<div class="metadata_section">
						<xsl:apply-templates select="exsl:node-set($typeDesc)/typeDesc"/>
					</div>
					<xsl:if test="descMeta/undertypeDesc">
						<div class="metadata_section">
							<xsl:apply-templates select="descMeta/undertypeDesc"/>
						</div>
					</xsl:if>
					<xsl:if test="descMeta/refDesc">
						<div class="metadata_section">
							<xsl:apply-templates select="descMeta/refDesc"/>
						</div>
					</xsl:if>
					<!--<xsl:if test="descMeta/findspotDesc">
						<div class="metadata_section">
							<xsl:apply-templates select="descMeta/findspotDesc"/>
						</div>
					</xsl:if>-->
					<xsl:if test="descMeta/adminDesc/*">
						<div class="metadata_section">
							<xsl:apply-templates select="descMeta/adminDesc"/>
						</div>
					</xsl:if>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div id="tabs">
					<ul>
						<li>
							<a href="#summary">Summary</a>
						</li>
						<xsl:if test="$has_mint_geo = 'true' or $has_findspot_geo = 'true'">
							<li>
								<a href="#map">Map</a>
							</li>
						</xsl:if>
						<xsl:if test="$recordType='conceptual' and count(//associatedObject) &gt; 0">
							<li>
								<a href="#charts">Quantitative</a>
							</li>
						</xsl:if>
						<xsl:if test="descMeta/adminDesc/*">
							<li>
								<a href="#administrative">Administrative</a>
							</li>
						</xsl:if>
						<xsl:if test="description">
							<li>
								<a href="#commentary">Commentary</a>
							</li>
						</xsl:if>

					</ul>
					<div id="summary">
						<xsl:if test="descMeta/physDesc">
							<div class="metadata_section">
								<xsl:apply-templates select="descMeta/physDesc"/>
							</div>
						</xsl:if>
						<!-- process $typeDesc differently -->
						<div class="metadata_section">
							<xsl:apply-templates select="exsl:node-set($typeDesc)/typeDesc"/>
						</div>
						<xsl:if test="descMeta/undertypeDesc">
							<div class="metadata_section">
								<xsl:apply-templates select="descMeta/undertypeDesc"/>
							</div>
						</xsl:if>
						<xsl:if test="descMeta/refDesc">
							<div class="metadata_section">
								<xsl:apply-templates select="descMeta/refDesc"/>
							</div>
						</xsl:if>
						<!--<xsl:if test="descMeta/findspotDesc">
							<div class="metadata_section">
								<xsl:apply-templates select="descMeta/findspotDesc"/>
							</div>
						</xsl:if>-->
					</div>
					<xsl:if test="$has_mint_geo = 'true' or $has_findspot_geo = 'true'">
						<div id="map">
							<h2>Map This Object</h2>
							<p>Use the layer control along the right edge of the map (the "plus" symbol) to toggle map layers.</p>
							<div id="basicMap"/>
							<div id="legend">
								<h3>Legend</h3>
								<ul>
									<li>
										<span class="legend-icon"><img src="{$display_path}images/star.png" alt="Mint"/></span>Mint </li>
									<li>
										<span class="legend-icon"><img src="{$display_path}images/x.gif" alt="Findspot"/></span>Findspot </li>
								</ul>

							</div>
							<ul id="term-list" style="display:none">
								<xsl:for-each select="document(concat($solr-url, 'select?q=id:&#x022;', $id, '&#x022;'))//arr">
									<xsl:if test="contains(@name, '_facet') and not(contains(@name, 'institution')) and not(contains(@name, 'collection')) and not(contains(@name, 'department'))">
										<xsl:variable name="name" select="@name"/>
										<xsl:for-each select="str">
											<li class="{$name}">
												<xsl:value-of select="."/>
											</li>
										</xsl:for-each>

									</xsl:if>
								</xsl:for-each>
							</ul>
						</div>
					</xsl:if>
					<xsl:if test="$recordType='conceptual' and count(//associatedObject) &gt; 0">
						<div id="charts">
							<xsl:call-template name="charts"/>
						</div>
					</xsl:if>
					<xsl:if test="descMeta/adminDesc/*">
						<div id="administrative">
							<xsl:apply-templates select="descMeta/adminDesc"/>
						</div>
					</xsl:if>
					<xsl:if test="description">
						<div id="commentary">
							<xsl:apply-templates select="description"/>
						</div>
					</xsl:if>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="physDesc[child::*]">
		<h2>Physical Attributes</h2>
		<ul>
			<xsl:apply-templates mode="descMeta"/>
		</ul>
	</xsl:template>

	<xsl:template match="typeDesc">
		<h2>Typological Attributes</h2>
		<xsl:if test="string($typeDesc_resource)">
			<p>Source: <a href="{$typeDesc_resource}"><xsl:value-of select="$typeDesc_resource"/></a></p>
		</xsl:if>
		<ul>
			<xsl:apply-templates mode="descMeta"/>
		</ul>
	</xsl:template>

	<xsl:template match="undertypeDesc">
		<h2>Undertype</h2>
		<ul>
			<xsl:apply-templates mode="descMeta"/>
		</ul>
	</xsl:template>

	<xsl:template match="findspotDesc">
		<h2>Findspot</h2>
		<ul>
			<xsl:apply-templates mode="descMeta"/>
		</ul>
	</xsl:template>

	<xsl:template match="refDesc">
		<h2>References</h2>
		<ul>
			<xsl:apply-templates mode="descMeta"/>
		</ul>
	</xsl:template>

	<xsl:template match="adminDesc">
		<h2>Administrative History</h2>
		<ul>
			<xsl:apply-templates mode="descMeta"/>
		</ul>
	</xsl:template>

	<xsl:template match="*" mode="descMeta">
		<xsl:variable name="facets">
			<xsl:text>artist,authority,category,collection,decoration,deity,degree,denomination,department,dynasty,engraver,era,findspot,grade,institution,issuer,portrait,manufacture,maker,material,mint,objectType,owner,region,repository,script,series,state,subject,subjectPerson,subjectIssuer,subjectEvent,subjectPlace</xsl:text>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="not(child::*)">
				<!-- the facet field is the @role if it exists, otherwise it is the name of the nuds element -->
				<xsl:variable name="field">
					<xsl:choose>
						<xsl:when test="string(@role)">
							<xsl:value-of select="@role"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="name()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<li>
					<b>
						<xsl:choose>
							<xsl:when test="string(@role)">
								<xsl:value-of select="concat(upper-case(substring(@role, 1, 1)), substring(@role, 2))"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="numishare:regularize_node(name())"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text>: </xsl:text>
					</b>

					<!-- create link from facet, if applicable -->
					<xsl:choose>
						<xsl:when test="contains($facets, $field)">
							<a href="{$display_path}results?q={$field}_facet:&#x022;{normalize-space(.)}&#x022;">
								<xsl:value-of select="."/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>

					<!-- display title -->
					<xsl:if test="string(@title)">
						<xsl:text> (</xsl:text>
						<xsl:value-of select="@title"/>
						<xsl:text>)</xsl:text>
					</xsl:if>

					<!-- create links to resources -->
					<xsl:if test="string(@rdf:resource)">
						<a href="{@rdf:resource}" target="_blank" title="{if (contains(@rdf:resource, 'geonames')) then 'geonames' else if (contains(@rdf:resource, 'nomisma')) then 'nomisma' else ''}">
							<img src="{$display_path}images/external.png" alt="external link" class="external_link"/>

						</a>
						<!-- parse nomisma RDFa, create links for pleiades and wikipedia -->
						<xsl:if test="contains(@rdf:resource, 'nomisma.org')">
							<xsl:variable name="rdf_url" select="concat('http://nomisma.org/cgi-bin/RDFa.py?uri=', encode-for-uri(@rdf:resource))"/>
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
									<img src="{$display_path}images/{$source}.png" alt="external link" class="external_link"/>									
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
											<xsl:value-of select="numishare:regularize_node(name())"/>
										</h3>
									</xsl:when>
									<xsl:otherwise>
										<h4>
											<xsl:value-of select="numishare:regularize_node(name())"/>
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
						<xsl:if test="child::*[not(name()='type' or name()='legend')]">
							<li>
								<xsl:choose>
									<xsl:when test="parent::physDesc">
										<h3>
											<xsl:value-of select="numishare:regularize_node(name())"/>
										</h3>
									</xsl:when>
									<xsl:otherwise>
										<h4>
											<xsl:value-of select="numishare:regularize_node(name())"/>
										</h4>
									</xsl:otherwise>
								</xsl:choose>
								<ul>
									<xsl:apply-templates select="*[not(name()='type' or name()='legend')]" mode="descMeta"/>
								</ul>
							</li>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="associatedObject">
		<xsl:variable name="object">
			<xsl:copy-of select="document(concat(@rdf:resource, '.xml'))/nuds/*"/>
		</xsl:variable>
		<div class="g_doc">
			<span class="result_link">
				<a href="{@rdf:resource}" target="_blank">
					<xsl:value-of select="exsl:node-set($object)/descMeta/title"/>
				</a>
			</span>
			<xsl:if test="exsl:node-set($object)/digRep/mets:fileSec">
				<div class="gi_c">
					<xsl:if test="exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='obverse']">
						<xsl:choose>
							<xsl:when test="contains(exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='obverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href, 'flickr')">
								<xsl:variable name="photo_id"
									select="substring-before(tokenize(exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='obverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href, '/')[last()], '_')"/>
								<xsl:variable name="flickr_uri" select="numishare:get_flickr_uri($photo_id)"/>

								<a href="{$flickr_uri}" target="_blank" class="flickrthumb">
									<img class="gi" src="{exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='obverse']/mets:file[@USE='thumbnail']/mets:FLocat/@xlink:href}"/>
								</a>
							</xsl:when>
							<xsl:when test="contains(exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='obverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href, 'http://')">
								<a href="{exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='obverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href}"
									class="thumbImage">
									<img class="gi"
										src="{exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='obverse']/mets:file[@USE='thumbnail']/mets:FLocat/@xlink:href}"/>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a href="{concat($display_path, exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='obverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href)}"
									class="thumbImage">
									<img class="gi"
										src="{concat($display_path, exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='obverse']/mets:file[@USE='thumbnail']/mets:FLocat/@xlink:href)}"/>
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='reverse']">
						<xsl:choose>
							<xsl:when test="contains(exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='reverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href, 'flickr')">
								<xsl:variable name="photo_id"
									select="substring-before(tokenize(exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='reverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href, '/')[last()], '_')"/>
								<a
									href="{document(concat('http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&amp;api_key=', $flickr-api-key, '&amp;photo_id=', $photo_id, '&amp;format=rest'))/rsp/photo/urls/url[@type='photopage']}"
									target="_blank" class="flickrthumb">
									<img class="gi" src="{exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='reverse']/mets:file[@USE='thumbnail']/mets:FLocat/@xlink:href}"/>
								</a>
							</xsl:when>
							<xsl:when test="contains(exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='reverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href, 'http://')">
								<a href="{exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='reverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href}"
									class="thumbImage">
									<img class="gi"
										src="{exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='reverse']/mets:file[@USE='thumbnail']/mets:FLocat/@xlink:href}"/>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a href="{concat($display_path, exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='reverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href)}"
									class="thumbImage">
									<img class="gi"
										src="{concat($display_path, exsl:node-set($object)/digRep/mets:fileSec/mets:fileGrp[@USE='reverse']/mets:file[@USE='thumbnail']/mets:FLocat/@xlink:href)}"/>
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</div>
			</xsl:if>
			<dl>
				<xsl:if test="exsl:node-set($object)/descMeta/adminDesc/repository">
					<div>
						<dt>Repository: </dt>
						<dd style="margin-left:150px;">
							<xsl:value-of select="exsl:node-set($object)/descMeta/adminDesc/repository"/>
						</dd>
					</div>
				</xsl:if>
				<xsl:if test="exsl:node-set($object)/descMeta/descMeta/adminDesc/owner">
					<div>
						<dt>Owner: </dt>
						<dd style="margin-left:150px;">
							<xsl:for-each select="exsl:node-set($object)/descMeta/adminDesc/owner">
								<xsl:value-of select="."/>
								<xsl:if test="not(position() = last())">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</dd>
					</div>
				</xsl:if>
				<xsl:if test="exsl:node-set($object)/descMeta/physDesc/axis">
					<div>
						<dt>Axis: </dt>
						<dd style="margin-left:150px;">
							<xsl:value-of select="exsl:node-set($object)/descMeta/physDesc/axis"/>
						</dd>
					</div>
				</xsl:if>
				<xsl:if test="exsl:node-set($object)/descMeta/physDesc/measurementsSet/diameter">
					<div>
						<dt>Diameter: </dt>
						<dd style="margin-left:150px;">
							<xsl:value-of select="exsl:node-set($object)/descMeta/physDesc/measurementsSet/diameter"/>
						</dd>
					</div>
				</xsl:if>
				<xsl:if test="exsl:node-set($object)/descMeta/physDesc/measurementsSet/weight">
					<div>
						<dt>Weight: </dt>
						<dd style="margin-left:150px;">
							<xsl:value-of select="exsl:node-set($object)/descMeta/physDesc/measurementsSet/weight"/>
						</dd>
					</div>
				</xsl:if>
				<xsl:if test="exsl:node-set($object)/descMeta/refDesc/reference">
					<div>
						<dt>Reference(s): </dt>
						<dd style="margin-left:125px;">
							<xsl:for-each select="exsl:node-set($object)/descMeta/refDesc/reference">
								<xsl:value-of select="."/>
								<xsl:if test="not(position() = last())">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</dd>
					</div>
				</xsl:if>
			</dl>
		</div>
	</xsl:template>

	<xsl:template name="obverse_image">
		<xsl:variable name="obverse_image">
			<xsl:if test="string(//mets:fileGrp[@USE='obverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href)">
				<xsl:value-of
					select="if (contains(//mets:fileGrp[@USE='obverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href, 'flickr.com')) then //mets:fileGrp[@USE='obverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href else concat($display_path, //mets:fileGrp[@USE='obverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href)"
				/>
			</xsl:if>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="exsl:node-set($typeDesc)/typeDesc/obverse">
				<xsl:for-each select="exsl:node-set($typeDesc)/typeDesc/obverse">
					<xsl:variable name="side" select="name()"/>
					<div class="reference_image">
						<xsl:if test="string($obverse_image)">
							<xsl:choose>
								<xsl:when test="contains($obverse_image, 'flickr.com')">
									<xsl:variable name="photo_id" select="substring-before(tokenize($obverse_image, '/')[last()], '_')"/>
									<a href="{numishare:get_flickr_uri($photo_id)}">
										<img src="{$obverse_image}" alt="{$side}"/>
									</a>

								</xsl:when>
								<xsl:otherwise>
									<img src="{$obverse_image}" alt="{$side}"/>
								</xsl:otherwise>
							</xsl:choose>
							<br/>
						</xsl:if>

						<b>
							<xsl:value-of select="numishare:regularize_node($side)"/>
							<xsl:if test="string(legend) or string(type)">
								<xsl:text>: </xsl:text>
							</xsl:if>
						</b>
						<xsl:apply-templates select="legend"/>
						<xsl:if test="string(legend) and string(type)">
							<xsl:text> - </xsl:text>
						</xsl:if>
						<xsl:apply-templates select="type"/>
					</div>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="not(exsl:node-set($typeDesc)/typeDesc/obverse) and //mets:fileGrp">
				<xsl:for-each select="//mets:file[@USE='reference']">
					<xsl:variable name="side" select="parent::mets:fileGrp/@USE"/>
					<div class="reference_image">
						<img src="{if (contains(mets:FLocat/@xlink:href, 'flickr.com')) then mets:FLocat/@xlink:href else concat($display_path, mets:FLocat/@xlink:href)}" alt="{$side}"/>
					</div>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="reverse_image">
		<xsl:variable name="reverse_image">
			<xsl:if test="string(//mets:fileGrp[@USE='reverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href)">
				<xsl:value-of
					select="if (contains(//mets:fileGrp[@USE='reverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href, 'flickr.com')) then //mets:fileGrp[@USE='reverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href else concat($display_path, //mets:fileGrp[@USE='reverse']/mets:file[@USE='reference']/mets:FLocat/@xlink:href)"
				/>
			</xsl:if>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="exsl:node-set($typeDesc)/typeDesc/reverse">
				<xsl:for-each select="exsl:node-set($typeDesc)/typeDesc/reverse">
					<xsl:variable name="side" select="name()"/>
					<div class="reference_image">
						<xsl:if test="string($reverse_image)">
							<xsl:choose>
								<xsl:when test="contains($reverse_image, 'flickr.com')">
									<xsl:variable name="photo_id" select="substring-before(tokenize($reverse_image, '/')[last()], '_')"/>
									<a href="{numishare:get_flickr_uri($photo_id)}">
										<img src="{$reverse_image}" alt="{$side}"/>
									</a>

								</xsl:when>
								<xsl:otherwise>
									<img src="{$reverse_image}" alt="{$side}"/>
								</xsl:otherwise>
							</xsl:choose>
							<br/>
						</xsl:if>

						<b>
							<xsl:value-of select="numishare:regularize_node($side)"/>
							<xsl:if test="string(legend) or string(type)">
								<xsl:text>: </xsl:text>
							</xsl:if>
						</b>
						<xsl:apply-templates select="legend"/>
						<xsl:if test="string(legend) and string(type)">
							<xsl:text> - </xsl:text>
						</xsl:if>
						<xsl:apply-templates select="type"/>
					</div>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="not(exsl:node-set($typeDesc)/typeDesc/reverse) and //mets:fileGrp">
				<xsl:for-each select="//mets:file[@USE='reference']">
					<xsl:variable name="side" select="parent::mets:fileGrp/@USE"/>
					<div class="reference_image">
						<img src="{if (contains(mets:FLocat/@xlink:href, 'flickr.com')) then mets:FLocat/@xlink:href else concat($display_path, mets:FLocat/@xlink:href)}" alt="{$side}"/>
					</div>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- charts template -->
	<xsl:template name="charts">
		<h2>Quantitative Analysis</h2>
		
		<xsl:choose>
			<xsl:when test="string($weightQuery)">
				<table id="weights">
					<caption>Average Weight for Coin-Type: <xsl:value-of select="$id"/></caption>
					<thead>
						<tr>
							<td/>
							<th>Average Weight</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th>
								<xsl:value-of select="$id"/>
							</th>
							<td>
								<cinclude:include src="cocoon:/get_avg_weight?q=id:&#x022;{$id}&#x022;"/>
							</td>
						</tr>
						<xsl:for-each select="$tokenized_weightQuery">
							<tr>
								<th>
									<xsl:value-of select="substring-after(translate(., '&#x022;', ''), ':')"/>
								</th>
								<td>
									<cinclude:include src="cocoon:/get_avg_weight?q={.}"/>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<p>Average weight for this coin-type: <cinclude:include src="cocoon:/get_avg_weight?q={.}"/> grams</p>
			</xsl:otherwise>
		</xsl:choose>
		
		<form id="charts-form" action="./{$id}#charts" style="margin:20px">
			<h3>Compare weights in related categories</h3>
			<!-- create checkboxes for available facets -->
			<xsl:for-each select="//material|//denomination|//department|//manufacture|//persname|//corpname|//famname|//geogname">
				<xsl:sort select="local-name()"/>
				<xsl:variable name="name">
					<xsl:choose>
						<xsl:when test="string(@role)">
							<xsl:value-of select="@role"/>
						</xsl:when>
						<xsl:when test="string(@type)">
							<xsl:value-of select="@type"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="local-name()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="query_fragment" select="concat($name, '_facet:&#x022;', ., '&#x022;')"/>
				
				<xsl:choose>
					<xsl:when test="contains($weightQuery, $query_fragment)">
						<input type="checkbox" id="{$name}-checkbox" checked="checked" value="{$query_fragment}" class="weight-checkbox"/>
					</xsl:when>
					<xsl:otherwise>
						<input type="checkbox" id="{$name}-checkbox" value="{$query_fragment}" class="weight-checkbox"/>
					</xsl:otherwise>
				</xsl:choose>
				
				<label for="{$name}-checkbox">
					<xsl:value-of select="concat(upper-case(substring($name, 1, 1)), substring($name, 2))"/>
					<xsl:text>: </xsl:text>
					<xsl:value-of select="."/>
				</label>
				<br/>
				
				
			</xsl:for-each>
			<input type="hidden" name="weightQuery" id="weights-q" value=""/>
			<br/>
			<input type="submit" value="Modify Chart" id="submit-weights"/>
		</form>
	</xsl:template>

	<!--<xsl:when test="$field = 'category_facet'">
		<xsl:variable name="tokenized-category" select="tokenize(normalize-space(.), '-/-')"/>
		
		<xsl:for-each select="$tokenized-category">
			<xsl:variable name="category-query">
				<xsl:call-template name="assemble_category_query">
					<xsl:with-param name="level" as="xs:integer" select="position()"/>
					<xsl:with-param name="tokenized-category" select="$tokenized-category"/>
				</xsl:call-template>
			</xsl:variable>
			<a href="{$display_path}results?q=category_facet:({$category-query})">
				<xsl:value-of select="."/>
			</a>
			<xsl:if test="not(position() = last())">
				<xsl:text>-/-</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:when>-->

	<xsl:template match="chronlist | list">
		<ul class="list">
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match="chronitem | item">
		<li>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="date">
		<xsl:choose>
			<xsl:when test="parent::chronitem">
				<i>
					<xsl:value-of select="."/>
				</i>
				<xsl:text>:  </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="event">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="eventgrp">
		<xsl:for-each select="event">
			<xsl:apply-templates select="."/>
			<xsl:if test="not(position() = last())">
				<xsl:text>; </xsl:text>
			</xsl:if>
		</xsl:for-each>
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
	<!--***************************************** END COMMENTARY **************************************** -->

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
			<div class="icon">
				<!-- AddThis Button BEGIN -->
				<a href="http://www.addthis.com/bookmark.php?v=250&amp;pub=xa-4a6926fd3dde83e2"
					onmouseover="return addthis_open(this, '', '[URL]', '[TITLE]')"
					onmouseout="addthis_close()" onclick="return addthis_sendto()">
					<img src="http://s7.addthis.com/static/btn/lg-bookmark-en.gif" width="125"
						height="16" alt="Bookmark and Share" style="border:0"/>
				</a>
				<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js?pub=xa-4a6926fd3dde83e2"/>
				<!-- AddThis Button END -->
			</div>
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
			<xsl:when test="$name='countermark'">Countermark</xsl:when>
			<xsl:when test="$name='custodhist'">Custodial History</xsl:when>
			<xsl:when test="$name='date'">Date</xsl:when>
			<xsl:when test="$name='dateOnObject'">Date on Object</xsl:when>
			<xsl:when test="$name='denomination'">Denomination</xsl:when>
			<xsl:when test="$name='department'">Department</xsl:when>
			<xsl:when test="$name='description'">Description</xsl:when>
			<xsl:when test="$name='diameter'">Diameter</xsl:when>
			<xsl:when test="$name='edge'">Edge</xsl:when>
			<xsl:when test="$name='era'">Era</xsl:when>
			<xsl:when test="$name='geographic'">Geographic</xsl:when>
			<xsl:when test="$name='grade'">Grade</xsl:when>
			<xsl:when test="$name='height'">Height</xsl:when>
			<xsl:when test="$name='identifier'">Identifier</xsl:when>
			<xsl:when test="$name='legend'">Legend</xsl:when>
			<xsl:when test="$name='material'">Material</xsl:when>
			<xsl:when test="$name='measurementsSet'">Measurements</xsl:when>
			<xsl:when test="$name='objectType'">Object Type</xsl:when>
			<xsl:when test="$name='obverse'">Obverse</xsl:when>
			<xsl:when test="$name='owner'">Owner</xsl:when>
			<xsl:when test="$name='repository'">Repository</xsl:when>
			<xsl:when test="$name='reverse'">Reverse</xsl:when>
			<xsl:when test="$name='saleCatalog'">Sale Catalog</xsl:when>
			<xsl:when test="$name='saleItem'">Sale Item</xsl:when>
			<xsl:when test="$name='salePrice'">Sale Price</xsl:when>
			<xsl:when test="$name='shape'">Shape</xsl:when>
			<xsl:when test="$name='symbol'">Symbol</xsl:when>
			<xsl:when test="$name='testmark'">Test Mark</xsl:when>
			<xsl:when test="$name='type'">Type</xsl:when>
			<xsl:when test="$name='thickness'">Thickness</xsl:when>
			<xsl:when test="$name='wear'">Wear</xsl:when>
			<xsl:when test="$name='weight'">Weight</xsl:when>
			<xsl:when test="$name='width'">Width</xsl:when>
			<xsl:otherwise>Unlabeled Category</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

</xsl:stylesheet>
