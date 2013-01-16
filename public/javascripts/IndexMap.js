var map, baseLayer, markers;
function init()
{
  map = new OpenLayers.Map('map');
  baseLayer = new OpenLayers.Layer.OSM();
  map.addLayer(baseLayer);
  var fromProjection = new OpenLayers.Projection("EPSG:4326");   // Transform from WGS 1984
  var toProjection   = new OpenLayers.Projection("EPSG:900913"); // to Spherical Mercator Projection
  var position = new OpenLayers.LonLat(19.00,52.00).transform( fromProjection, toProjection)
  map.setCenter(position,6);
  markers = new OpenLayers.Layer.Markers("Cities");
  map.addLayer(markers);
}

function jumpTo()
{
  var fromProjection = new OpenLayers.Projection("EPSG:4326");   // Transform from WGS 1984
  var toProjection   = new OpenLayers.Projection("EPSG:900913"); // to Spherical Mercator Projection
  var cities = new Object();
  cities['Radom'] = "21.15, 51.40";
  cities['Gdansk'] = "18.633333,54.366667";
  cities['Olsztyn'] = "20.55,53.783333";
  cities['Szczecin'] = "14.542222, 53.438056";
  cities['Ciechanow'] = "20.608056,52.876111";
  cities['Warsaw'] = "21.008333, 52.232222";
  markers.clearMarkers();
  var selectBox = document.getElementById('ticket_cityFrom');
  if (selectBox.value == "NA") return;
  var locationPlace = cities[selectBox.value]
  var parse = locationPlace.split(',');
  var location = new OpenLayers.LonLat(parse[0],parse[1]).transform( fromProjection, toProjection);
  var size = new OpenLayers.Size(21,25);
  var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
  var icon = new OpenLayers.Icon('images/marker.png',size,offset);
  markers.addMarker(new OpenLayers.Marker(location,icon.clone()));
  selectBox = document.getElementById('ticket_cityTo');
  if (selectBox.value == "NA") return;
  locationPlace = cities[selectBox.value]
  parse = locationPlace.split(',');
  var location2 = new OpenLayers.LonLat(parse[0],parse[1]).transform( fromProjection, toProjection);
  icon = new OpenLayers.Icon('images/marker2.png',size,offset);
  markers.addMarker(new OpenLayers.Marker(location2,icon.clone()));

  var lineLayer = new OpenLayers.Layer.Vector("Line Layer");

	map.addLayer(lineLayer);
	map.addControl(new OpenLayers.Control.DrawFeature(lineLayer, OpenLayers.Handler.Path));
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

