var map
var geocoder
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

function placeIt(){
  recenterMap()
  setMarkers()
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

function setMarkers(){
  var location = $('#location').val()
  var keywords = $('#keywords').val()
  $.ajax({
    action: 'GET',
    url: '/api/v1/search/simple',
    data: {location: location, keywords: keywords},
    success: function(response){ drawMarkers(response.locations) }
  })
}

function drawMarkers(coordinates){
  $.each(coordinates, function(index, coordinate){
    drawMarker(coordinate)
  })
}

function drawMarker(coordinates){
  new google.maps.Marker({
    map: map,
    position: coordinates
  })
}
