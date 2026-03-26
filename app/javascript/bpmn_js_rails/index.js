import BpmnJsViewerController from "bpmn_js_rails/controllers/bpmn_js_viewer_controller"
import BpmnJsModelerController from "bpmn_js_rails/controllers/bpmn_js_modeler_controller"
import FormJsViewerController from "bpmn_js_rails/controllers/form_js_viewer_controller"
import FormJsEditorController from "bpmn_js_rails/controllers/form_js_editor_controller"
import DmnJsViewerController from "bpmn_js_rails/controllers/dmn_js_viewer_controller"
import DmnJsModelerController from "bpmn_js_rails/controllers/dmn_js_modeler_controller"

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
export function registerBpmnJsControllers(application) {
  application.register("bpmn-js-viewer", BpmnJsViewerController)
  application.register("bpmn-js-modeler", BpmnJsModelerController)
  application.register("form-js-viewer", FormJsViewerController)
  application.register("form-js-editor", FormJsEditorController)
  application.register("dmn-js-viewer", DmnJsViewerController)
  application.register("dmn-js-modeler", DmnJsModelerController)
}

export {
  BpmnJsViewerController,
  BpmnJsModelerController,
  FormJsViewerController,
  FormJsEditorController,
  DmnJsViewerController,
  DmnJsModelerController
}
