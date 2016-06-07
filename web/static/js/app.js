// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import $ from "jquery"

//
// pxscratch JS code
//
$(() => {
  //
  // Box close
  //
  $(".box-close").on("click", (e) => {
    e.preventDefault()
    e.toElement.parentNode.remove()
  })


  //
  // Post
  //
  let publish_data_div = $(".publish-date-group")
  let publish_checkbox = $("#post_publish")
  let password_div = $(".password-group")
  let password_checkbox = $("#post_protect")

  // Handle post form fields visibility.
  if (publish_checkbox[0]) {
    if (publish_checkbox.prop("checked")) {
      publish_data_div.show()
    } else {
      publish_data_div.hide()
    }

    publish_checkbox.on("change", (e) => {
      if (publish_checkbox.prop("checked")) {
        publish_data_div.fadeIn()
      } else {
        publish_data_div.fadeOut()
      }
    })
  }

  if (password_checkbox[0]) {
    if (password_checkbox.prop("checked")) {
      password_div.show()
    } else {
      password_div.hide()
    }

    password_checkbox.on("change", (e) => {
      if (password_checkbox.prop("checked")) {
        password_div.fadeIn()
      } else {
        password_div.fadeOut()
      }
    })
  }
})

//
// Refills code
//

//
// header
//
$(window).resize(function() {
  var more = document.getElementById("js-navigation-more");
  if ($(more).length > 0) {
    var windowWidth = $(window).width();
    var moreLeftSideToPageLeftSide = $(more).offset().left;
    var moreLeftSideToPageRightSide = windowWidth - moreLeftSideToPageLeftSide;

    if (moreLeftSideToPageRightSide < 330) {
      $("#js-navigation-more .submenu .submenu").removeClass("fly-out-right");
      $("#js-navigation-more .submenu .submenu").addClass("fly-out-left");
    }

    if (moreLeftSideToPageRightSide > 330) {
      $("#js-navigation-more .submenu .submenu").removeClass("fly-out-left");
      $("#js-navigation-more .submenu .submenu").addClass("fly-out-right");
    }
  }
});

$(document).ready(function() {
  var menuToggle = $("#js-mobile-menu").unbind();
  $("#js-navigation-menu").removeClass("show");

  menuToggle.on("click", function(e) {
    e.preventDefault();
    $("#js-navigation-menu").slideToggle(function(){
      if($("#js-navigation-menu").is(":hidden")) {
        $("#js-navigation-menu").removeAttr("style");
      }
    });
  });
});


//
// Vertical tabs
//
$(".js-vertical-tab-content").hide();
$(".js-vertical-tab-content:first").show();

/* if in tab mode */
$(".js-vertical-tab").click(function(event) {
  event.preventDefault();

  $(".js-vertical-tab-content").hide();
  var activeTab = $(this).attr("rel");
  $("#"+activeTab).show();

  $(".js-vertical-tab").removeClass("is-active");
  $(this).addClass("is-active");

  $(".js-vertical-tab-accordion-heading").removeClass("is-active");
  $(".js-vertical-tab-accordion-heading[rel^='"+activeTab+"']").addClass("is-active");
});

/* if in accordion mode */
$(".js-vertical-tab-accordion-heading").click(function(event) {
  event.preventDefault();

  $(".js-vertical-tab-content").hide();
  var accordion_activeTab = $(this).attr("rel");
  $("#"+accordion_activeTab).show();

  $(".js-vertical-tab-accordion-heading").removeClass("is-active");
  $(this).addClass("is-active");

  $(".js-vertical-tab").removeClass("is-active");
  $(".js-vertical-tab[rel^='"+accordion_activeTab+"']").addClass("is-active");
});
