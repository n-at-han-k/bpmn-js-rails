content_for(:head) { form_js_assets(:viewer, :editor) }

Wrapper(id: "bpmn-app") {
  Partial("form", form: @form)
}
