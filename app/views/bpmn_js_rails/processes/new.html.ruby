content_for(:head) { bpmn_js_assets(:modeler) }

Wrapper(id: "bpmn-app") {
  Partial("form", process: @process)
}
