  var map;
  // var center = {lat: -34.397, lng: 150.644}
  var center = {lat: 39.749, lng: -105.000}
  function initMap() {
    var geocoder = new google.maps.Geocoder();
    // var address = document.getElementById('address').value;
    var address = "Alicante";
    // geocoder.geocode( { 'address': address})
    map = new google.maps.Map(document.getElementById('map'), {
      center: center,
      zoom: 10
    });
  }
