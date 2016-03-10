var map, heatmap, geocoder, currentChecker
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
  $('#place-it').on('click', placeIt)
})

function analyseNeighborhoodDistribution(){
  var city = $('#location').val()
  var neighborhood = this.dataset.location
  var address = city + ' ' + neighborhood
  var keywords = $('#keywords').val()
  var locations = []
  clearMap()
  geocoder.geocode({ 'address': address }, function(results, status) {
     if (status == google.maps.GeocoderStatus.OK) {
       map.setCenter(results[0].geometry.location)
       map.fitBounds(results[0].geometry.viewport)
        setTimeout(function(){
          $.ajax({
            action: 'GET',
            url: '/api/v1/analyst/heatmap',
            data: {keywords: keywords, city: city, neighborhood: neighborhood},
            success: function(heatmapData){ drawHeatmap(heatmapData) }
          })
       }, 20)
     }
   })
}

// function analyseNeighborhoodDistribution(){
//   var location = this.dataset.location
//   var keywords = $('#keywords').val()
//   var locations = []
//   clearMap()
//
//   geocoder.geocode({ 'address': location }, function(results, status) {
//      if (status == google.maps.GeocoderStatus.OK) {
//        map.setCenter(results[0].geometry.location)
//        map.fitBounds(results[0].geometry.viewport)
//        $.ajax({
//          action: 'GET',
//          url: '/api/v1/neighborhoods/heatmap',
//          data: {location: results[0].geometry.viewport.toString(), keywords: keywords},
//          success: function(heatmapData){ drawHeatmap(heatmapData) }
//        })
//      }
//    })
// }

function clearMap(){
  setMapOnAll(null)
  if (heatmap) { heatmap.setMap(null) }
}

function placeIt(){
  // if the search term (eg "mexican") is the same as the prev one,
  // just return and


  var location = $('#location').val()

  clearMap()

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
       map.setCenter(results[0].geometry.location)
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
    url: '/api/v1/analyst/city?',
    data: {location: location, keywords: keywords},
    success: function(response){
      if (response.message == 'analyzing'){
        waiter()
      } else {
        drawMarkers(response)
      }
    }
  })
}

function drawMarkers(response){
  $('#marker-info').empty()

  $.each(response,function(index, neighborhood){
    drawRichMarker(neighborhood, index)
    addSideLink(neighborhood, index)
  })

  $('.neighborhood').on('click', analyseNeighborhoodDistribution)

}

function waiter(){
  $('#waiter').modal({
    backdrop: 'static',
    keyboard: false
  })
  $('#waiter').modal('show')
  $('#leave').on('click',function(){
    clearInterval(currentChecker)
  })
  counter()
  checker()
  // #keep making calls every 10 seconds until it is ready
  // setInterval(function(){ alert("Hello") }, 3000)
}

function checker(){
  currentChecker = setInterval(function(){
    var location = $('#location').val()
    var keywords = $('#keywords').val()
    console.log('checker!')
    $.ajax({
      action: 'GET',
      url: '/api/v1/checker',
      data: {location: location, keywords: keywords},
      success: function(response){
        if (response.message == 'not ready') {
        } else {
          drawMarkers(response)
          clearInterval(currentChecker)
          $('#waiter').modal('hide')
// 2016-03-10T03:23:23.818Z 33808 TID-ouii071fw CityAnalystWorker JID-eb5
// 54ebcb5f0aa31
        }
      }
    })
  }, 10000)
}

function counter(){
  $('#progress').text(0)
  var counter = setInterval(function(){
    var current = Number($('#progress').text())
    if (current == 99) { clearInterval(counter) }
    $('#progress').text(current + 1)
  }, 700)
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
    buttonFor(index, neighborhood.location, neighborhood.name)
  )
}

function buttonFor(index, location, name){
  if (index == 0) {
    return "<a id='" +
    name +
    "'class='neighborhood btn btn-success' data-location='" +
    name +
    "' href='#' style='width: 100%'>" +
    'A' + '.- ' + name +
    "</a><br>"
  } else {
    return "<br><a id='" +
    name +
    "'class='neighborhood btn btn-success' data-location='" +
    name +
    "' href='#' style='width: 100%'>" +
    index + '.- ' + name +
    "</a><br>"
  }
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
  heatmap.set('dissipating', true)
  heatmap.set('radius', 60)
}
