// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("jquery")
require("chartkick")
require("chart.js")
require('./nested_forms/addFields')
require('./nested_forms/removeFields')

var ReactRailsUJS = require("react_ujs");

import 'bootstrap'
import $ from 'jquery';
import 'select2';
import '../stylesheets/application';
import 'controllers';

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
// Support component names relative to this directory:
var componentRequireContext = require.context("components", true);
ReactRailsUJS.useContext(componentRequireContext);

document.addEventListener('turbolinks:load', function() {
  $('.store-managers-select').select2({
    theme: 'bootstrap4',
    ajax: {
      data: function(params) {
        return {
          search: params.term,
          state: 'live'
        };
      },
      dataType: "json",
      quietMillis: 100,
      results: function(data, page) {
        return {
          results: data
        };
      },
      delay: 150,
      url: '/stores.json'
    }
  });

  $('.store-owners-select').select2({
    theme: 'bootstrap4',
    ajax: {
      data: function(params) {
        return {
          search: params.term
        };
      },
      dataType: "json",
      quietMillis: 100,
      results: function(data, page) {
        return {
          results: data
        };
      },
      delay: 150,
      url: '/users.json'
    }
  });
});
