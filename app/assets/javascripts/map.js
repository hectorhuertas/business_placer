  var map;

  function initMap() {
    var turing = {lat: 39.749, lng: -105.000}

    map = new google.maps.Map(document.getElementById('map'), {
      center: turing,
      zoom: 10
    });
  }

  function spike(){
    var location = $('#location').val()
    var geocoder = new google.maps.Geocoder();
    geocoder.geocode({ 'address': location }, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        map.setCenter(results[0].geometry.location);
        var marker = new google.maps.Marker({
          map: map,
          position: results[0].geometry.location
        });
      }
    })
  }

  function place(){
    // get markers

    // get location

    // recenter map

    // draw markers
  }

  function action(){
    $.ajax({
      type: 'GET',
      url: '/jsoner.json',
      success: function(data){
        console.log(data)
      }
    })
  }


  $(document).ready(function(){
    $('#spike').on('click', spike)
    $('#action').on('click', action)
})
