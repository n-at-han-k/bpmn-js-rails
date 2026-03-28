content_for(:head) { bpmn_js_assets(:viewer) }

Wrapper(id: "bpmn-app") {
  Wrapper(html_class: "bpmn-header-bar") {
    HStack(justify: "between", align: "center") {
      HStack(spacing: 12, align: "center") {
        Header(size: :h3) { text @process.name }
        Label(color: @process.status == "published" ? :green : :grey, size: :small) { text @process.status }
        Text(size: :small, color: :grey) { text "v#{@process.version}" }
      }
      HStack(spacing: 8) {
        Button(href: edit_process_path(@process), size: :small, variant: :primary, icon: "edit") { text "Edit" }
        Button(href: processes_path, size: :small, variant: :basic, icon: "arrow left") { text "Back" }
      }
    }
    if @process.description.present?
      Wrapper(html_class: "bpmn-description") { text @process.description }
    end
  }
  Wrapper(html_class: "bpmn-content") {
    BpmnJsViewer(@process)
  }
}
