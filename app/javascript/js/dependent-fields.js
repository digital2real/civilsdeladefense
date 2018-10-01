document.addEventListener("DOMContentLoaded", function() {
  let role_select = document.getElementById('administrator_role')
  if (role_select !== null) {
    role_select.addEventListener('change', triggerRoleChange, false)
  }
})

function triggerRoleChange() {
  let employer_select = document.getElementById('administrator_employer_id')
  if (employer_select !== null) {
    let value = this.options[this.selectedIndex].value
    employer_select.disabled = value !== 'employer'
  }
}

document.addEventListener("DOMContentLoaded", function() {
  initEmailTemplates()
})

function initEmailTemplates() {
  let email_template = document.getElementById('email_template')
  if (email_template !== null) {
    email_template.addEventListener('change', triggerEmailTemplateChoice, false)
  }
}

window.initEmailTemplates = initEmailTemplates

function triggerEmailTemplateChoice() {
  let value = this.options[this.selectedIndex].value
  if (value !== '') {
    let template = window.templates.find(function(element) {
      return element.id == value
    })
    let subjectNode = document.getElementById('email_subject')
    if (subjectNode !== null) {
      subjectNode.value = template.subject
    }
    let bodyNode = document.getElementById('email_body')
    if (bodyNode !== null) {
      bodyNode.value = template.body
    }
  }
}

document.addEventListener("DOMContentLoaded", function() {
  let type_contract = document.getElementById('job_offer_contract_type_id')
  if (type_contract !== null) {
    type_contract.addEventListener('change', triggerTypeContractChange, false)
    triggerTypeContractChange(false)
  }
})

function triggerTypeContractChange(event_change = true) {
  let duration_contract = document.getElementById('job_offer_duration_contract')
  let type_contract = document.getElementById('job_offer_contract_type_id')
  let duration_contract_goup = document.getElementsByClassName('job_offer_duration_contract').item(0)
  if (duration_contract !== null) {
    let value = type_contract.options[type_contract.selectedIndex].text
    duration_contract_goup.hidden = value !== 'CDD'
    if (event_change){
      if(value === 'CDD'){
        duration_contract.value = duration_contract.getAttribute("data-cdd-value")
        duration_contract.setAttribute("data-cdd-value", "")
      }
      else if(duration_contract.getAttribute("data-cdd-value") === "") {
        duration_contract.setAttribute("data-cdd-value", duration_contract.value)
        duration_contract.value = ""
      }
    } else {
      duration_contract.setAttribute("data-cdd-value", "")
    }
  }
}