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

/**
 * Modified by yawningman to work with eschaton
 * For original see  http://onemarco.com/2007/05/16/custom-tooltips-for-google-maps/ 
 *
 * @author Marco Alionso Ramirez, marco@onemarco.com
 * @version 1.0
 * The Tooltip class is an addon designed for the Google
 * Maps GMarker class.
 */

/**
 * @constructor
 * @param {GMarker} marker
 * @param {String} html
 * @param {Number} padding
 */
function Tooltip(marker, html, padding){
	this.marker_ = marker;
	this.html_ = html;
	this.padding_ = padding;
}

Tooltip.prototype = new GOverlay();

Tooltip.prototype.initialize = function(map){
	var div = document.createElement("div");
	div.innerHTML = this.html_
	div.className = 'tooltip';
	div.style.position = 'absolute';
	div.style.visibility = 'hidden';
	map.getPane(G_MAP_FLOAT_PANE).appendChild(div);
	this.map_ = map;
	this.div_ = div;
}

Tooltip.prototype.updateHtml = function(html){
  this.div_.innerHTML = html;
  this.redraw(true);  
}

Tooltip.prototype.markerPickedUp = function(){
  this.previous_padding = this.padding_
  this.padding_ = 20;
}

Tooltip.prototype.markerDropped = function(){
  this.padding_ = this.previous_padding;
  this.redraw(true);
}

Tooltip.prototype.remove = function(){
	this.div_.parentNode.removeChild(this.div_);
}

Tooltip.prototype.copy = function(){
	return new Tooltip(this.marker_,this.html_,this.padding_);
}

Tooltip.prototype.redraw = function(force){
	if (!force) return;
	var markerPos = this.map_.fromLatLngToDivPixel(this.marker_.getPoint());
	var iconAnchor = this.marker_.getIcon().iconAnchor;
	var xPos = Math.round(markerPos.x - this.div_.clientWidth / 2);
	var yPos = markerPos.y - iconAnchor.y - this.div_.clientHeight - this.padding_;
	this.div_.style.top = yPos + 'px';
	this.div_.style.left = xPos + 'px';
}

Tooltip.prototype.show = function(){
	this.div_.style.visibility = 'visible';
}

Tooltip.prototype.hide = function(){
	this.div_.style.visibility = 'hidden';
}
/* end tooltip */