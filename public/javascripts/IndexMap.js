var map, baseLayer, markers, lineLayer;
  var cities = new Object();
  cities['Radom'] = "21.15, 51.40";
  cities['Gdansk'] = "18.633333,54.366667";
  cities['Olsztyn'] = "20.55,53.783333";
  cities['Szczecin'] = "14.542222, 53.438056";
  cities['Ciechanow'] = "20.608056,52.876111";
  cities['Warsaw'] = "21.008333, 52.232222";
  var fromProjection = new OpenLayers.Projection("EPSG:4326");   // Transform from WGS 1984
  var toProjection   = new OpenLayers.Projection("EPSG:900913"); // to Spherical Mercator Projection

function init()
{
  map = new OpenLayers.Map('map');
  baseLayer = new OpenLayers.Layer.OSM();
  map.addLayer(baseLayer);
  var position = new OpenLayers.LonLat(19.00,52.00).transform( fromProjection, toProjection)
  map.setCenter(position,6);
  markers = new OpenLayers.Layer.Markers("Cities");
  map.addLayer(markers);
  lineLayer = new OpenLayers.Layer.Vector("Line Layer");
	map.addLayer(lineLayer);
	map.addControl(new OpenLayers.Control.DrawFeature(lineLayer, OpenLayers.Handler.Path));
}

function jumpTo()
{
  markers.clearMarkers();
  var selectBox = document.getElementById('ticket_cityFrom');
  if (selectBox.value == "") return;
  var locationPlace = cities[selectBox.value]
  var location = marker(locationPlace, "images/marker.png");//function to place a marker on map with specific icon.
  selectBox = document.getElementById('ticket_cityTo');
  if (selectBox.value == "") return;
  locationPlace = cities[selectBox.value]
  var location2 = marker(locationPlace, "images/marker2.png")

	lineLayer.removeAllFeatures();
	var points = new Array
	(
   new OpenLayers.Geometry.Point(location.lon, location.lat),
   new OpenLayers.Geometry.Point(location2.lon, location2.lat)
	);

	var line = new OpenLayers.Geometry.LineString(points);

	var style = {
		strokeColor: '#0000ff',
		strokeOpacity: 0.5,
		strokeWidth: 5
	};

	var lineFeature = new OpenLayers.Feature.Vector(line, null, style);
	lineLayer.addFeatures([lineFeature]);
}
function marker(locationPlace, iconAdress)
{
var parse = locationPlace.split(',');
  var location = new OpenLayers.LonLat(parse[0],parse[1]).transform( fromProjection, toProjection);
  var size = new OpenLayers.Size(21,25);
  var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
  var icon = new OpenLayers.Icon(iconAdress,size,offset);
  markers.addMarker(new OpenLayers.Marker(location,icon.clone()));
  return location
}

