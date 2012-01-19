function display_terrain(){
	map = new OpenLayers.Map('basicMap', {
                    controls: [
                        new OpenLayers.Control.PanZoomBar(),
                        new OpenLayers.Control.Navigation(),
                        new OpenLayers.Control.ScaleLine()
                    ]
	});
	map.addLayer(new OpenLayers.Layer.Google("Google Physical", {type: google.maps.MapTypeId.TERRAIN}));
	map.zoomTo('1');
}

function initialize_map(q) {
	map = new OpenLayers.Map('basicMap', {
                    controls: [
                        new OpenLayers.Control.PanZoomBar(),
                        new OpenLayers.Control.Navigation(),
                        new OpenLayers.Control.ScaleLine()
                    ]
	});
	
                var styleMap = new OpenLayers.Style({
                    pointRadius: "${radius}",
                    fillColor: "#ffcc66",
                    fillOpacity: 0.8,
                    strokeColor: "#cc6633",
                    strokeWidth: 2,
                    strokeOpacity: 0.8
                }, {
                    context: {
                        radius: function(feature) {
                            return Math.min(feature.attributes.count, 7) + 3;
                        }
                    }
                });
	map.addLayer(new OpenLayers.Layer.Google("Google Physical", {type: google.maps.MapTypeId.TERRAIN}));
	var kmlLayer = new OpenLayers.Layer.Vector("KML", {
	 	styleMap: styleMap,
	 	
	 	eventListeners: {'loadend': kmlLoaded },
		strategies: [
				new OpenLayers.Strategy.Fixed(),
				new OpenLayers.Strategy.Cluster()
			],
		protocol: new OpenLayers.Protocol.HTTP({
	                url: "mints.kml?q=" + q,
	                format: new OpenLayers.Format.KML({
	                    extractStyles: false, 
	                    extractAttributes: true
	                })
	            })
	});
	map.addLayer(kmlLayer);

	function kmlLoaded(){
		map.zoomToExtent(kmlLayer.getDataExtent());
		if (q == '*:*'){
			map.zoomTo('2');
		} else {
			map.zoomTo('4');
		}
		
	}
	
	selectControl = new OpenLayers.Control.SelectFeature(
                [kmlLayer],
                {
                    clickout: true, 
                    multiple: false, 
                    hover: false
                }
            );
	
	map.addControl(selectControl);
	selectControl.activate();
	kmlLayer.events.on({"featureselected": onFeatureSelect, "featureunselected": onFeatureUnselect});
     
	function onPopupClose(evt) {		
		map.removePopup(map.popups[0]);
	}
	
	function onFeatureSelect(event) {
		var message = '';
		var mint_uris = new Array();
		var mint_names = new Array();
		if (event.feature.cluster.length > 12){
			message = '<div style="font-size:10px">'+ event.feature.cluster.length + ' mints found at this location';	
			for (var i in event.feature.cluster) {
				mint_uris.push(event.feature.cluster[i].attributes['description']);
				mint_names.push(event.feature.cluster[i].attributes['name']);
			}
		}
		else if (event.feature.cluster.length > 1 && event.feature.cluster.length <= 12){
			message = '<div style="font-size:10px;width:300px;">'+ event.feature.cluster.length + ' mints found at this location: ';
			for (var i in event.feature.cluster) {
				mint_uris.push(event.feature.cluster[i].attributes['description']);
				mint_names.push(event.feature.cluster[i].attributes['name']);
				message += event.feature.cluster[i].attributes['name'];
				if (i < event.feature.cluster.length - 1){
					message += ', ';
				}		
			}			
		} else if (event.feature.cluster.length == 1) {
			mint_uris.push(event.feature.cluster[0].attributes['description']);
			mint_names.push(event.feature.cluster[0].attributes['name']);
			message =  '<div style="font-size:10px">Mint of ' + event.feature.cluster[0].attributes['name'];
		}	
		
		//assemble the mint query
		var mint_query = '';
		if (event.feature.cluster.length >1 ){
			mint_query += '(';
			for (var i in mint_uris){
				mint_query += 'mint_uri:"' + mint_uris[i] + '"';
				if (i < mint_uris.length - 1){
					mint_query += ' OR ';
				}	
			}
			mint_query += ')';
		} else {
			mint_query = 'mint_uri:"' + mint_uris[0] + '"';
		}
		mint_query += ' AND ';
		if (event.feature.cluster.length >1 ){
			mint_query += '(';
			for (var i in mint_names){
				mint_query += 'mint_facet:"' + mint_names[i] + '"';
				if (i < mint_uris.length - 1){
					mint_query += ' OR ';
				}	
			}
			mint_query += ')';
		} else {
			mint_query += 'mint_facet:"' + mint_names[0] + '"';
		}		
		var query = q + ' AND ' + mint_query;
		
		message += '.<br/><br/>';
		message += "<a href='#results' class='show_coins' q='" + query + "'>View</a> coins that meet the search criteria from " + (event.feature.cluster.length > 1 ? 'these mints' : 'this mint') + " [<a href='#results' class='show_coins' q='" + query + " AND imagesavailable:true'>with images</a>]" + ' (results below map).';
		message += '</div>';
		
		popup = new OpenLayers.Popup.FramedCloud("id", event.feature.geometry.bounds.getCenterLonLat(), null, message, null, true, onPopupClose);
		event.popup = popup;
		map.addPopup(popup);
		
		$('.show_coins').livequery('click', function(event) {
			query = $(this).attr('q');
			$.get('results_ajax', {
				q: query
			},
			function (data) {
				$('#results') .html(data);
			});
			return false;			
		});
	}
	
	function onFeatureUnselect(event) {
		map.removePopup(map.popups[0]);
	}     

}
