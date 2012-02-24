<?xml version="1.0" encoding="UTF-8"?>
<?cocoon-disable-caching?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" version="2.0"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:exsl="http://exslt.org/common" xmlns:numishare="http://code.google.com/p/numishare/" xmlns:skos="http://www.w3.org/2008/05/skos#"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:nuds="http://nomisma.org/nuds/" exclude-result-prefixes=" nuds rdf xlink exsl numishare xsl skos xlink cinclude">
	<xsl:template name="nudsHoard">
		<xsl:apply-templates select="/content/nudsHoard"/>
	</xsl:template>

	<xsl:template match="nudsHoard">
		<script type="text/javascript" langage="javascript">
                                                        $(function () {
                                                                $("#tabs").tabs();
                                                                initialize_map('true', '<xsl:value-of select="$id"/>', '<xsl:value-of select="$display_path"/>', '');
                                                        });
                                                </script>
		<script type="text/javascript" src="http://www.openlayers.org/api/OpenLayers.js"/>
		<script type="text/javascript" src="http://maps.google.com/maps/api/js?v=3.2&amp;sensor=false"/>
		<script type="text/javascript" src="{$display_path}javascript/display_map_functions.js"/>

		<xsl:call-template name="icons"/>
		<xsl:call-template name="nudsHoard_content"/>
		<xsl:call-template name="icons"/>
	</xsl:template>

	<xsl:template name="nudsHoard_content">
		<div class="yui-b">
			<div class="yui-g">
				<h1>
					<xsl:value-of select="$id"/>
				</h1>
				<div class="yui-u first">
					<div id="basicMap"/>
				</div>
				<div class="yui-u">
					<!--********************************* MENU ******************************************* -->
					<div id="tabs">
						<ul>
							<li>
								<a href="#summary">Summary</a>
							</li>
							<xsl:if test="descMeta/contentsDesc">
								<li>
									<a href="#contents">Contents</a>
								</li>
							</xsl:if>
						</ul>
						<div id="summary">
							<xsl:if test="descMeta/hoardDesc">
								<div class="metadata_section">
									<xsl:apply-templates select="descMeta/hoardDesc"/>
								</div>
							</xsl:if>
							<xsl:if test="descMeta/refDesc">
								<div class="metadata_section">
									<xsl:apply-templates select="descMeta/refDesc"/>
								</div>
							</xsl:if>
						</div>
						<xsl:if test="descMeta/contentsDesc">
							<div id="contents">
								<div class="metadata_section">
									<xsl:call-template name="contents"/>
								</div>
							</div>
						</xsl:if>
					</div>
				</div>
			</div>

		</div>
	</xsl:template>

	<xsl:template match="hoardDesc">
		<h2>Hoard Description</h2>
		<ul>
			<xsl:apply-templates mode="descMeta"/>
		</ul>
	</xsl:template>

	<xsl:template name="contents">
		<h2>Contents</h2>
		<xsl:apply-templates select="descendant::coin|descendant::coinGrp"/>
	</xsl:template>

	<xsl:template match="coin|coinGrp">
		<div class="coin-group" style="border-bottom:1px solid silver">
			<h3>
				<xsl:text>Coin</xsl:text>
				<xsl:if test="local-name()='coinGrp'">
					<xsl:text> Group: </xsl:text>
					<xsl:value-of select="@count"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="if(number(@count) = 1) then 'coin' else 'coins'"/>
				</xsl:if>
			</h3>
			<xsl:variable name="typeDesc_resource">
				<xsl:if test="string(*[local-name()='typeDesc']/@xlink:href)">
					<xsl:value-of select="*[local-name()='typeDesc']/@xlink:href"/>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="typeDesc">
				<xsl:choose>
					<xsl:when test="string($typeDesc_resource)">
						<xsl:copy-of select="document(concat($typeDesc_resource, '.xml'))/nuds/descMeta/typeDesc"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="*[local-name()='typeDesc']"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<!-- apply templates -->
			<xsl:apply-templates select="*[local-name()='physDesc']"/>
			<xsl:apply-templates select="exsl:node-set($typeDesc)/*[local-name()='typeDesc']">
				<xsl:with-param name="typeDesc_resource" select="$typeDesc_resource"/>
			</xsl:apply-templates>			
		</div>
	</xsl:template>

	<!-- charts template -->
	<!--<xsl:template name="charts">
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
			<!-\- create checkboxes for available facets -\->
			<xsl:for-each select="//material|//denomination|//department|//manufacture|//persname|//corpname|//famname|//geogname">
				<xsl:sort select="local-name()"/>
				<xsl:variable name="name">
					<xsl:choose>
						<xsl:when test="string(@xlink:role)">
							<xsl:value-of select="@xlink:role"/>
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
	</xsl:template>-->


</xsl:stylesheet>
