import { Controller } from "@hotwired/stimulus"
import BpmnViewer from "bpmn_js_rails/viewer"

// Connects to data-controller="bpmn-js-viewer"
//
// Values:
//   xml (String) - the BPMN 2.0 XML to display
//
// Lifecycle:
//   connect:    creates the BpmnJS viewer instance, imports XML
//   disconnect: destroys it (cleans up DOM + listeners)
//
// Events dispatched on the controller element:
//   bpmn-js-viewer:loaded - { detail: { warnings } }
//   bpmn-js-viewer:error  - { detail: { error } }
//
export default class extends Controller {
  static values = {
    xml: { type: String, default: "" }
  }

  async connect() {
    this.viewer = new BpmnViewer({ container: this.element })

    if (this.xmlValue) {
      try {
        const result = await this.viewer.importXML(this.xmlValue)
        this.viewer.get("canvas").zoom("fit-viewport")
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
