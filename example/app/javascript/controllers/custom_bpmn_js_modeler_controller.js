import BaseBpmnJsModelerController from "bpmn_js_rails/controllers/bpmn_js_modeler_controller"
import { ElementTemplatesModule } from "bpmn_js_rails/element_templates"
import ElementTemplateChooserModule from "bpmn_js_rails/element_template_chooser"
import NativeCopyPasteModule from "bpmn_js_rails/native_copy_paste"

export default class extends BaseBpmnJsModelerController {
  modelerOptions(renderTarget) {
    const options = super.modelerOptions(renderTarget)

    return {
      ...options,
      additionalModules: [
        ...(options.additionalModules || []),
        ...ElementTemplatesModule,
        ElementTemplateChooserModule,
        NativeCopyPasteModule
      ]
    }
  }

  async connect() {
    await super.connect()

    this.modeler.on("elementTemplates.errors", ({ errors }) => {
      console.error("[example] Element template errors:", errors)
    })

    const eventBus = this.modeler.get("eventBus")
    const nativeCopyPaste = this.modeler.get("nativeCopyPaste")

    eventBus.on("native-copy-paste:error", ({ message, error }) => {
      console.warn("[example] Native clipboard rejected, fallback to local:", message, error)
      nativeCopyPaste.toggle(false)
    })

    if (this.elementTemplatesValue?.length) {
      this.modeler.get("elementTemplatesLoader").setTemplates(this.elementTemplatesValue)
    }
  }
}
