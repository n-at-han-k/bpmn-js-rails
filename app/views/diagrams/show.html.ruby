content_for(:head) { bpmn_js_assets(:viewer) }

Wrapper(id: "bpmn-app") {
  Wrapper(html_class: "bpmn-header-bar") {
    HStack(justify: "between", align: "center") {
      HStack(spacing: 12, align: "center") {
        Header(size: :h3) { text @diagram.name }
        Label(color: @diagram.status == "published" ? :green : :grey, size: :small) { text @diagram.status }
        Text(size: :small, color: :grey) { text "v#{@diagram.version}" }
      }
      HStack(spacing: 8) {
        Button(href: edit_diagram_path(@diagram), size: :small, variant: :primary, icon: "edit") { text "Edit" }
        Button(href: diagrams_path, size: :small, variant: :basic, icon: "arrow left") { text "Back" }
      }
    }
    if @diagram.description.present?
      Wrapper(html_class: "bpmn-description") { text @diagram.description }
    end
  }
  Wrapper(html_class: "bpmn-content") {
    BpmnJsViewer(@diagram)
  }
}
