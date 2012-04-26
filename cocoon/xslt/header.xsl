<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" version="2.0">
	<xsl:template name="header">
		<!-- if displaying a coin or artifact record, the path to the other sections should be ../../ ; otherwise nothing -->
		<div id="hd">
			<div class="banner align-right">
				<xsl:if test="string(/content/config/banner_text)">
					<div class="banner_text">
						<xsl:value-of select="/content/config/banner_text"/>
					</div>
				</xsl:if>
				<xsl:if test="string(//config/banner_image/@xlink:href)">
					<img src="{$display_path}images/{//config/banner_image/@xlink:href}" alt="banner image"/>
				</xsl:if>
			</div>
			<ul role="menubar" id="menu" class="menubar ui-menubar ui-widget-header ui-helper-clearfix">
				<li role="presentation" class="ui-menubar-item">
					<a aria-haspopup="true" role="menuitem" class="ui-button ui-widget ui-button-text-only ui-menubar-link" tabindex="-1" href="{$display_path}.">
						<span class="ui-button-text">Home</span>
					</a>
				</li>

				<li role="presentation" class="ui-menubar-item">
					<a aria-haspopup="true" role="menuitem" class="ui-button ui-widget ui-button-text-only ui-menubar-link" tabindex="-1" href="{$display_path}results?q=*:*">
						<span class="ui-button-text">Browse</span>
					</a>
				</li>
				<li role="presentation" class="ui-menubar-item">
					<a aria-haspopup="true" role="menuitem" class="ui-button ui-widget ui-button-text-only ui-menubar-link" tabindex="-1" href="{$display_path}search">
						<span class="ui-button-text">Search</span>
					</a>
				</li>
				<li role="presentation" class="ui-menubar-item">
					<a aria-haspopup="true" role="menuitem" class="ui-button ui-widget ui-button-text-only ui-menubar-link" tabindex="-1" href="{$display_path}maps">
						<span class="ui-button-text">Maps</span>
					</a>
				</li>
				<xsl:if test="//config/compare_enabled= true()">
					<li role="presentation" class="ui-menubar-item">
						<a aria-haspopup="true" role="menuitem" class="ui-button ui-widget ui-button-text-only ui-menubar-link" tabindex="-1" href="{$display_path}compare">
							<span class="ui-button-text">Compare</span>
						</a>
					</li>
				</xsl:if>
				
				<xsl:for-each select="//config/pages/page[public = '1']">
					<li role="presentation" class="ui-menubar-item">
						<a aria-haspopup="true" role="menuitem" class="ui-button ui-widget ui-button-text-only ui-menubar-link" href="{$display_path}pages/{@stub}">
							<span class="ui-button-text">
								<xsl:value-of select="short-title"/>
							</span>
						</a>
					</li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>
</xsl:stylesheet>
