import { Controller } from "@hotwired/stimulus"
import DmnModeler from "bpmn_js_rails/dmn_modeler"

// Connects to data-controller="dmn-js-modeler"
//
// Values:
//   xml (String) - the DMN 1.3 XML to load into the modeler
//
// Targets:
//   container - the child div that dmn-js renders into (falls back to this.element)
//   xmlField  - a hidden <input> that receives the serialised XML
//               on every change and before form submission
//
// Lifecycle:
//   connect:    creates the DmnJS modeler instance, imports XML, wires change + submit sync
//   disconnect: destroys the modeler
//
// Events dispatched on the controller element:
//   dmn-js-modeler:ready   - { detail: { modeler } }
//   dmn-js-modeler:changed - after XML sync
//
export default class extends Controller {
  static values = {
    xml: { type: String, default: "" }
  }

  static targets = ["container", "xmlField"]

  async connect() {
    const renderTarget = this.hasContainerTarget ? this.containerTarget : this.element

    this.modeler = new DmnModeler({
      container: renderTarget,
      keyboard: { bindTo: window }
    })

    if (this.xmlValue) {
      try {
        await this.modeler.importXML(this.xmlValue)
      } catch (err) {
        console.error("[bpmn-js-rails] Failed to import DMN XML:", err)
      }
    }

    // Listen for changes on the active viewer's command stack
    this.modeler.on("views.changed", ({ activeView }) => {
      const activeViewer = this.modeler.getActiveViewer()
      if (activeViewer && this._currentViewer !== activeViewer) {
        this._currentViewer = activeViewer

        try {
          const eventBus = activeViewer.get("eventBus")
          eventBus.on("commandStack.changed", () => {
            this._syncXmlField()
            this.dispatch("changed")
          })
        } catch (_) {
          // some view types may not have a commandStack
        }
      }
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

    this._currentViewer = null

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
