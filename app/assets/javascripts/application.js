// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.cookie
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .
//= require underscore-min
//= require gmaps/google

function showPosition(position) 
{
    username = $("#name").val();

    var topic_id = [];
    $(".active").each (function() {
      topic_id.push($(this).attr("topic-id"));
    });  
    var l = window.location;
    var base_url = l.protocol + "//" + l.host + "/" 
    console.log(base_url + "api/get_user?" + "lt=" + position.coords.latitude + "&lg=" + position.coords.longitude + "&username" + username + "&topic_id" + topic_id.join(","))
    $.ajax({
          type: "GET",
          url: base_url + "api/get_user",
          data: "lt=" + position.coords.latitude + "&lg=" + position.coords.longitude + "&username=" + username + "&topic_id=" + topic_id.join(","),
          success: function(msg){
            var json= jQuery.parseJSON(JSON.stringify(msg));
            $.cookie('poi_user', json.user_id, { expires: 7, path: '/' });
           	 location.reload();
           	}
         });
}

function update_topic_list(topic_id)
{
  if (isNaN(topic_id)) 
  {
    var l = window.location; 
    var base_url = l.protocol + "//" + l.host + "/" 
    $("#user-topic-list").load("/home/topic_user_list");
     $.ajax({
     type: "GET",
      url: base_url + "home/map",
          success: function(msg){
            var json= jQuery.parseJSON(JSON.stringify(msg));
            var raw_markers =json;
            handler = Gmaps.build('Google');
            handler.buildMap({ internal: {id: 'basic_map'}}, function(){
            var markers = handler.addMarkers(raw_markers);
            handler.bounds.extendWith(markers);
            handler.fitMapToBounds();
          });       
        }
    });
  }
  else
  {
      $("#user-topic-list").load("/home/topic_user_list?topic_id="+topic_id);
      var l = window.location;
      var base_url = l.protocol + "//" + l.host + "/" 
      $.ajax({
          type: "GET",
          url: base_url + "home/map",
          data: "topic_id=" + topic_id,
          success: function(msg){
            var json= jQuery.parseJSON(JSON.stringify(msg));
            var raw_markers =json;
            handler = Gmaps.build('Google');
            handler.buildMap({ internal: {id: 'basic_map'}}, function(){
            var markers = handler.addMarkers(raw_markers);
            handler.bounds.extendWith(markers);
            handler.fitMapToBounds();
          });       
        }
    });
  
  }
}
  var l = window.location; 
  var base_url = l.protocol + "//" + l.host + "/" 

 $.ajax({
     type: "GET",
      url: base_url + "home/map",
          success: function(msg){
            var json= jQuery.parseJSON(JSON.stringify(msg));
            var raw_markers =json;
            handler = Gmaps.build('Google');
            handler.buildMap({ internal: {id: 'basic_map'}}, function(){
            var markers = handler.addMarkers(raw_markers);
            handler.bounds.extendWith(markers);
            handler.fitMapToBounds();
          });       
        }
    });

function centerModal() {
    $(this).css('display', 'block');
    var $dialog = $(this).find(".modal-dialog");
    var offset = ($(window).height() - $dialog.height()) / 2;
    // Center modal vertically in window
    $dialog.css("margin-top", offset);
}

function save_user()
{
  if (navigator.geolocation) 
  {
    navigator.geolocation.getCurrentPosition(showPosition);
  } 
  else 
  { 
    x.innerHTML = "Geolocation is not supported by this browser.";
  }
}

    


 $(window).load(function(){
        $('#myModal').modal('show');
    });

