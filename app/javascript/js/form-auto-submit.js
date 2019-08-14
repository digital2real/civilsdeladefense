const Rails = require('rails-ujs')

export default function formAutoSubmit() {
  ;[].forEach.call(document.querySelectorAll('form.auto-submit'), function(formElement) {
    var selectElements = formElement.querySelectorAll('select')
    ;[].forEach.call(selectElements, function(selectElement) {
      selectElement.addEventListener('change', function(e) {
        var multiple = selectElement.name.split(/\(\d+i\)/)
        if (multiple.length > 1) {
          var beginning = multiple[0]
          var selector = 'select[name^="'+beginning+'"]'
          var linkedElements = formElement.querySelectorAll(selector)
          var ary = Array.from(linkedElements)
          var allFilled = ary.every(function(linkedElement){
            if (!linkedElement.value) {
              return false
            } else {
              return true
            }
          })
          if (allFilled) {
            Rails.fire(formElement, 'submit')
          }
        } else {
          Rails.fire(formElement, 'submit')
        }
      })
    })

    var checkboxElements = formElement.querySelectorAll('input[type=checkbox]')
    ;[].forEach.call(checkboxElements, function(checkboxElement) {
      checkboxElement.addEventListener('change', function(e) {
        Rails.fire(formElement, 'submit')
      })
    })

    var radioElements = formElement.querySelectorAll('input[type=radio]')
    ;[].forEach.call(radioElements, function(radioElement) {
      radioElement.addEventListener('change', function(e) {
        Rails.fire(formElement, 'submit')
      })
    })

    var textElements = formElement.querySelectorAll('input[type=text]')
    ;[].forEach.call(textElements, function(inputElement) {
      inputElement.addEventListener('blur', function(e) {
        Rails.fire(formElement, 'submit')
      })
    })

    var fileInputs = formElement.querySelectorAll("input[type=file]")
    ;[].forEach.call(fileInputs, function(inputElement) {
      inputElement.addEventListener('change', function(e) {
        Rails.fire(formElement, 'submit')
      })
    })
  })
}