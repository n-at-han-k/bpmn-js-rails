import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-js-editor"
//
// Values:
//   schema (Object) - the form-js JSON schema to load into the editor
//
// Targets:
//   container   - the child div that form-js renders into (falls back to this.element)
//   schemaField - a hidden <input> that receives the serialised schema JSON
//                 on every change and before form submission
//
// Lifecycle:
//   connect:    creates the FormEditor instance, wires change + submit sync
//   disconnect: destroys the editor
//
// Events dispatched on the controller element:
//   form-js:editor:ready   - { detail: { editor } }
//   form-js:editor:changed - after schema sync
//
export default class extends Controller {
  static values = {
    schema: { type: Object, default: { type: "default", components: [] } }
  }

  static targets = ["container", "schemaField"]

  connect() {
    if (typeof FormEditor === "undefined") {
      console.error("[bpmn-js-rails] FormEditor global not found. Make sure form-editor.umd.js is loaded.")
      return
    }

    const renderTarget = this.hasContainerTarget ? this.containerTarget : this.element

    FormEditor.createFormEditor({
      container: renderTarget,
      schema: this.schemaValue
    }).then((editor) => {
      this.editor = editor

      editor.on("changed", () => {
        this._syncSchemaField()
        this.dispatch("changed")
      })

      // Also sync right before the enclosing <form> submits
      this._form = this.element.closest("form")
      if (this._form) {
        this._boundSubmitHandler = () => this._syncSchemaField()
        this._form.addEventListener("submit", this._boundSubmitHandler)
      }

      this.dispatch("ready", { detail: { editor } })
    })
  }

  disconnect() {
    if (this._form && this._boundSubmitHandler) {
      this._form.removeEventListener("submit", this._boundSubmitHandler)
      this._boundSubmitHandler = null
      this._form = null
    }

    if (this.editor) {
      this.editor.destroy()
      this.editor = null
    }
  }

  // Serialise the current editor schema into the hidden field target.
  _syncSchemaField() {
    if (!this.editor || !this.hasSchemaFieldTarget) return
    try {
      this.schemaFieldTarget.value = JSON.stringify(this.editor.saveSchema())
    } catch (_) {
      // editor may be mid-import; ignore
    }
  }
}
