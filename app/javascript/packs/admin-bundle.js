/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Turbolinks from 'turbolinks'
Turbolinks.start()

// Import Rails UJS
const Rails = require('rails-ujs')
Rails.start()

// Import Trix
const Trix = require('trix')
Trix.config.blockAttributes.default.tagName = "p"
Trix.config.blockAttributes.default.breakOnReturn = true

import flatpickr from 'flatpickr'
import { French } from 'flatpickr/dist/l10n/fr'

function importAll(r) {
  return r.keys().map(r)
}

importAll(require.context('images/', true, /\.(ico|png|jpe?g|svg|gif)$/))
importAll(require.context('icons/', true, /\.svg$/))

import BSN from 'bootstrap.native/dist/bootstrap-native.js'
import offCanvas from 'js/off-canvas'
import dependentFields from 'js/dependent-fields'
import cityAutocomplete from 'js/city-autocomplete'
import salaryRangeInputsHandling from 'js/salary-range-inputs-handling'
import formAutoSubmit from 'js/form-auto-submit'
window.formAutoSubmit = formAutoSubmit
import inPlaceEdit from 'js/in-place-edit'
window.inPlaceEdit = inPlaceEdit
import displayCharts from 'js/display-charts'
import displaySnackbars from 'js/display-snackbars'
import { boardManagement, boardRedraw, boardShowRejectionModal } from 'js/board'
window.boardRedraw = boardRedraw
window.boardShowRejectionModal = boardShowRejectionModal
import jobOfferManagement from 'js/job-offer-management'

document.addEventListener('turbolinks:load', function() {
  BSN.initCallback()

  ;[].forEach.call(document.querySelectorAll('.custom-file-input'), function(node) {
    node.addEventListener('change', function(e) {
      let fileName = node.val().split('\\').pop()
      node.parentNode.querySelector('.custom-file-label').classList.add('selected').innerHTML = fileName
    })
  })

  ;[].forEach.call(document.querySelectorAll('.allow-focus'), function(node) {
    node.addEventListener('click', function(e) {
      e.stopPropagation();
    })
  })

  offCanvas()
  formAutoSubmit()
  inPlaceEdit()
  salaryRangeInputsHandling()
  dependentFields()
  cityAutocomplete()
  displayCharts()
  displaySnackbars()
  boardManagement()
  jobOfferManagement()

  flatpickr('#job_offer_contract_start_on', {
    locale: French,
    altInput: true,
    altFormat: 'd/m/Y',
    dateFormat: 'Y-m-d'
  })
})
