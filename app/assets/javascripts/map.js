  var map;

  function initMap() {
    var turing = {lat: 39.749, lng: -105.000}

    map = new google.maps.Map(document.getElementById('map'), {
      center: turing,
      zoom: 10
    });
  }

  function recenter(){
    var location = $('#location').val()
    var geocoder = new google.maps.Geocoder();
    geocoder.geocode({ 'address': location }, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        map.setCenter(results[0].geometry.location);
        // var marker = new google.maps.Marker({
        //   map: map,
        //   position: results[0].geometry.location
        // });
      }
    })
  }

  function place(){
    recenter()
    set_markers()
    // get markers

    // get location

    // recenter map

    // draw markers
  }

  function set_markers(){
    var business = $('#business').val()
    var location = $('#location').val()

    $.ajax({
      type: 'GET',
      url: '/jsoner',
      data: { business: business , location: location},
      success: function(data){
        draw_markers(data)
      }
    })
  }

  function draw_markers(places){
    $.each(places, function(index, value){
      console.log(value)
      new google.maps.Marker({
        map: map,
        position: value
      })
    })
  }

  // function copy(){
  //   var postParams = {
  //     post: {
  //       description: "superbob"
  //     }
  //   }
  //
  //   $.ajax({
  //     type: "GET",
  //     url: "/jsoner",
  //     data: postParams,
  //     success: function(newPost) {
  //       console.log(newPost)
  //     },
  //     error: function(xhr) {
  //       console.log(xhr.responseText)
  //     }
  //   })
  // }


  $(document).ready(function(){
    $('#spike').on('click', spike)
    $('#action').on('click', place)

    // var postParams = {
    //   post: {
    //     description: "superbob"
    //   }
    // }
    // $.ajax({
    //   type: "GET",
    //   url: "/jsoner",
    //   cache: false,
    //   params: postParams,
    //   success: function(newPost) {
    //     // debugger
    //     console.log(newPost)
    //   },
    //   error: function(xhr) {
    //     console.log(xhr.responseText)
    //   }
    // })
})
