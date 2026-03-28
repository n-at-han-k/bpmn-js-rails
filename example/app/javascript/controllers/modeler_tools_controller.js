import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["status"]

  setModeler(event) {
    this.modeler = event.detail.modeler
    this._setStatus("Modeler ready")
  }

  async openTemplateChooser() {
    if (!this.modeler) {
      this._setStatus("Modeler not ready yet")
      return
    }

    let chooser

    try {
      chooser = this.modeler.get("elementTemplateChooser")
    } catch (_) {
      this._setStatus("Element template chooser unavailable")
      return
    }

    const selection = this.modeler.get("selection").get()
    const element = selection[0] || this.modeler.get("canvas").getRootElement()

    try {
      const template = await chooser.open(element)
      this._setStatus(template ? `Applied template: ${template.name}` : "Template selection cancelled")
    } catch (error) {
      this._setStatus(`Template chooser error: ${error.message}`)
    }
  }

  _setStatus(message) {
    if (this.hasStatusTarget) {
      this.statusTarget.textContent = message
    }
  }
}
