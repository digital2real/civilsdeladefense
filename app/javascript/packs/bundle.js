/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

const Rails = require('rails-ujs')
Rails.start()


function importAll(r) {
  return r.keys().map(r)
}

importAll(require.context('images/', true, /\.(ico|png|jpe?g|svg|gif)$/))
importAll(require.context('icons/', true, /\.svg$/))

require('js/offcanvas.js')

document.addEventListener("DOMContentLoaded", function() {

  [].forEach.call(document.querySelectorAll('.custom-file-input'), function(el) {
    el.addEventListener('change', function() {
      let fileName = this.value.split('\\').pop()
      let label = this.nextElementSibling
      label.classList.add("selected")
      label.innerHTML = fileName
    })
  })
})