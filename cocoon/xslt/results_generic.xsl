<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="xs cinclude"
	version="2.0">
	
	<xsl:template match="doc">
		<xsl:variable name="sort_category" select="substring-before($sort, ' ')"/>
		<xsl:variable name="regularized_sort">
			<xsl:call-template name="normalize_fields">
				<xsl:with-param name="field" select="$sort_category"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="collection" select="substring-before(str[@name='identifier_display'], '.')"/>


		<tr class="result_doc">
			<xsl:if test="not($mode='compare') and //config/theme/layouts/*[name()=$pipeline]/image_location = 'left'">		
				<xsl:call-template name="result_image">
					<xsl:with-param name="alignment">left</xsl:with-param>
				</xsl:call-template>
			</xsl:if>

			<td class="result_metadata">
				<xsl:if test="$mode='compare'">
					<xsl:variable name="img_string">
						<xsl:choose>
							<xsl:when test="$image='reverse'">
								<xsl:text>reference_rev</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>reference_obv</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<div style="text-align:center;">
						<img src="{str[@name=$img_string]}" style="max-height:320px; min-height:320px;"/>
					</div>
				</xsl:if>
				<span class="result_link">
					<xsl:choose>
						<xsl:when test="$mode = 'compare'">
							<a href="{$display_path}display_ajax/{str[@name='id']}?mode=compare&amp;q={$q}&amp;start={$start}&amp;image={$image}&amp;side={$side}" class="compare">
								<xsl:value-of select="str[@name='title_display']"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<a href="{$display_path}display/{str[@name='id']}">
								<xsl:value-of select="str[@name='title_display']"/>
							</a>
						</xsl:otherwise>
					</xsl:choose>
				</span>
				<br/>
				<dl>
					<xsl:if test="str[@name='obv_leg_display'] or str[@name='obv_type_display']">
						<div>
							<dt>Obverse:</dt>
							<dd style="margin-left:150px;">
								<xsl:value-of select="str[@name='obv_type_display']"/>
								<xsl:if test="str[@name='obv_leg_display'] and str[@name='obv_type_display']">
									<xsl:text>: </xsl:text>
								</xsl:if>
								<xsl:value-of select="str[@name='obv_leg_display']"/>
							</dd>
						</div>
					</xsl:if>
					<xsl:if test="str[@name='rev_leg_display'] or str[@name='rev_type_display']">
						<div>
							<dt>Reverse:</dt>
							<dd style="margin-left:150px;">
								<xsl:value-of select="str[@name='rev_type_display']"/>
								<xsl:if test="str[@name='rev_leg_display'] and str[@name='rev_type_display']">
									<xsl:text>: </xsl:text>
								</xsl:if>
								<xsl:value-of select="str[@name='rev_leg_display']"/>
							</dd>
						</div>
					</xsl:if>
					<xsl:if test="arr[@name='diameter_num']">
						<div>
							<dt>Diameter: </dt>
							<dd style="margin-left:150px;">
								<xsl:value-of select="float[@name='diameter_num']"/>
							</dd>
						</div>
					</xsl:if>
					<xsl:if test="float[@name='weight_num']">
						<div>
							<dt>Weight: </dt>
							<dd style="margin-left:150px;">
								<xsl:value-of select="float[@name='weight_num']"/>
							</dd>
						</div>
					</xsl:if>					
					<!--<xsl:if test="str[@name='axis_num']">
						<div>
							<dt>Axis: </dt>
							<dd style="margin-left:150px;">
								<xsl:value-of select="str[@name='axis_num']"/>
							</dd>
						</div>
					</xsl:if>-->
					<xsl:if test="arr[@name='reference_display']">
						<div>
							<dt>Reference(s): </dt>
							<dd style="margin-left:150px;">
								<xsl:for-each select="arr[@name='reference_display']/str">
									<xsl:value-of select="."/>
									<xsl:if test="not(position() = last())">
										<xsl:text>, </xsl:text>
									</xsl:if>
								</xsl:for-each>
							</dd>
						</div>
					</xsl:if>

					<!-- display appropriate sort category if it isn't one of the default display fields -->
					<xsl:if
						test="string($sort) and not(contains($sort_category, 'year')) and not(contains($sort_category, 'department_facet')) and not(contains($sort_category, 'weight_num')) and not(contains($sort_category, 'dimensions_display'))">
						<xsl:choose>
							<xsl:when test="contains($sort, '_num')">
								<div>
									<dt>
										<xsl:value-of select="$regularized_sort"/>
										<xsl:text>:</xsl:text>
									</dt>
									<dd style="margin-left: 150px;">
										<xsl:for-each select="distinct-values(arr[@name=$sort_category]/int)">
											<xsl:sort order="descending"/>
											<xsl:choose>
												<xsl:when test="$sort_category='century_num'">
													<xsl:call-template name="regularize_century">
														<xsl:with-param name="term" select="."/>
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="."/>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:if test="not(position() = last())">
												<xsl:text>, </xsl:text>
											</xsl:if>
										</xsl:for-each>
									</dd>
								</div>
							</xsl:when>
							<xsl:when test="contains($sort, 'timestamp')">
								<div>
									<dt>
										<xsl:value-of select="$regularized_sort"/>
										<xsl:text>:</xsl:text>
									</dt>
									<dd style="margin-left: 150px;">
										<xsl:value-of select="date[@name='timestamp']"/>
									</dd>
								</div>
							</xsl:when>
							<xsl:when test="contains($sort, '_facet') or contains($sort, 'reference_display') or contains($sort, 'prevcoll_display')">
								<div>
									<xsl:choose>
										<xsl:when test="matches($sort, 'objectType_facet')">
											<dt>Object Type:</dt>
											<dd>
												<xsl:value-of select="str[@name='objectType_facet']"/>
											</dd>
										</xsl:when>
										<xsl:otherwise>
											<xsl:if test="arr[@name=$sort_category]/str">
												<dt>
													<xsl:value-of select="$regularized_sort"/>
													<xsl:text>:</xsl:text>
												</dt>
												<dd style="margin-left: 150px;">
													<xsl:for-each select="arr[@name=$sort_category]/str">
														<xsl:sort order="descending"/>
														<xsl:value-of select="."/>
														<xsl:if test="not(position() = last())">
															<xsl:text>, </xsl:text>
														</xsl:if>
													</xsl:for-each>
												</dd>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</div>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="str[@name=$sort_category]">
									<div>
										<dt>
											<xsl:value-of select="$regularized_sort"/>
											<xsl:text>:</xsl:text>
										</dt>
										<xsl:value-of select="substring(str[@name=$sort_category], 1, 25)"/>
										<xsl:if test="string-length(str[@name=$sort_category]) &gt; 25">
											<xsl:text>...</xsl:text>
										</xsl:if>
									</div>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</dl>
			</td>
			<xsl:if test="not($mode='compare') and //config/theme/layouts/*[name()=$pipeline]/image_location = 'right'">		
				<xsl:call-template name="result_image">
					<xsl:with-param name="alignment">right</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</tr>
	</xsl:template>

	<xsl:template match="lst[@name='facet_fields']">
		<!-- ignore mint_geo-->
		<xsl:for-each select="lst[not(@name='mint_geo') and number(int[@name='numFacetTerms']) &gt; 0]">
			<xsl:variable name="val" select="@name"/>
			<xsl:variable name="new_query">
				<xsl:for-each select="$tokenized_q[not(contains(., $val))]">
					<xsl:value-of select="."/>
					<xsl:if test="position() != last()">
						<xsl:text> AND </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>

			<xsl:variable name="title">
				<xsl:call-template name="normalize_fields">
					<xsl:with-param name="field" select="@name"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="@name = 'category_facet'">
					<!--<h2>Category</h2>-->
					<button class="ui-multiselect ui-widget ui-state-default ui-corner-all" type="button" title="Category" aria-haspopup="true" style="width: 200px;" id="{@name}_link" label="{$q}">
						<span class="ui-icon ui-icon-triangle-2-n-s"/>
						<span>Category</span>
					</button>
					<xsl:choose>
						<xsl:when test="contains($q, @name)">
							<div class="ui-multiselect-menu ui-widget ui-widget-content ui-corner-all" style="width: 192px">
								<div class="ui-widget-header ui-corner-all ui-multiselect-header ui-helper-clearfix ui-multiselect-hasfilter">
									<ul class="ui-helper-reset">
										<li class="ui-multiselect-close">
											<a class="ui-multiselect-close category-close" href="#"> close<span class="ui-icon ui-icon-circle-close"/>
											</a>
										</li>
									</ul>
								</div>
								<ul class="category-multiselect-checkboxes ui-helper-reset" id="{@name}-list" style="height: 175px;">
									<xsl:if test="contains($q, @name)">
										<cinclude:include src="cocoon:/get_categories?q={$q}&amp;fq=*&amp;prefix=L1&amp;link=&amp;section=collection"/>
									</xsl:if>
								</ul>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<div class="ui-multiselect-menu ui-widget ui-widget-content ui-corner-all" style="width: 192px;">
								<div class="ui-widget-header ui-corner-all ui-multiselect-header ui-helper-clearfix ui-multiselect-hasfilter">
									<ul class="ui-helper-reset">
										<li class="ui-multiselect-close">
											<a class="ui-multiselect-close category-close" href="#"> close<span class="ui-icon ui-icon-circle-close"/>
											</a>
										</li>
									</ul>
								</div>
								<ul class="category-multiselect-checkboxes ui-helper-reset" id="{@name}-list" style="height: 175px;"/>
							</div>
						</xsl:otherwise>
					</xsl:choose>
					<br/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="count" select="number(int[@name='numFacetTerms'])"/>
					<xsl:variable name="mincount" as="xs:integer">
						<xsl:choose>
							<xsl:when test="$count &gt; 500">
								<xsl:value-of select="ceiling($count div 500)"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="select_new_query">
						<xsl:choose>
							<xsl:when test="string($new_query)">
								<xsl:value-of select="$new_query"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>*:*</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<select id="{@name}-select" multiple="multiple" class="multiselect" size="10" title="{$title}" q="{$q}" mincount="{$mincount}"
						new_query="{if (contains($q, @name)) then $select_new_query else ''}">
						<xsl:if test="contains($q, @name)">
							<!--<option selected="selected">test</option>-->
							<cinclude:include src="cocoon:/get_facet_options?q={$q}&amp;category={@name}&amp;sort=index&amp;offset=0&amp;limit=-1&amp;rows=0&amp;mincount={$mincount}"/>
						</xsl:if>
					</select>
					<br/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<form action="results" id="facet_form">
			<xsl:variable name="imageavailable_stripped">
				<xsl:for-each select="$tokenized_q[not(contains(., 'imagesavailable'))]">
					<xsl:value-of select="."/>
					<xsl:if test="position() != last()">
						<xsl:text> AND </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<input type="hidden" name="q" id="facet_form_query" value="{if (string($imageavailable_stripped)) then $imageavailable_stripped else '*:*'}"/>
			<br/>
			<div>
				<b>Has Images:</b>
				<xsl:choose>
					<xsl:when test="contains($q, 'imagesavailable:true')">
						<input type="checkbox" id="imagesavailable" checked="checked"/>
					</xsl:when>
					<xsl:otherwise>
						<input type="checkbox" id="imagesavailable"/>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			<div class="submit_div">
				<input type="submit" value="Refine Search" id="search_button" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only ui-state-focus"/>
			</div>
		</form>
	</xsl:template>
	
	<xsl:template name="result_image">
		<xsl:param name="alignment"/>
		<td class="result_image_{$alignment}">
			<xsl:choose>
				<xsl:when test="str[@name='recordType'] = 'physical'">
					<xsl:if test="string(str[@name='thumbnail_obv'])">
						<a class="thumbImage" href="{str[@name='reference_obv']}" title="Obverse of {str[@name='title_display']}">
							<img src="{str[@name='thumbnail_obv']}"/>
						</a>
					</xsl:if>
					<xsl:if test="string(str[@name='thumbnail_rev'])">
						<a class="thumbImage" href="{str[@name='reference_rev']}" title="Reverse of {str[@name='title_display']}">
							<img src="{str[@name='thumbnail_rev']}"/>
						</a>
					</xsl:if>
				</xsl:when>
				<xsl:when test="str[@name='recordType'] = 'conceptual'">
					<xsl:variable name="count" select="count(arr[@name='ao_uri']/str)"/>
					<xsl:variable name="title" select="str[@name='title_display']	"/>
					<xsl:variable name="docId" select="str[@name='id']"/>
					
					<xsl:if test="count(arr[@name='ao_thumbnail_obv']/str) &gt; 0">
						<xsl:variable name="nudsid" select="substring-before(arr[@name='ao_thumbnail_obv']/str[1], '|')"/>
						<a class="thumbImage" rel="{str[@name='id']}-gallery" href="{substring-after(arr[@name='ao_reference_obv']/str[contains(., $nudsid)], '|')}"
							title="Obverse of {$title}: {$nudsid}">
							<img src="{substring-after(arr[@name='ao_thumbnail_obv']/str[1], '|')}"/>
						</a>
						<xsl:if test="arr[@name='ao_thumbnail_rev']/str[contains(., $nudsid)]">
							<a class="thumbImage" rel="{str[@name='id']}-gallery" href="{substring-after(arr[@name='ao_reference_rev']/str[contains(., $nudsid)], '|')}"
								title="Reverse of {$title}: {$nudsid}">
								<img src="{substring-after(arr[@name='ao_thumbnail_rev']/str[contains(., $nudsid)], '|')}"/>
							</a>
						</xsl:if>
						<div style="display:none">
							<xsl:for-each select="arr[@name='ao_thumbnail_obv']/str[not(contains(., $nudsid))]">
								<xsl:variable name="thisId" select="substring-before(., '|')"/>
								<a class="thumbImage" rel="{$docId}-gallery" href="{substring-after(//arr[@name='ao_reference_obv']/str[contains(., $thisId)], '|')}"
									title="Obverse of {$title}: {$thisId}">
									<img src="{substring-after(., '|')}" alt="image"/>
								</a>
								<xsl:if test="//arr[@name='ao_thumbnail_rev']/str[contains(., $thisId)]">
									<a class="thumbImage" rel="{$docId}-gallery" href="{substring-after(ancestor::doc/arr[@name='ao_reference_rev']/str[contains(., $thisId)], '|')}"
										title="Reverse of {$title}: {$thisId}">
										<img src="{substring-after(//arr[@name='ao_thumbnail_rev']/str[contains(., $thisId)], '|')}"/>
									</a>
								</xsl:if>
							</xsl:for-each>
						</div>
					</xsl:if>
					<br/>
					<xsl:value-of select="concat($count, if($count = 1) then ' associated coin' else ' associated coins')"/>
				</xsl:when>
			</xsl:choose>
		</td>
	</xsl:template>

	<xsl:template name="paging">
		<xsl:variable name="start_var" as="xs:integer">
			<xsl:choose>
				<xsl:when test="string($start)">
					<xsl:value-of select="$start"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="next">
			<xsl:value-of select="$start_var+$rows"/>
		</xsl:variable>

		<xsl:variable name="previous">
			<xsl:choose>
				<xsl:when test="$start_var &gt;= $rows">
					<xsl:value-of select="$start_var - $rows"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="current" select="$start_var div $rows + 1"/>
		<xsl:variable name="total" select="ceiling($numFound div $rows)"/>

		<div class="paging_div">
			<div style="float:left;">
				<xsl:text>Displaying records </xsl:text>
				<b>
					<xsl:value-of select="$start_var + 1"/>
				</b>
				<xsl:text> to </xsl:text>
				<xsl:choose>
					<xsl:when test="$numFound &gt; ($start_var + $rows)">
						<b>
							<xsl:value-of select="$start_var + $rows"/>
						</b>
					</xsl:when>
					<xsl:otherwise>
						<b>
							<xsl:value-of select="$numFound"/>
						</b>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> of </xsl:text>
				<b>
					<xsl:value-of select="$numFound"/>
				</b>
				<xsl:text> total results.</xsl:text>
			</div>

			<!-- paging functionality -->
			<div style="float:right;">
				<xsl:choose>
					<xsl:when test="$start_var &gt;= $rows">
						<xsl:choose>
							<xsl:when test="string($sort)">
								<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={$previous}&amp;sort={$sort}">«Previous</a>
							</xsl:when>
							<xsl:otherwise>
								<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={$previous}">«Previous</a>
							</xsl:otherwise>
						</xsl:choose>

					</xsl:when>
					<xsl:otherwise>
						<span class="pagingSep">«Previous</span>
					</xsl:otherwise>
				</xsl:choose>

				<!-- always display links to the first two pages -->
				<xsl:if test="$start_var div $rows &gt;= 3">
					<xsl:choose>
						<xsl:when test="string($sort)">
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start=0&amp;sort={$sort}">
								<xsl:text>1</xsl:text>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start=0">
								<xsl:text>1</xsl:text>
							</a>
						</xsl:otherwise>
					</xsl:choose>

				</xsl:if>
				<xsl:if test="$start_var div $rows &gt;= 4">
					<xsl:choose>
						<xsl:when test="string($sort)">
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={$rows}&amp;sort={$sort}">
								<xsl:text>2</xsl:text>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={$rows}">
								<xsl:text>2</xsl:text>
							</a>
						</xsl:otherwise>
					</xsl:choose>

				</xsl:if>

				<!-- display only if you are on page 6 or greater -->
				<xsl:if test="$start_var div $rows &gt;= 5">
					<span class="pagingSep">...</span>
				</xsl:if>

				<!-- always display links to the previous two pages -->
				<xsl:if test="$start_var div $rows &gt;= 2">
					<xsl:choose>
						<xsl:when test="string($sort)">
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={$start_var - ($rows * 2)}&amp;sort={$sort}">
								<xsl:value-of select="($start_var div $rows) -1"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={$start_var - ($rows * 2)}">
								<xsl:value-of select="($start_var div $rows) -1"/>
							</a>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="$start_var div $rows &gt;= 1">
					<xsl:choose>
						<xsl:when test="string($sort)">
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={$start_var - $rows}&amp;sort={$sort}">
								<xsl:value-of select="$start_var div $rows"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={$start_var - $rows}">
								<xsl:value-of select="$start_var div $rows"/>
							</a>
						</xsl:otherwise>
					</xsl:choose>

				</xsl:if>

				<span class="pagingBtn">
					<b>
						<xsl:value-of select="$current"/>
					</b>
				</span>

				<!-- next two pages -->
				<xsl:if test="($start_var div $rows) + 1 &lt; $total">
					<xsl:choose>
						<xsl:when test="string($sort)">
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={$start_var + $rows}&amp;sort={$sort}">
								<xsl:value-of select="($start_var div $rows) +2"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={$start_var + $rows}">
								<xsl:value-of select="($start_var div $rows) +2"/>
							</a>
						</xsl:otherwise>
					</xsl:choose>

				</xsl:if>
				<xsl:if test="($start_var div $rows) + 2 &lt; $total">
					<xsl:choose>
						<xsl:when test="string($sort)">
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={$start_var + ($rows * 2)}&amp;sort={$sort}">
								<xsl:value-of select="($start_var div $rows) +3"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={$start_var + ($rows * 2)}">
								<xsl:value-of select="($start_var div $rows) +3"/>
							</a>
						</xsl:otherwise>
					</xsl:choose>

				</xsl:if>
				<xsl:if test="$start_var div $rows &lt;= $total - 6">
					<span class="pagingSep">...</span>
				</xsl:if>

				<!-- last two pages -->
				<xsl:if test="$start_var div $rows &lt;= $total - 5">
					<xsl:choose>
						<xsl:when test="string($sort)">
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={($total * $rows) - ($rows * 2)}&amp;sort={$sort}">
								<xsl:value-of select="$total - 1"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={($total * $rows) - ($rows * 2)}">
								<xsl:value-of select="$total - 1"/>
							</a>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="$start_var div $rows &lt;= $total - 4">
					<xsl:choose>
						<xsl:when test="string($sort)">
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={($total * $rows) - $rows}&amp;sort={$sort}">
								<xsl:value-of select="$total"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={($total * $rows) - $rows}">
								<xsl:value-of select="$total"/>
							</a>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="$numFound - $start_var &gt; $rows">
						<xsl:choose>
							<xsl:when test="string($sort)">
								<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={$next}&amp;sort={$sort}">Next»</a>
							</xsl:when>
							<xsl:otherwise>
								<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={$next}">Next»</a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<span class="pagingSep">Next»</span>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="sort">
		<xsl:variable name="sort_categories_string">
			<xsl:text>identifier_display,authority_facet,century_num,color_display,dob_num,timestamp,degree_facet,deity_facet,denomination_facet,department_facet,diameter_num,dynasty_facet,findspot_facet,issuer_facet,manufacture_facet,material_facet,mint_facet,obv_leg_display,objectType_facet,portrait_facet,prevcoll_display,reference_display,region_facet,rev_leg_display,weight_num,year_num</xsl:text>
		</xsl:variable>
		<xsl:variable name="sort_categories" select="tokenize(normalize-space($sort_categories_string), ',')"/>

		<div class="sort_div">
			<form class="sortForm" action="results">
				<select class="sortForm_categories">
					<option value="null">Select from list...</option>
					<xsl:for-each select="$sort_categories">
						<xsl:choose>
							<xsl:when test="contains($sort, .)">
								<option value="{.}" selected="selected">
									<xsl:call-template name="normalize_fields">
										<xsl:with-param name="field" select="."/>
									</xsl:call-template>
								</option>
							</xsl:when>
							<xsl:otherwise>
								<option value="{.}">
									<xsl:call-template name="normalize_fields">
										<xsl:with-param name="field" select="."/>
									</xsl:call-template>
								</option>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</select>
				<select class="sortForm_order">
					<xsl:choose>
						<xsl:when test="contains($sort, 'asc')">
							<option value="asc" selected="selected">Ascending</option>
						</xsl:when>
						<xsl:otherwise>
							<option value="asc">Ascending</option>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="contains($sort, 'desc')">
							<option value="desc" selected="selected">Descending</option>
						</xsl:when>
						<xsl:otherwise>
							<option value="desc">Descending</option>
						</xsl:otherwise>
					</xsl:choose>
				</select>
				<input type="hidden" name="q" value="{$q}"/>
				<input type="hidden" name="sort" value="" class="sort_param"/>
				<xsl:choose>
					<xsl:when test="string($sort)">
						<input id="sort_button" type="submit" value="Sort Results"/>
					</xsl:when>
					<xsl:otherwise>
						<input id="sort_button" type="submit" value="Sort Results"/>
					</xsl:otherwise>
				</xsl:choose>
			</form>
		</div>
	</xsl:template>

	<xsl:template name="quick_search">
		<div class="quick_search">
			<h3>Quick Search</h3>
			<form action="results" method="GET" id="qs_form">
				<input type="text" id="qs_text"/>
				<input type="hidden" name="q" id="qs_query" value="{$q}"/>
				<input id="qs_button" type="submit" value="Search"/>
			</form>
		</div>
	</xsl:template>
	
	<xsl:template name="remove_facets">
		<div class="remove_facets">
			<xsl:choose>
				<xsl:when test="$q = '*:*'">
					<h1>All Terms <xsl:if test="//lst[@name='mint_geo']/int[@name='numFacetTerms'] &gt; 0">
						<a href="#resultMap" id="map_results">Map Results</a>
					</xsl:if>
					</h1>
				</xsl:when>
				<xsl:otherwise>
					<h1>Filters <xsl:if test="//lst[@name='mint_geo']/int[@name='numFacetTerms'] &gt; 0">
						<a href="#resultMap" id="map_results">Map Results</a>
					</xsl:if>
					</h1>
				</xsl:otherwise>
			</xsl:choose>
			
			
			<xsl:for-each select="$tokenized_q[not(contains(., 'category_facet'))]">
				<xsl:variable name="val" select="."/>
				<xsl:variable name="new_query">
					<xsl:for-each select="$tokenized_q[not($val = .)]">
						<xsl:value-of select="."/>
						<xsl:if test="position() != last()">
							<xsl:text> AND </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				
				<!--<xsl:value-of select="."/>-->
				<xsl:choose>
					<xsl:when test="not(. = '*:*') and not(substring(., 1, 1) = '(')">
						<xsl:variable name="field" select="substring-before(., ':')"/>
						<xsl:variable name="name">
							<xsl:call-template name="normalize_fields">
								<xsl:with-param name="field" select="$field"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="term" select="replace(substring-after(., ':'), '&#x022;', '')"/>
						
						<div class="ui-widget ui-state-default ui-corner-all stacked_term">
							<span>
								<b><xsl:value-of select="$name"/>: </b>
								<xsl:choose>
									<xsl:when test="$field = 'century_num'">
										<xsl:call-template name="regularize_century">
											<xsl:with-param name="term" select="$term"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$term"/>
									</xsl:otherwise>
								</xsl:choose>
							</span>
							<a class="ui-icon ui-icon-closethick remove_filter" href="?q={if (string($new_query)) then encode-for-uri($new_query) else '*:*'}">X</a>
						</div>
						
					</xsl:when>
					<!-- if the token contains a parenthisis, then it was probably sent from the search widget and the token must be broken down further to remove other facets -->
					<xsl:when test="substring(., 1, 1) = '('">
						<xsl:variable name="tokenized-fragments" select="tokenize(substring(substring(., 1, string-length(.) - 1), 2), ' OR ')"/>
						<xsl:variable name="field" select="substring-before($tokenized-fragments[1], ':')"/>
						<xsl:variable name="name">
							<xsl:call-template name="normalize_fields">
								<xsl:with-param name="field" select="$field"/>
							</xsl:call-template>
						</xsl:variable>
						
						<xsl:variable name="multifields">
							<xsl:call-template name="multifields">
								<xsl:with-param name="field" select="$field"/>
								<xsl:with-param name="position" select="1"/>
								<xsl:with-param name="fragments" select="$tokenized-fragments"/>
								<xsl:with-param name="count" select="count($tokenized-fragments)"/>
							</xsl:call-template>
						</xsl:variable>
						
						<div class="ui-widget ui-state-default ui-corner-all stacked_term">
							
							<xsl:if test="$multifields != 'true'">
								<b><xsl:value-of select="$name"/>: </b>
							</xsl:if>
							<xsl:for-each select="$tokenized-fragments">
								<span>
									<xsl:variable name="value" select="."/>
									<xsl:variable name="new_multicategory">
										<xsl:for-each select="$tokenized-fragments[not(. = $value)]">
											<xsl:value-of select="."/>
											<xsl:if test="position() != last()">
												<xsl:text> OR </xsl:text>
											</xsl:if>
										</xsl:for-each>
									</xsl:variable>
									<xsl:variable name="multicategory_query">
										<xsl:choose>
											<xsl:when test="contains($new_multicategory, ' OR ')">
												<xsl:value-of select="concat('(', $new_multicategory, ')')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$new_multicategory"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									
									<!-- display either the term or the regularized name for the century -->
									<xsl:variable name="term" select="replace(substring-after(., ':'), '&#x022;', '')"/>
									
									<xsl:if test="$multifields = 'true'">
										<b>
											<xsl:call-template name="normalize_fields">
												<xsl:with-param name="field" select="substring-before(., ':')"/>
											</xsl:call-template>
											<xsl:text>: </xsl:text>
										</b>
									</xsl:if>
									<xsl:choose>
										<xsl:when test="$field = 'century_num'">
											<xsl:call-template name="regularize_century">
												<xsl:with-param name="term" select="$term"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$term"/>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:text>[</xsl:text>
									<!-- concatenate the query with the multicategory removed with the new multicategory, or if the multicategory is empty, display just the $new_query -->
									<a class="remove_segment"
										href="?q={if (string($multicategory_query) and string($new_query)) then encode-for-uri(concat($new_query, ' AND ', $multicategory_query)) else if (string($multicategory_query) and not(string($new_query))) then encode-for-uri($multicategory_query) else $new_query}"
										>X</a>
									<xsl:text>]</xsl:text>
									<xsl:if test="position() != last()">
										<xsl:text> OR </xsl:text>
									</xsl:if>
								</span>
							</xsl:for-each>
							
							<a class="ui-icon ui-icon-closethick remove_filter" href="?q={if (string($new_query)) then encode-for-uri($new_query) else '*:*'}">X</a>
						</div>
					</xsl:when>
					<xsl:when test="not(contains(., ':'))">
						<div class="stacked_term">
							<span>
								<b>Keyword: </b>
								<xsl:value-of select="."/>
							</span>
						</div>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
			<xsl:if test="contains($q, 'category_facet')">
				<xsl:variable name="category_query" select="$tokenized_q[contains(., 'category_facet')]"/>
				<!--<xsl:value-of select="$category_query"/>-->
				<xsl:choose>
					<!-- if the category query comes from the search widget: -->
					<xsl:when test="contains($q, '(category_facet')">
						<xsl:variable name="tokenized-multicategory" select="tokenize(substring-after(substring($category_query, 1, string-length($category_query) - 1), '('), ' OR ')"/>
						<xsl:variable name="new_query">
							<xsl:for-each select="$tokenized_q[not(. = $category_query)]">
								<xsl:value-of select="."/>
								<xsl:if test="position() != last()">
									<xsl:text> AND </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>
						
						<div class="ui-widget ui-state-default ui-corner-all stacked_term">
							<span class="term">
								<b>Category: </b>
								<xsl:for-each select="$tokenized-multicategory">
									<xsl:variable name="value" select="."/>
									<xsl:variable name="new_multicategory">
										<xsl:for-each select="$tokenized-multicategory[not(. = $value)]">
											<xsl:value-of select="."/>
											<xsl:if test="position() != last()">
												<xsl:text> OR </xsl:text>
											</xsl:if>
										</xsl:for-each>
									</xsl:variable>
									<xsl:variable name="multicategory_query">
										<xsl:choose>
											<xsl:when test="contains($new_multicategory, ' OR ')">
												<xsl:value-of select="concat('(', $new_multicategory, ')')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$new_multicategory"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:call-template name="recompile_category">
										<xsl:with-param name="category_fragment" select="."/>
										<xsl:with-param name="tokenized_fragment" select="tokenize(substring-after(replace(replace(replace(., '\)', ''), '\(', ''), '\+', ''), 'category_facet:'), ' ')"/>
										<xsl:with-param name="level" as="xs:integer">1</xsl:with-param>
									</xsl:call-template>
									<xsl:text>[</xsl:text>
									<a class="remove_segment"
										href="?q={if (string($new_query)) then encode-for-uri(concat($new_query, ' AND ', $multicategory_query)) else encode-for-uri($multicategory_query)}">X</a>
									<xsl:text>]</xsl:text>
									<xsl:if test="not(position() = last())">
										<xsl:text> OR </xsl:text>
									</xsl:if>
								</xsl:for-each>
							</span>
							<a class="ui-icon ui-icon-closethick remove_filter" href="?q={if (string($new_query)) then encode-for-uri($new_query) else '*:*'}">X</a>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="render_categories">
							<xsl:with-param name="category_fragment" select="$category_query"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:if>
			<!-- remove sort term -->
			<xsl:if test="string($sort)">
				<xsl:variable name="field" select="substring-before($sort, ' ')"/>
				<xsl:variable name="name">
					<xsl:call-template name="normalize_fields">
						<xsl:with-param name="field" select="$field"/>
					</xsl:call-template>
				</xsl:variable>
				
				<xsl:variable name="order">
					<xsl:choose>
						<xsl:when test="substring-after($sort, ' ') = 'asc'">Ascending</xsl:when>
						<xsl:when test="substring-after($sort, ' ') = 'desc'">Descending</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<div class="ui-widget ui-state-default ui-corner-all stacked_term">
					<span>
						<b>Sort Category: </b>
						<xsl:value-of select="$name"/>
						<xsl:text>, </xsl:text>
						<xsl:value-of select="$order"/>
					</span>
					
					<a class="ui-icon ui-icon-closethick remove_filter" href="?q={$q}">X</a>
				</div>
			</xsl:if>
			<xsl:if test="string($tokenized_q[3])">
				<div class="ui-widget ui-state-default ui-corner-all stacked_term">
					<a id="clear_all" href="?q=*:*">Clear All Terms</a>
				</div>
			</xsl:if>
		</div>
		
	</xsl:template>

	<xsl:template name="render_categories">
		<xsl:param name="category_fragment"/>

		<xsl:variable name="new_query">
			<xsl:for-each select="$tokenized_q[not(. = $category_fragment)]">
				<xsl:value-of select="."/>
				<xsl:if test="position() != last()">
					<xsl:text> AND </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>

		<div class="stacked_term">
			<span class="term">
				<b>Category: </b>
				<xsl:call-template name="recompile_category">
					<xsl:with-param name="category_fragment" select="$category_fragment"/>
					<xsl:with-param name="tokenized_fragment" select="tokenize(substring-after(replace(replace(replace($category_fragment, '\)', ''), '\(', ''), '\+', ''), 'category_facet:'), ' ')"/>
					<xsl:with-param name="level" as="xs:integer">1</xsl:with-param>
				</xsl:call-template>
			</span>
			<a class="remove_filter" href="?q={if (string($new_query)) then encode-for-uri($new_query) else '*:*'}">X</a>

		</div>
	</xsl:template>

	<xsl:template name="compare_paging">
		<xsl:variable name="start_var" as="xs:integer">
			<xsl:choose>
				<xsl:when test="string($start)">
					<xsl:value-of select="$start"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="next" as="xs:integer">
			<xsl:value-of select="$start_var+$rows"/>
		</xsl:variable>

		<xsl:variable name="previous">
			<xsl:choose>
				<xsl:when test="$start_var &gt;= $rows">
					<xsl:value-of select="$start_var - $rows"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div style="width:100%;display:table;">
			<div style="float:left;"> Results found: <b>
					<xsl:value-of select="$numFound"/>
				</b>. Page: <b>
					<xsl:value-of select="$start_var div $rows + 1"/>
				</b> of <b>
					<xsl:value-of select="ceiling($numFound div $rows)"/>
				</b>
			</div>
			<div style="float:right;">
				<xsl:choose>
					<xsl:when test="$start_var &gt;= $rows">
						<a class="comparepagingBtn" href="compare_results?q={$q}&amp;start={$previous}&amp;image={$image}&amp;side={$side}&amp;mode=compare">« Previous</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>« Previous</xsl:text>
					</xsl:otherwise>
				</xsl:choose> | <xsl:choose>
					<xsl:when test="$numFound - $start_var &gt; $rows">
						<a class="comparepagingBtn" href="compare_results?q={$q}&amp;start={$next}&amp;image={$image}&amp;side={$side}&amp;mode=compare">Next »</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Next »</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
