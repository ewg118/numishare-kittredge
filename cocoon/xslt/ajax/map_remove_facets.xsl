<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:numishare="http://code.google.com/p/numishare/" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="numishare xs" version="2.0">
	<xsl:include href="../search_segments.xsl"/>
	<xsl:param name="q"/>
	<xsl:param name="tokenized_q" select="tokenize($q, ' AND ')"/>

	<xsl:template match="/">
		<xsl:call-template name="remove_facets"/>
	</xsl:template>

	<xsl:template name="remove_facets">
		<xsl:for-each select="$tokenized_q[not(contains(., 'category_facet')) and not(contains(., 'department_facet'))]">
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
				<xsl:when test="contains(., ':') and not(. = '*:*') and not(contains(., '('))">
					<xsl:variable name="field" select="substring-before(., ':')"/>
					<xsl:variable name="name">
						<xsl:value-of select="numishare:normalize_fields($field)"/>
					</xsl:variable>
					<xsl:variable name="term" select="replace(substring-after(., ':'), '&#x022;', '')"/>

					<div class="ui-widget ui-state-default ui-corner-all stacked_term">
						<span>
							<b><xsl:value-of select="$name"/>: </b>
							<xsl:choose>
								<xsl:when test="$field = 'century_num'">
									<xsl:value-of select="numishare:normalize_century(@name)"/>
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
				<xsl:when test="contains(., '(')">
					<xsl:variable name="tokenized-fragments" select="tokenize(substring-after(substring-before(., ')'), '('), ' OR ')"/>
					<xsl:variable name="field" select="substring-before($tokenized-fragments[1], ':')"/>
					<xsl:variable name="name">
						<xsl:value-of select="numishare:normalize_fields($field)"/>
					</xsl:variable>
					<div class="ui-widget ui-state-default ui-corner-all stacked_term">
						<span>
							<b><xsl:value-of select="$name"/>: </b>
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

								<xsl:variable name="term" select="replace(substring-after(., ':'), '&#x022;', '')"/>
								<xsl:value-of select="$term"/>
								<xsl:text>[</xsl:text>
								<a href="?q={encode-for-uri(concat($new_query, ' AND ', $multicategory_query))}">X</a>
								<xsl:text>]</xsl:text>
								<xsl:if test="position() != last()">
									<xsl:text> OR </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</span>
						<a class="ui-icon ui-icon-closethick remove_filter" href="?q={if (string($new_query)) then encode-for-uri($new_query) else '*:*'}">X</a>

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
						<span>
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
								<a href="?q={encode-for-uri(concat($new_query, ' AND ', $multicategory_query))}">X</a>
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

		<xsl:if test="string($tokenized_q[2])">
			<div class="ui-widget ui-state-default ui-corner-all stacked_term">
				<a id="clear_terms" href="#">Clear All Terms</a>
			</div>
		</xsl:if>
	</xsl:template>

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
			<span class="remove_filter" href="?q={if (string($new_query)) then encode-for-uri($new_query) else '*:*'}">X</span>

		</div>
	</xsl:template>
</xsl:stylesheet>
