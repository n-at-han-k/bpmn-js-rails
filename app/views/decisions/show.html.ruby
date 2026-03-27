content_for(:head) { dmn_js_assets(:viewer) }

Wrapper(id: "bpmn-app") {
  Wrapper(html_class: "bpmn-header-bar") {
    HStack(justify: "between", align: "center") {
      HStack(spacing: 12, align: "center") {
        Header(size: :h3) { text @decision.name }
        Label(color: @decision.status == "published" ? :green : :grey, size: :small) { text @decision.status }
        Text(size: :small, color: :grey) { text "v#{@decision.version}" }
      }
      HStack(spacing: 8) {
        Button(href: edit_decision_path(@decision), size: :small, variant: :primary, icon: "edit") { text "Edit" }
        Button(href: decisions_path, size: :small, variant: :basic, icon: "arrow left") { text "Back" }
      }
    }
    if @decision.description.present?
      Wrapper(html_class: "bpmn-description") { text @decision.description }
    end
  }
  Wrapper(html_class: "bpmn-content") {
    DmnJsViewer(@decision)
  }
}
