// provides pure javascript that is further metafied by eschaton

// Draw a clean circle! Modified copy from http://esa.ilmari.googlepages.com/circle.htm
function drawCircle(center, radius, nodes, liColor, liWidth, liOpa, fillColor, fillOpa){
	//calculating km/degree
	var latConv = center.distanceFrom(new GLatLng(center.lat() +0.1, center.lng()))/100;
	var lngConv = center.distanceFrom(new GLatLng(center.lat(), center.lng()+0.1))/100;

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

/* Modified by yawningman to work with eschaton
 * For original see  http://onemarco.com/2007/05/16/custom-tooltips-for-google-maps/ 
 *
 * Original Author =  Marco Alionso Ramirez, marco@onemarco.com
 */
function Tooltip(base_type, base, html, css_class, padding){
  this.base_type_ = base_type;
	this.base_ = base;
	this.html_ = html;
	this.padding_ = padding;

	var div = document.createElement("div");
	div.innerHTML = this.html_;
	div.className = css_class;
	div.style.position = 'absolute';
	div.style.visibility = 'hidden';
	
	this.div_ = div;	
}

Tooltip.prototype = new GOverlay();

Tooltip.prototype.initialize = function(map){
	map.getPane(G_MAP_FLOAT_PANE).appendChild(this.div_);
	this.map_ = map;
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
	return new Tooltip(this.base_,this.html_,this.padding_);
}

Tooltip.prototype.redraw = function(force){
	if (!force) return;
  if(this.base_type_ == 'google::marker'){
    this.redraw_for_marker();
  } else if(this.base_type_ == 'google::polygon'){
    this.redraw_for_polygon();
  } else if(this.base_type_ == 'google::line'){
    this.redraw_for_line();
  } else { // fall through for custom markers
    this.redraw_for_marker();    
  }
}

Tooltip.prototype.redraw_for_marker = function(){
	var markerPos = this.map_.fromLatLngToDivPixel(this.base_.getLatLng());
	var iconAnchor = this.base_.getIcon().iconAnchor;

	var xPos = Math.round(markerPos.x - this.div_.clientWidth / 2);
	var yPos = markerPos.y - iconAnchor.y - this.div_.clientHeight - this.padding_;

	this.position_div(xPos, yPos)
}

Tooltip.prototype.redraw_for_polygon = function(){
	var markerPos = this.map_.fromLatLngToDivPixel(this.base_.getBounds().getCenter());
	
	var xPos = Math.round(markerPos.x - this.div_.clientWidth / 2);
	var yPos = markerPos.y - this.div_.clientHeight - this.padding_;

	this.position_div(xPos, yPos)
}

Tooltip.prototype.redraw_for_line = function(){
  mid_vertex_index = Math.round(this.base_.getVertexCount() / 2);
	var markerPos = this.map_.fromLatLngToDivPixel(this.base_.getVertex(mid_vertex_index));
	
	var xPos = Math.round(markerPos.x - this.div_.clientWidth / 2);
	var yPos = markerPos.y - this.div_.clientHeight - this.padding_;

	this.position_div(xPos, yPos)
}

Tooltip.prototype.position_div = function(x, y){
	this.div_.style.left = x + 'px';  
	this.div_.style.top = y + 'px';
}

Tooltip.prototype.show = function(){
	this.div_.style.visibility = 'visible';
}

Tooltip.prototype.hide = function(){
	this.div_.style.visibility = 'hidden';
}
/* end tooltip */

/* GooglePane - A simple pane for google maps
   by yawningman */
function GooglePane(options){
  this.default_position = options['position']

  this.panel = document.createElement('div');
  this.panel.id = options['id'];
  this.panel.className = options['cssClass']
  this.panel.innerHTML = options['text']
}

GooglePane.prototype = new GControl;
GooglePane.prototype.initialize = function(map) {
  map.getContainer().appendChild(this.panel);

  return this.panel;
};

GooglePane.prototype.getDefaultPosition = function() {
  return this.default_position;
};

/* end pane */