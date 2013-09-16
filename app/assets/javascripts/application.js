// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require underscore
//= require backbone
//= require diffstring
//= require jquery_ujs
//= require turbolinks
//= require_tree .

var App = App || {};

function merge_adjacent(type) {
    var spans = $(type);
    for ( var i = spans.length - 2; i >= 0; --i)
    {
       var span = spans[i];
       var nextspan = spans[i + 1];
      
       merge(span, nextspan);
    }
}
  
function merge(span, nextspan) {
  console.log('merge');
  var follower = span.nextSibling;
  var concat = true;
  // console.log(follower);
  // console.log(nextspan);
  // if (follower == null) return;
   while (follower && follower != nextspan)
   {
     if (follower.nodeName != '#text')
     {
       concat = false;
       break;
     }
     var len = follower.data.trim().length;
     if (len > 0)
     {
       concat = false;
       break;
     }

     follower = follower.nextSibling;
   }

  if (concat)
  {
    $(span).text($(span).text() + " " + $(follower).text());
    $(follower).remove();
  }
}