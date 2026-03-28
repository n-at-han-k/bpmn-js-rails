import { Controller } from "@hotwired/stimulus"
import { createForm } from "bpmn_js_rails/form_viewer"

// Connects to data-controller="form-js-viewer"
//
// Values:
//   schema (Object) - the form-js JSON schema
//   data   (Object) - initial form data to populate fields
//
// Lifecycle:
//   connect:    creates the FormViewer.Form instance
//   disconnect: destroys it (cleans up DOM + listeners)
//
// Events dispatched on the controller element:
//   form-js:submit  - { detail: { data, errors } }
//   form-js:changed - { detail: { data } }
//
export default class extends Controller {
  static values = {
    schema: { type: Object, default: { type: "default", components: [] } },
    data:   { type: Object, default: {} }
  }

  connect() {
    createForm({
      container: this.element,
      schema: this.schemaValue,
      data: this.dataValue
    }).then((form) => {
      this.form = form

      form.on("submit", (event) => {
        this.dispatch("submit", { detail: { data: event.data, errors: event.errors } })
      })

      form.on("changed", (event) => {
        this.dispatch("changed", { detail: { data: event.data } })
      })
    })
  }

  disconnect() {
    if (this.form) {
      this.form.destroy()
      this.form = null
    }
  }
}
