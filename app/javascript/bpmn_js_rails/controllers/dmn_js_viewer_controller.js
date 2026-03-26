import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dmn-js-viewer"
//
// Values:
//   xml (String) - the DMN 1.3 XML to display
//
// Lifecycle:
//   connect:    creates the DmnJS viewer instance, imports XML
//   disconnect: destroys it (cleans up DOM + listeners)
//
// Events dispatched on the controller element:
//   dmn-js-viewer:loaded - { detail: { warnings } }
//   dmn-js-viewer:error  - { detail: { error } }
//
export default class extends Controller {
  static values = {
    xml: { type: String, default: "" }
  }

  async connect() {
    if (typeof DmnJS === "undefined") {
      console.error("[bpmn-js-rails] DmnJS global not found. Make sure dmn-viewer.production.min.js or dmn-modeler.production.min.js is loaded.")
      return
    }

    this.viewer = new DmnJS({ container: this.element })

    if (this.xmlValue) {
      try {
        const result = await this.viewer.importXML(this.xmlValue)
        this.dispatch("loaded", { detail: { warnings: result.warnings } })
      } catch (err) {
        this.dispatch("error", { detail: { error: err } })
      }
    }
  }

  disconnect() {
    if (this.viewer) {
      this.viewer.destroy()
      this.viewer = null
    }
  }
}
