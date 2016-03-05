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
  // $('#action').on('click', bob)
})

function bob(){
  $('#marker-info').append(
    "<p>bob</p>"
  )
console.log('bob')
}

function placeIt(){
  var location = $('#location').val()
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

function setRichMarkers(){
  var location = $('#location').val()
  var keywords = $('#keywords').val()
  // debugger
  $.ajax({
    action: 'GET',
    url: '/api/v1/neighborhoods/results_per_capita?',
    data: {location: location, keywords: keywords},
    success: function(neighborhoods){
      $('#marker-info').empty()
      $.each(neighborhoods,function(index, neighborhood){
        // debugger
        drawRichMarker(neighborhood, index)
        addSideLink(neighborhood, index)
      })
    }
  })
}

function addSideLink(neighborhood, index){
  // debugger
  $('#marker-info').append(
    "<a class='btn btn-success' href='#'>" +
    (index + 1).toString() +
    '.- ' +
    neighborhood.name +
    "</a>"
    // '<a id="action" class="btn btn-success" href="#">Action!</a>'
    // "<div class='post' data-id='" +
    // post.id +
    // "'><h6>Published on: " +
    // post.created_at +
    // "</h6><p>" +
    // post.description +
    // "</p>" +
    // "<button id='delete-post' name='button-fetch' class='btn btn-default btn-xs'>Delete</button>" +
    // "</div>"
  )
}

  function drawRichMarker(data, index){
    // debugger
    // data ={name: "University Park", location: "Denver University Park", results_density: 6.751412024626886e-7
    geocoder.geocode({ 'address': data.location }, function(results, status) {
       if (status == google.maps.GeocoderStatus.OK) {
         new google.maps.Marker({
           map: map,
           position: results[0].geometry.location,
           label: (index + 1).toString()
         })
       }
     })

  }
  // setMarkers
  // llamar a la api-> devuelve x barrios
  // cada barrio:
  //get location con geocoder
  //generar el marcador usando:
  //localizacion
  //nombre
  //color dependiendo de la escala

function simpleSearch(){
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
