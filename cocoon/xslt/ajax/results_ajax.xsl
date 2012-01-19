<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:include href="../search_segments.xsl"/>
	<xsl:include href="../results_generic.xsl"/>	
	<xsl:param name="display_path">
		<xsl:text/>
	</xsl:param>

	<xsl:param name="q"/>
	<xsl:param name="sort"/>
	<xsl:param name="rows">24</xsl:param>
	<xsl:param name="start"/>
	<xsl:param name="tokenized_q" select="tokenize($q, ' AND ')"/>

	<xsl:template match="/">
		<xsl:variable name="mint_string" select="replace(translate($tokenized_q[contains(., 'mint_facet')], '&#x022;()', ''), 'mint_facet:', '')"/>
		<xsl:variable name="mints" select="tokenize($mint_string, ' OR ')"/>
		<h1>
			<xsl:text>Mint</xsl:text>
			<xsl:if test="contains($mint_string, ' OR ')">
				<xsl:text>s</xsl:text>
			</xsl:if>
			<xsl:text>: </xsl:text>
			<xsl:for-each select="$mints">
				<xsl:value-of select="."/>
				<xsl:if test="not(position() = last())">
					<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:for-each>
			<a id="clear_coins" href="#">clear</a>
		</h1>
		<xsl:call-template name="paging"/>
		<!--<xsl:call-template name="sort"/>-->
		<div style="display:table;width:100%;">
			<xsl:apply-templates select="descendant::doc" mode="map"/>
		</div>
		<xsl:call-template name="paging"/>
	</xsl:template>

	<xsl:template match="doc" mode="map">
		<xsl:variable name="sort_category" select="substring-before($sort, ' ')"/>
		<xsl:variable name="regularized_sort">
			<xsl:call-template name="normalize_fields">
				<xsl:with-param name="field" select="$sort_category"/>
			</xsl:call-template>
		</xsl:variable>

		<div class="g_doc">
			<span class="result_link">
				<a href="display/{str[@name='id']}" target="_blank">
					<xsl:value-of select="str[@name='title_display']"/>
				</a>
			</span>
			<xsl:if test="str[@name='imagesavailable']">
				<div class="gi_c">
					<a href="{str[@name='reference_obv']}" class="thumbImage">
						<xsl:if test="str[@name='thumbnail_obv']">
							<img class="gi" src="{str[@name='thumbnail_obv']}"/>
						</xsl:if>
					</a>
					<a href="{str[@name='reference_rev']}" class="thumbImage">
						<xsl:if test="str[@name='thumbnail_rev']">
							<img class="gi" src="{str[@name='thumbnail_rev']}"/>
						</xsl:if>
					</a>
				</div>

			</xsl:if>
			<dl>
				<xsl:if test="str[@name='obv_leg_display'] or str[@name='obv_type_display']">
					<div>
						<dt>Obverse:</dt>
						<dd style="margin-left:125px;">
							<xsl:value-of
								select="if (string-length(str[@name='obv_type_display']) &gt; 30) then concat(substring(str[@name='obv_type_display'], 1, 30), '...') else str[@name='obv_type_display']"/>
							<xsl:if test="str[@name='obv_leg_display'] and str[@name='obv_type_display']">
								<xsl:text>: </xsl:text>
							</xsl:if>
							<xsl:value-of
								select="if (string-length(str[@name='obv_leg_display']) &gt; 30) then concat(substring(str[@name='obv_leg_display'], 1, 30), '...') else str[@name='obv_leg_display']"
							/>
						</dd>
					</div>
				</xsl:if>
				<xsl:if test="str[@name='rev_leg_display'] or str[@name='rev_type_display']">
					<div>
						<dt>Reverse:</dt>
						<dd style="margin-left:125px;">
							<xsl:value-of
								select="if (string-length(str[@name='rev_type_display']) &gt; 30) then concat(substring(str[@name='rev_type_display'], 1, 30), '...') else str[@name='rev_type_display']"/>
							<xsl:if test="str[@name='rev_leg_display'] and str[@name='rev_type_display']">
								<xsl:text>: </xsl:text>
							</xsl:if>
							<xsl:value-of
								select="if (string-length(str[@name='rev_leg_display']) &gt; 30) then concat(substring(str[@name='rev_leg_display'], 1, 30), '...') else str[@name='rev_leg_display']"
							/>
						</dd>
					</div>
				</xsl:if>
				<xsl:if test="arr[@name='weight_num']/float">
					<div>
						<dt>Weight: </dt>
						<dd style="margin-left:150px;">
							<xsl:for-each select="arr[@name='weight_num']/float">
								<xsl:value-of select="."/>
								<xsl:text> grams</xsl:text>
								<xsl:if test="not(position() = last())">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</dd>
					</div>
				</xsl:if>
				<xsl:if test="arr[@name='dimensions_display']">
					<div>
						<dt>Measurements: </dt>
						<dd style="margin-left:150px;">
							<xsl:for-each select="arr[@name='dimensions_display']/str">
								<xsl:value-of select="."/>
								<xsl:text> mm</xsl:text>
								<xsl:if test="not(position() = last())">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</dd>
					</div>
				</xsl:if>
				<xsl:if test="string(arr[@name='department_facet']/str[1])">
					<div>
						<dt>Department: </dt>
						<dd style="margin-left:125px;">
							<xsl:for-each select="arr[@name='department_facet']/str">
								<xsl:value-of select="."/>
								<xsl:if test="not(position() = last())">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</dd>
					</div>
				</xsl:if>
				<xsl:if test="arr[@name='reference_display']">
					<div>
						<dt>Reference(s): </dt>
						<dd style="margin-left:125px;">
							<xsl:for-each select="arr[@name='reference_display']/str">
								<xsl:value-of select="."/>
								<xsl:if test="not(position() = last())">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</dd>
					</div>
				</xsl:if>
				<xsl:if test="string(str[@name='imagesponsor_display'])">
					<div>
						<dt>Image Sponsor:</dt>
						<dd style="margin-left:125px;">
							<xsl:value-of select="str[@name='imagesponsor_display']"/>
						</dd>
					</div>
				</xsl:if>
			</dl>
		</div>
	</xsl:template>

</xsl:stylesheet>
