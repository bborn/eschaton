// provides pure javascript that is further metafied by eschaton

// Draw a clean circle! Modified copy from http://esa.ilmari.googlepages.com/circle.htm
function drawCircle(center, radius, nodes, liColor, liWidth, liOpa, fillColor, fillOpa){
	//calculating km/degree
	var latConv = center.distanceFrom(new GLatLng(center.lat() +0.1, center.lng()))/100;
	var lngConv = center.distanceFrom(new GLatLng(center.lat(), center.lng()+0.1))/100;

	//Loop 
	var points = [];
	var step = parseInt(360/nodes);
	for(var i=0; i<=360; i+=step){
  	var pint = new GLatLng(center.lat() + (radius/latConv * Math.cos(i * Math.PI/180)), center.lng() + 
	                        (radius/lngConv * Math.sin(i * Math.PI/180)));
	  points.push(pint);
	
	  if (track_bounds){
	    track_bounds.extend(pint);
	  }
	}

	var poly = new GPolygon(points, liColor, liWidth, liOpa, fillColor, fillOpa);
	map.addOverlay(poly);
	
	return poly;
}

// Add some tooltip functionality to GMarker
GMarker.prototype.setTooltip = function(html){
  this.tooltip_element = document.createElement('div');
	
	this.hideTooltip();
	
	var default_style = 'border: #8B8B8B solid 1px; background: white; padding-left: 5px; padding-right: 5px; padding-top: 5px; padding-bottom: 3px; opacity: 0.9; -moz-opacity: 0.9; filter:alpha(opacity=90);'
  this.tooltip_element.innerHTML = '<div style="' + default_style + '" class="tooltip">'+ html +'</div>';

	var point = map.getCurrentMapType().getProjection().fromLatLngToPixel(map.getBounds().getSouthWest(), map.getZoom());
	var offset = map.getCurrentMapType().getProjection().fromLatLngToPixel(this.getPoint(), map.getZoom());
	var anchor = this.getIcon().iconAnchor;
	var width = this.getIcon().iconSize.width;
	var pos = new GControlPosition(G_ANCHOR_BOTTOM_LEFT, new GSize(offset.x - point.x - anchor.x + width,- offset.y + point.y + anchor.y)); 
	pos.apply(this.tooltip_element);

  document.getElementById('map').appendChild(this.tooltip_element);
}

GMarker.prototype.showTooltip = function(){
	this.tooltip_element.style.visibility = 'visible';
}

GMarker.prototype.hideTooltip = function(){
	this.tooltip_element.style.visibility = 'hidden';
}

GMarker.prototype.toggleTooltip = function(){
	if (this.tooltip_element.style.visibility == 'visible'){
	  this.hideTooltip();
	} else {
	  this.showTooltip();	  
	}
}