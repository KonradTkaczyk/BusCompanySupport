	var map, baseLayer, markers, lineLayer;
  var cities = new Object();
  cities['Radom'] = "51.40, 21.15";
  cities['Gdansk'] = "54.366667, 18.633333";
  cities['Olsztyn'] = "53.783333, 20.55";
  cities['Szczecin'] = "53.438056, 14.542222";
  cities['Ciechanow'] = "52.876111, 20.608056";
  cities['Opole'] = "50.664722, 17.926944";
  cities['Wroclaw'] = "51.11, 17.022222";
  cities['Cracow'] = "50.061389, 19.938333";
  cities['Katowice'] = "50.25, 19";
  cities['Rzeszow'] = "50.033611, 22.004722";
  cities['Lublin'] = "51.248056, 22.570278";
  cities['Warsaw'] = "52.232222, 21.008333";
  var fromProjection = new OpenLayers.Projection("EPSG:4326");   // Transform from WGS 1984
  var toProjection   = new OpenLayers.Projection("EPSG:900913"); // to Spherical Mercator Projection
  var root = location.protocol + '//' + location.host;
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
	if ($('#FoundTickets').length)
	{
		ShortestPath();
		SeatReservation();
		events();
	}
}


function mapMarkers()
{
  markers.clearMarkers();
  var selectBox = document.getElementById('ticket_cityFrom');
  if (selectBox.value == "") return;
  var locationPlace = cities[selectBox.value];
  var location = marker(locationPlace, root + "/images/marker.png");//function to place a marker on map with specific icon.
  selectBox = document.getElementById('ticket_cityTo');
  if (selectBox.value == "") return;
  locationPlace = cities[selectBox.value];
  var location2 = marker(locationPlace, root + "/images/marker2.png");

  lineLayer.removeAllFeatures();
	line(location,location2);
}

function line(location,location2)
{

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

function lines(locations)
{
	for (var i=0;i+1<locations.length;i++)
	{
		line(locations[i],locations[i+1]);
	}
}

function ShortestPath()
{
	markers.clearMarkers();
  lineLayer.removeAllFeatures();

	var arr = [];
	$("#FoundTickets tr").each(function(){
		  arr.push($(this).find("td:first").text()); //put elements into array
	});
	arr.push($("#FoundTickets tr").eq(-1).find("td:eq(1)").text());//last row second column
	arr.shift();// list of cities which will be visited during travel
	if (arr.length == 0) return;
	var locations = new Array;
	for (var i=0;i<arr.length;i++)
	{
		locations.push(marker(cities[arr[i]],root + "/images/marker.png"));//coordination points to draw lines
	}
	lines(locations);
}

function marker(locationPlace, iconAdress)
{
	var parser = locationPlace.split(',');
  var location = new OpenLayers.LonLat(parser[1],parser[0]).transform( fromProjection, toProjection);
  var size = new OpenLayers.Size(21,25);
  var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
  var icon = new OpenLayers.Icon(iconAdress,size,offset);
  markers.addMarker(new OpenLayers.Marker(location,icon.clone()));
  return location;
}


var settings = {
               rows: 2,
               cols: 5,
               rowCssPrefix: 'row-',
               colCssPrefix: 'col-',
               seatWidth: 40,
               seatHeight: 40,
               seatCss: 'seat',
               selectedSeatCss: 'reservedSeat',
               selectingSeatCss: 'selectingSeat'
           		 };

function SeatReservation()
{
	($('tr').each(function(x,row)
	{
		reservedSeat = $(row).find('#Seat').data('seats');
		var str = [], seatNo, className;
		for (i = 0; i < settings.rows; i++)
		{
			for (j = 0; j < settings.cols; j++)
			{
				seatNo = (i + j * settings.rows + 1);
				className = settings.seatCss + ' ' + settings.rowCssPrefix + i.toString() + ' ' + settings.colCssPrefix + j.toString();
				if ($.isArray(reservedSeat) && $.inArray(seatNo, reservedSeat) != -1)
				{
				    className += ' ' + settings.selectedSeatCss;
				}
				str.push('<li class="' + className + '"' + 'style="top:' + (i * settings.seatHeight).toString()
				+ 'px;left:' + (j * settings.seatWidth).toString() + 'px">' + '<a title="' + seatNo + '">'
				+ seatNo + '</a>' + '</li>');
			}
		}
		$(row).find('#place').html(str.join(''));
	}));
}

function events()
{
	$('.' + settings.seatCss).click(function () {
	if ($(this).hasClass(settings.selectedSeatCss)){
		  alert('This seat is already reserved');
	}
	else{
		  $(this).toggleClass(settings.selectingSeatCss);
		  }
	});

	$('#btnShow').click(function () {
		  var str = [];
		  $.each($('#place li.' + settings.selectedSeatCss + ' a, #place li.'+ settings.selectingSeatCss + ' a'), function (index, value) {
		      str.push($(this).attr('title'));
		  });
		  alert(str.join(','));
	})

	$('#Reserve').click(function () {
		  var str = [], item;
		  var ReservingTrip = [],  ArrayOfTrips= [];
			($('tr').each(function(x,row)
			{
				tripid = $(row).find('#Seat').data('tripid');
				ReservingTrip.push(tripid);
				$(row).find('#place li.' + settings.selectingSeatCss + ' a').each(function(i,j)
				{
					alert("bla"+i+"ala"+$(j).attr('title')+'tripid:'+tripid);
					ReservingTrip.push(parseInt($(j).attr('title')));
				});
				ArrayOfTrips.push(ReservingTrip);
				ReservingTrip = [];
			}));
			ArrayOfTrips.splice(0,1);
			$.ajax({
		    type: "GET",
		    url: "/ticket/reserveAll",
		    data: {ArrayOfTrips: JSON.stringify(ArrayOfTrips)},	//sends array of trips to Rails server in format
		    																										// [[tripId1,seat no1,seat no2...][tripId2,seat no1...]...]
		    success: function(response)
		    {
					text = JSON.stringify(response);
		    	if(text.indexOf("success") >= 0)
		    	{
		    		alert("Tickets reserved!");
		    		$('table').fadeOut(1000);
		    	}
		    	else
		    	{
		    		alert("Failed to reserve tickets!");
		    	}
		    },
		    failure: function() { alert("Failure!"); }
      });
	})
}
window.onload = init;

