import { Application } from "@hotwired/stimulus"
import { registerBpmnJsControllers } from "bpmn_js_rails"

const application = Application.start()
registerBpmnJsControllers(application)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
