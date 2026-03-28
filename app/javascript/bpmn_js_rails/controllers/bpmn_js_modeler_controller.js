import { Controller } from "@hotwired/stimulus"
import BpmnModeler from "bpmn_js_rails/modeler"
import { BpmnPropertiesModules } from "bpmn_js_rails/properties_panel"
import { ElementTemplatesModule } from "bpmn_js_rails/element_templates"
import ElementTemplateChooserModule from "bpmn_js_rails/element_template_chooser"
import NativeCopyPasteModule from "bpmn_js_rails/native_copy_paste"

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
    xml: { type: String, default: "" },
    propertiesPanelEnabled: { type: Boolean, default: true },
    elementTemplateChooserEnabled: { type: Boolean, default: false },
    nativeCopyPasteEnabled: { type: Boolean, default: false },
    elementTemplates: { type: Array, default: [] }
  }

  static targets = ["container", "propertiesPanel", "xmlField"]

  async connect() {
    const renderTarget = this.hasContainerTarget ? this.containerTarget : this.element
    this.modeler = this.createModeler(this.modelerOptions(renderTarget))

    this._wireNativeCopyPasteFallback()
    this._wireElementTemplateErrors()

    if (this.xmlValue) {
      try {
        await this.modeler.importXML(this.xmlValue)
        this.modeler.get("canvas").zoom("fit-viewport")
      } catch (err) {
        console.error("[bpmn-js-rails] Failed to import XML:", err)
      }
    }

    if (this.elementTemplateChooserEnabledValue) {
      this._loadElementTemplates()
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

  // Override in host app controllers to inject modules, moddle extensions, etc.
  modelerOptions(renderTarget) {
    const options = {
      container: renderTarget
    }

    const additionalModules = []
    const propertiesPanelEnabled = this.propertiesPanelEnabledValue && this.hasPropertiesPanelTarget

    if (propertiesPanelEnabled) {
      options.propertiesPanel = { parent: this.propertiesPanelTarget }
      additionalModules.push(...BpmnPropertiesModules)
    }

    if (this.nativeCopyPasteEnabledValue) {
      additionalModules.push(NativeCopyPasteModule)
    }

    if (this.elementTemplateChooserEnabledValue) {
      additionalModules.push(...ElementTemplatesModule, ElementTemplateChooserModule)
    }

    if (additionalModules.length) {
      options.additionalModules = additionalModules
    }

    return options
  }

  // Override in host app controllers if you need a different modeler class.
  createModeler(options) {
    return new BpmnModeler(options)
  }

  async openElementTemplateChooser(element) {
    if (!this.modeler || !this.elementTemplateChooserEnabledValue) return null
    return await this.modeler.get("elementTemplateChooser").open(element)
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

  _wireNativeCopyPasteFallback() {
    if (!this.nativeCopyPasteEnabledValue || !this.modeler) return

    const eventBus = this.modeler.get("eventBus")
    const nativeCopyPaste = this.modeler.get("nativeCopyPaste")

    eventBus.on("native-copy-paste:error", ({ message, error }) => {
      console.warn("[bpmn-js-rails] native copy/paste unavailable, falling back to local clipboard:", message, error)
      nativeCopyPaste.toggle(false)
    })
  }

  _wireElementTemplateErrors() {
    if (!this.elementTemplateChooserEnabledValue || !this.modeler) return

    this.modeler.on("elementTemplates.errors", ({ errors }) => {
      this.dispatch("element-templates-errors", { detail: { errors } })
    })
  }

  _loadElementTemplates() {
    if (!this.modeler || !this.elementTemplateChooserEnabledValue) return
    this.modeler.get("elementTemplatesLoader").setTemplates(this.elementTemplatesValue)
  }

}
