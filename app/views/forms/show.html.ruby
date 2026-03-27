content_for(:head) { form_js_assets(:viewer) }

Wrapper(id: "bpmn-app") {
  Wrapper(html_class: "bpmn-header-bar") {
    HStack(justify: "between", align: "center") {
      HStack(spacing: 12, align: "center") {
        Header(size: :h3) { text @form.name }
        Label(color: @form.status == "published" ? :green : :grey, size: :small) { text @form.status }
        Text(size: :small, color: :grey) { text "v#{@form.version}" }
      }
      HStack(spacing: 8) {
        Button(href: edit_form_path(@form), size: :small, variant: :primary, icon: "edit") { text "Edit" }
        Button(href: forms_path, size: :small, variant: :basic, icon: "arrow left") { text "Back" }
      }
    }
    if @form.description.present?
      Wrapper(html_class: "bpmn-description") { text @form.description }
    end
  }
  Wrapper(html_class: "bpmn-content") {
    FormJsViewer(@form)
  }
}
