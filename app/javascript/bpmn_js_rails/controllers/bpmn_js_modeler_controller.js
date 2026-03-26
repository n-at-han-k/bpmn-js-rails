import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bpmn-js-modeler"
//
// Values:
//   xml (String) - the BPMN 2.0 XML to load into the modeler
//
// Targets:
//   container - the child div that bpmn-js renders into (falls back to this.element)
//   xmlField  - a hidden <input> that receives the serialised XML
//               on every change and before form submission
//
// Lifecycle:
//   connect:    creates the BpmnJS modeler instance, imports XML, wires change + submit sync
//   disconnect: destroys the modeler
//
// Events dispatched on the controller element:
//   bpmn-js-modeler:ready   - { detail: { modeler } }
//   bpmn-js-modeler:changed - after XML sync
//
export default class extends Controller {
  static values = {
    xml: { type: String, default: "" }
  }

  static targets = ["container", "xmlField"]

  async connect() {
    if (typeof BpmnJS === "undefined") {
      console.error("[bpmn-js-rails] BpmnJS global not found. Make sure bpmn-modeler.production.min.js is loaded.")
      return
    }

    const renderTarget = this.hasContainerTarget ? this.containerTarget : this.element

    this.modeler = new BpmnJS({ container: renderTarget })

    if (this.xmlValue) {
      try {
        await this.modeler.importXML(this.xmlValue)
        this.modeler.get("canvas").zoom("fit-viewport")
      } catch (err) {
        console.error("[bpmn-js-rails] Failed to import XML:", err)
      }
    }

    this.modeler.on("commandStack.changed", () => {
      this._syncXmlField()
      this.dispatch("changed")
    })

    // Also sync right before the enclosing <form> submits
    this._form = this.element.closest("form")
    if (this._form) {
      this._boundSubmitHandler = () => this._syncXmlField()
      this._form.addEventListener("submit", this._boundSubmitHandler)
    }

    this.dispatch("ready", { detail: { modeler: this.modeler } })
  }

  disconnect() {
    if (this._form && this._boundSubmitHandler) {
      this._form.removeEventListener("submit", this._boundSubmitHandler)
      this._boundSubmitHandler = null
      this._form = null
    }

    if (this.modeler) {
      this.modeler.destroy()
      this.modeler = null
    }
  }

  // Serialise the current modeler XML into the hidden field target.
  async _syncXmlField() {
    if (!this.modeler || !this.hasXmlFieldTarget) return
    try {
      const { xml } = await this.modeler.saveXML({ format: true })
      this.xmlFieldTarget.value = xml
    } catch (_) {
      // modeler may be mid-import; ignore
    }
  }
}
