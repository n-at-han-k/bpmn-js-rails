content_for(:head) { dmn_js_assets(:modeler) }

Wrapper(id: "bpmn-app") {
  Partial("form", decision: @decision)
}
