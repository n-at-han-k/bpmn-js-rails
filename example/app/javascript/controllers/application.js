import { Application } from "@hotwired/stimulus"
import { registerBpmnJsControllers } from "bpmn_js_rails"
import CustomBpmnJsModelerController from "controllers/custom_bpmn_js_modeler_controller"

const application = Application.start()
registerBpmnJsControllers(application, {
  bpmnJsModeler: CustomBpmnJsModelerController
})

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
