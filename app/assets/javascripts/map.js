var map, heatmap, geocoder
var markers = []
function initMap() {
  var turing = {lat: 39.749, lng: -105.000}
  geocoder = new google.maps.Geocoder()
  map = new google.maps.Map(document.getElementById('map'), {
    center: turing,
    zoom: 11
  });
}

$(document).ready(function(){
  $('#action').on('click', placeIt)
})

function analyseNeighborhoodDistribution(){
  var location = this.dataset.location
  var keywords = $('#keywords').val()
  var locations = []
  clearMap()

  geocoder.geocode({ 'address': location }, function(results, status) {
     if (status == google.maps.GeocoderStatus.OK) {
       map.setCenter(results[0].geometry.location);
       map.fitBounds(results[0].geometry.viewport)
       $.ajax({
         action: 'GET',
         url: '/api/v1/neighborhoods/heatmap',
         data: {location: results[0].geometry.viewport.toString(), keywords: keywords},
         success: function(heatmapData){ drawHeatmap(heatmapData) }
       })
     }
   })
}

function clearMap(){
  setMapOnAll(null)
  if (heatmap) { heatmap.setMap(null) }
}

function placeIt(){
  var location = $('#location').val()

  clearMap()
  $('#marker-info').empty()

  if (location == 'Denver'){
    neighborhoodAnalysis()
  } else {
    simpleSearch()
  }
}

function neighborhoodAnalysis(){
  recenterMap()
  setRichMarkers()
  }

function recenterMap(){
  var location = $('#location').val()
  geocoder.geocode({ 'address': location }, function(results, status) {
     if (status == google.maps.GeocoderStatus.OK) {
       map.setCenter(results[0].geometry.location);
       map.fitBounds(results[0].geometry.viewport)
     }
   })
}

function setMapOnAll(map) {
  for (var i = 0; i < markers.length; i++) {
    markers[i].setMap(map);
  }
}

function setRichMarkers(){
  var location = $('#location').val()
  var keywords = $('#keywords').val()

  $.ajax({
    action: 'GET',
    url: '/api/v1/neighborhoods/results_per_capita?',
    data: {location: location, keywords: keywords},
    success: function(neighborhoods){

      $.each(neighborhoods,function(index, neighborhood){
        drawRichMarker(neighborhood, index)
        addSideLink(neighborhood, index)
      })

      $('.neighborhood').on('click', analyseNeighborhoodDistribution)
    }
  })
}

function drawRichMarker(data, index){
  // data ={name: "University Park", location: "Denver University Park", results_density: 6.751412024626886e-7}
  geocoder.geocode({ 'address': data.location }, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      var marker = new google.maps.Marker({
        map: map,
        position: results[0].geometry.location,
        label: (index + 1).toString()
      })
      markers.push(marker)
    }
  })
}

function addSideLink(neighborhood, index){
  $('#marker-info').append(
    "<a id='mono'class='neighborhood btn btn-success' data-location='" +
    neighborhood.location +
    "' href='#'>" +
    (index + 1).toString() + '.- ' + neighborhood.name +
    "</a><br><br>"
  )
}

function simpleSearch(){
  recenterMap()
  showHeatmap()
}

function showHeatmap(){
  var location = $('#location').val()
  var keywords = $('#keywords').val()
  $.ajax({
    action: 'GET',
    url: '/api/v1/search/simple',
    data: {location: location, keywords: keywords},
    success: function(response){ drawHeatmap(response.locations) }
  })
}

function drawHeatmap(coordinates){
  var heatmapData = $.map(coordinates, function(coordinate){
    return new google.maps.LatLng(coordinate.lat, coordinate.lng)
  })

  heatmap = new google.maps.visualization.HeatmapLayer({
      data: heatmapData,
      map: map
    });
  // $.each(coordinates, function(index, coordinate){
  //   drawMarker(coordinate)
  // })
}

// function drawMarker(coordinates){
//   new google.maps.Marker({
//     map: map,
//     position: coordinates
//   })
// }
