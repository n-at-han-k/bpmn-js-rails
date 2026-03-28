import BpmnJsViewerController from "bpmn_js_rails/controllers/bpmn_js_viewer_controller"
import BpmnJsModelerController from "bpmn_js_rails/controllers/bpmn_js_modeler_controller"
import FormJsViewerController from "bpmn_js_rails/controllers/form_js_viewer_controller"
import FormJsEditorController from "bpmn_js_rails/controllers/form_js_editor_controller"
import DmnJsViewerController from "bpmn_js_rails/controllers/dmn_js_viewer_controller"
import DmnJsModelerController from "bpmn_js_rails/controllers/dmn_js_modeler_controller"
import { BpmnPropertiesModules } from "bpmn_js_rails/properties_panel"
import { ElementTemplatesModule } from "bpmn_js_rails/element_templates"
import ElementTemplateChooserModule from "bpmn_js_rails/element_template_chooser"
import NativeCopyPasteModule from "bpmn_js_rails/native_copy_paste"

// Register all bpmn-js-rails Stimulus controllers with the host application.
//
// Usage in your controllers/application.js:
//
//   import { Application } from "@hotwired/stimulus"
//   import { registerBpmnJsControllers } from "bpmn_js_rails"
//
//   const application = Application.start()
//   registerBpmnJsControllers(application)
//
export function registerBpmnJsControllers(application, overrides = {}) {
  application.register("bpmn-js-viewer", overrides.bpmnJsViewer || BpmnJsViewerController)
  application.register("bpmn-js-modeler", overrides.bpmnJsModeler || BpmnJsModelerController)
  application.register("form-js-viewer", overrides.formJsViewer || FormJsViewerController)
  application.register("form-js-editor", overrides.formJsEditor || FormJsEditorController)
  application.register("dmn-js-viewer", overrides.dmnJsViewer || DmnJsViewerController)
  application.register("dmn-js-modeler", overrides.dmnJsModeler || DmnJsModelerController)
}

export {
  BpmnJsViewerController,
  BpmnJsModelerController,
  FormJsViewerController,
  FormJsEditorController,
  DmnJsViewerController,
  DmnJsModelerController,
  BpmnPropertiesModules,
  ElementTemplatesModule,
  ElementTemplateChooserModule,
  NativeCopyPasteModule
}
