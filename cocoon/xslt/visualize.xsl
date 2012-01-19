<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
	<xsl:output method="xml" encoding="UTF-8"/>
	<xsl:include href="search_segments.xsl"/>

	<xsl:param name="q"/>
	<xsl:param name="tokenized_q" select="tokenize($q, ' AND ')"/>
	<xsl:param name="category"/>
	<xsl:param name="limit"/>
	<xsl:param name="type"/>
	<xsl:param name="barMargin"/>
	<xsl:param name="barGroupMargin"/>
	<xsl:param name="lineWeight"/>
	<xsl:param name="pieMargin"/>
	<xsl:param name="pieLabelPos"/>
	<xsl:variable name="category_normalized">
		<xsl:call-template name="normalize_fields">
			<xsl:with-param name="field" select="$category"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:template name="visualize">
		<div id="bd">
			<xsl:apply-templates select="/content/response"/>
		</div>
	</xsl:template>
	
	<xsl:template match="response">
		<h1>Visualize</h1>
		<p>Use the data selection and visualization options below to generate a chart based selected parameters. This interface is experimental and only functions in modern
			browsers like Google Chrome, Firefox 3.5+, Opera, and Safari 3+.</p>
		<xsl:call-template name="display_facets"/>
		<a href="results?q={$q}">Return to search results.</a>
		<xsl:choose>
			<xsl:when test="not(string($category)) and not(number($limit))">
				<xsl:call-template name="visualize_options"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$type='pie'">
						<table>
							<caption><xsl:value-of select="$category_normalized"/> Distribution for Query</caption>
							<thead>
								<tr>
									<td/>
									<th>
										<xsl:value-of select="$category_normalized"/>
									</th>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each select="//lst[@name='facet_fields']/lst[@name=$category]/int">
									<tr>
										<th>
											<xsl:choose>
												<xsl:when test="$category='era_sint'">
													<xsl:call-template name="regularize_century">
														<xsl:with-param name="term" select="@name"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@name"/>
												</xsl:otherwise>
											</xsl:choose>
										</th>
										<td>
											<xsl:value-of select="."/>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</xsl:when>
					<xsl:otherwise>
						<table>
							<caption><xsl:value-of select="$category_normalized"/> Distribution for Query</caption>
							<thead>
								<tr>
									<td/>
									<xsl:for-each select="//lst[@name='facet_fields']/lst[@name=$category]/int">
										<th>
											<xsl:choose>
												<xsl:when test="$category='era_sint'">
													<xsl:call-template name="regularize_century">
														<xsl:with-param name="term" select="@name"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@name"/>
												</xsl:otherwise>
											</xsl:choose>
										</th>
									</xsl:for-each>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th> Occurrences per <xsl:value-of select="$category_normalized"/>
									</th>
									<xsl:for-each select="//lst[@name='facet_fields']/lst[@name=$category]/int">
										<td>
											<xsl:value-of select="."/>
										</td>
									</xsl:for-each>
								</tr>
							</tbody>
						</table>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:call-template name="visualize_options"/>
				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="data_selection">
		<h1>Data Selection</h1>
		<fieldset class="typeOptions">
			<!--<xsl:for-each select="tokenize($fields, ',')[not(. = $category)]">-->
			<xsl:for-each select="//lst[@name='facet_fields']/lst[count(int) &gt; 0]">
				<span class="categoryRadio">
					<xsl:choose>
						<xsl:when test="@name=$category">
							<input type="radio" name="category" value="{@name}" checked="checked"/>
						</xsl:when>
						<xsl:otherwise>
							<input type="radio" name="category" value="{@name}"/>
						</xsl:otherwise>
					</xsl:choose>

					<label for="{@name}" class="radio">
						<xsl:call-template name="normalize_fields">
							<xsl:with-param name="field" select="@name"/>
						</xsl:call-template>
					</label>
				</span>
			</xsl:for-each>
		</fieldset>
		<select name="limit">
			<xsl:choose>
				<xsl:when test="number($limit) = 2">
					<option selected="selected">2</option>
				</xsl:when>
				<xsl:otherwise>
					<option>2</option>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="number($limit) = 3">
					<option selected="selected">3</option>
				</xsl:when>
				<xsl:otherwise>
					<option>3</option>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="number($limit) = 4">
					<option selected="selected">4</option>
				</xsl:when>
				<xsl:otherwise>
					<option>4</option>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="number($limit) = 5">
					<option selected="selected">5</option>
				</xsl:when>
				<xsl:otherwise>
					<option>5</option>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="number($limit) = 6">
					<option selected="selected">6</option>
				</xsl:when>
				<xsl:otherwise>
					<option>6</option>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="number($limit) = 7">
					<option selected="selected">7</option>
				</xsl:when>
				<xsl:otherwise>
					<option>7</option>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="number($limit) = 8">
					<option selected="selected">8</option>
				</xsl:when>
				<xsl:otherwise>
					<option>8</option>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="number($limit) = 9">
					<option selected="selected">9</option>
				</xsl:when>
				<xsl:otherwise>
					<option>9</option>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="number($limit) = 10">
					<option selected="selected">10</option>
				</xsl:when>
				<xsl:otherwise>
					<option>10</option>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="number($limit) = 11">
					<option selected="selected">11</option>
				</xsl:when>
				<xsl:otherwise>
					<option>11</option>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="number($limit) = 12">
					<option selected="selected">12</option>
				</xsl:when>
				<xsl:otherwise>
					<option>12</option>
				</xsl:otherwise>
			</xsl:choose>
		</select>
		<label for="limit">Columns/Slices</label>
	</xsl:template>

	<xsl:template name="visualize_options">
		<div style="display:table;width:100%;margin-top:40px">
		<form class="chartConfigurator">
			<!-- display data select template -->
			<xsl:call-template name="data_selection"/>

			<h1>Visualization Options:</h1>
			<fieldset class="typeOptions">
				<div class="fieldGroup">
					<xsl:choose>
						<xsl:when test="$type='bar'">
							<input type="radio" name="type" id="bar" value="bar" checked="checked"/>
						</xsl:when>
						<xsl:otherwise>
							<input type="radio" name="type" id="bar" value="bar"/>
						</xsl:otherwise>
					</xsl:choose>


					<label for="bar" class="radio">Bar</label>
					<div class="dependencies{if ($type='bar') then '' else ' hidden'}">
						<div class="fieldGroup">
							<label for="barMargin">barMargin:</label>
							<xsl:choose>
								<xsl:when test="$type='bar'">
									<input type="text" name="barMargin" id="barMargin" value="{$barMargin}"/>
								</xsl:when>
								<xsl:otherwise>
									<input type="text" name="barMargin" id="barMargin" value="1" disabled="disabled"/>
								</xsl:otherwise>
							</xsl:choose>
						</div>
						<div class="fieldGroup">
							<label for="barGroupMargin">barGroupMargin:</label>
							<xsl:choose>
								<xsl:when test="$type='bar'">
									<input type="text" name="barGroupMargin" id="barGroupMargin" value="{$barGroupMargin}"/>
								</xsl:when>
								<xsl:otherwise>
									<input type="text" name="barGroupMargin" id="barGroupMargin" value="10" disabled="disabled"/>
								</xsl:otherwise>
							</xsl:choose>
						</div>
					</div>
				</div>
				<div class="fieldGroup">
					<xsl:choose>
						<xsl:when test="$type='line'">
							<input type="radio" name="type" id="line" value="line" checked="checked"/>
						</xsl:when>
						<xsl:otherwise>
							<input type="radio" name="type" id="line" value="line"/>
						</xsl:otherwise>
					</xsl:choose>
					<label for="line" class="radio">Line</label>
					<div class="dependencies{if ($type='line') then '' else ' hidden'}">

						<div class="fieldGroup">
							<label for="lineWeight">lineWeight</label>
							<xsl:choose>
								<xsl:when test="$type='line'">
									<input type="text" name="lineWeight" id="lineWeight" value="{$lineWeight}"/>
								</xsl:when>
								<xsl:otherwise>
									<input type="text" name="lineWeight" id="lineWeight" value="4" disabled="disabled"/>
								</xsl:otherwise>
							</xsl:choose>

						</div>
					</div>
				</div>
				<div class="fieldGroup">
					<xsl:choose>
						<xsl:when test="$type='area'">
							<input type="radio" name="type" id="area" value="area" checked="checked"/>
						</xsl:when>
						<xsl:otherwise>
							<input type="radio" name="type" id="area" value="area"/>
						</xsl:otherwise>
					</xsl:choose>

					<label for="area" class="radio">Area</label>
					<div class="dependencies{if ($type='area') then '' else ' hidden'}">
						<div class="fieldGroup">
							<label for="lineWeight">lineWeight</label>
							<xsl:choose>
								<xsl:when test="$type='area'">
									<input type="text" name="lineWeight" id="lineWeight" value="{$lineWeight}"/>
								</xsl:when>
								<xsl:otherwise>
									<input type="text" name="lineWeight" id="lineWeight" value="4" disabled="disabled"/>
								</xsl:otherwise>
							</xsl:choose>
						</div>
					</div>
				</div>

				<div class="fieldGroup">
					<xsl:choose>
						<xsl:when test="$type='pie'">
							<input type="radio" name="type" id="pie" value="pie" checked="checked"/>
						</xsl:when>
						<xsl:otherwise>
							<input type="radio" name="type" id="pie" value="pie"/>
						</xsl:otherwise>
					</xsl:choose>
					<label for="pie" class="radio">Pie</label>
					<div class="dependencies{if ($type='pie') then '' else ' hidden'}">
						<div class="fieldGroup">
							<label for="pieMargin">pieMargin</label>
							<xsl:choose>
								<xsl:when test="$type='pie'">
									<input type="text" name="pieMargin" id="pieMargin" value="{$pieMargin}"/>
								</xsl:when>
								<xsl:otherwise>
									<input type="text" name="pieMargin" id="pieMargin" value="20" disabled="disabled"/>
								</xsl:otherwise>
							</xsl:choose>
						</div>

						<div class="fieldGroup">
							<label for="pieLabelPos">pieLabelPos:</label>
							<xsl:choose>
								<xsl:when test="$type='pie'">
									<select name="pieLabelPos" id="pieLabelPos">
										<xsl:choose>
											<xsl:when test="$pieLabelPos = 'inside'">
												<option value="inside" selected="selected">inside</option>
												<option value="outside">outside</option>
											</xsl:when>
											<xsl:when test="$pieLabelPos = 'outside'">
												<option value="inside">inside</option>
												<option value="outside" selected="selected">outside</option>
											</xsl:when>
										</xsl:choose>

									</select>
								</xsl:when>
								<xsl:otherwise>
									<select name="pieLabelPos" id="pieLabelPos" disabled="disabled">
										<option value="inside">inside</option>
										<option value="outside">outside</option>
									</select>
								</xsl:otherwise>
							</xsl:choose>

						</div>

					</div>
				</div>
			</fieldset>
			<input type="hidden" name="q" value="{$q}"/>
			<input type="submit" action="visualize" value="Modify Chart"/>
		</form>
		</div>
	</xsl:template>

	<xsl:template name="display_facets">
		<div class="remove_facets">

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
							<span class="term">
								<b><xsl:value-of select="$name"/>: </b>
								<xsl:choose>
									<xsl:when test="$field = 'era_sint'">
										<xsl:call-template name="regularize_century">
											<xsl:with-param name="term" select="$term"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$term"/>
									</xsl:otherwise>
								</xsl:choose>
							</span>
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
							<span class="term">
								<xsl:if test="$multifields != 'true'">
									<b><xsl:value-of select="$name"/>: </b>
								</xsl:if>
								<xsl:for-each select="$tokenized-fragments">
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
										<xsl:when test="$field = 'era_sint'">
											<xsl:call-template name="regularize_century">
												<xsl:with-param name="term" select="$term"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$term"/>
										</xsl:otherwise>
									</xsl:choose>

									<xsl:if test="position() != last()">
										<xsl:text> OR </xsl:text>
									</xsl:if>
								</xsl:for-each>
							</span>
						</div>
					</xsl:when>
					<xsl:when test="not(contains(., ':'))">
						<div class="ui-widget ui-state-default ui-corner-all stacked_term">
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
									<xsl:if test="not(position() = last())">
										<xsl:text> OR </xsl:text>
									</xsl:if>
								</xsl:for-each>
							</span>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="render_categories">
							<xsl:with-param name="category_fragment" select="$category_query"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
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

		<div class="ui-widget ui-state-default ui-corner-all stacked_term">
			<span class="term">
				<b>Category: </b>
				<xsl:call-template name="recompile_category">
					<xsl:with-param name="category_fragment" select="$category_fragment"/>
					<xsl:with-param name="tokenized_fragment" select="tokenize(substring-after(replace(replace(replace($category_fragment, '\)', ''), '\(', ''), '\+', ''), 'category_facet:'), ' ')"/>
					<xsl:with-param name="level" as="xs:integer">1</xsl:with-param>
				</xsl:call-template>
			</span>
		</div>
	</xsl:template>

</xsl:stylesheet>
