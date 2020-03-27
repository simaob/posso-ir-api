// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("jquery")


import 'bootstrap'
import $ from 'jquery';
import 'select2';


import '../stylesheets/application'

document.addEventListener('turbolinks:load', function() {
  $('.store-managers-select').select2({
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
      url: '/stores.json'
    }
  });
});
