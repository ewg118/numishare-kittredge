<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" version="2.0">	
	
	<xsl:template name="index">
		<div id="bd">
			<div id="yui-main">
				<div class="yui-b">
					<xsl:copy-of select="saxon:parse(concat('&lt;div&gt;', string(//pages/index), '&lt;/div&gt;'))"/>
				</div>
			</div>
			<div class="yui-b" id="numishare-widget">
				<div id="linked_data">
					<div class="ui-widget-header ui-helper-clearfix ui-corner-all">Linked Data</div>
					<a href="{$display_path}rdf/">
						<img src="{$display_path}images/rdf-large.gif" title="RDF" alt="PDF"/>
					</a>
					<a href="{$display_path}feed/?q=*:*">
						<img src="{$display_path}images/atom-large.png" title="Atom" alt="Atom"/>
					</a>
				</div>
				<div id="feature">
					<div class="ui-widget-header ui-helper-clearfix ui-corner-all">Featured Object</div>
				</div>
				
			</div>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
