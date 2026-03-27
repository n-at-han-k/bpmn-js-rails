Form(model: diagram, url: diagram.persisted? ? diagram_path(diagram) : diagrams_path, class: "ui form bpmn-form") {
  if diagram.errors.any?
    Message(type: :error) { |c|
      c.header { text pluralize(diagram.errors.count, "error") + " prohibited this diagram from being saved" }
      diagram.errors.full_messages.each { |msg| Paragraph { text msg } }
    }
  end

  Wrapper(html_class: "bpmn-header-bar") {
    VStack(spacing: 8) {
      HStack(spacing: 12, align: "end") {
        Wrapper(style: "flex: 1;") {
          TextField(:name, placeholder: "Diagram name")
        }
        Select(:status, BpmnJsRails::Diagram::STATUSES)
        Button(variant: :primary, type: :submit, icon: "save", size: :small) {
          text diagram.persisted? ? "Update" : "Create"
        }
        if diagram.persisted?
          Button(href: diagram_path(diagram), size: :small, variant: :basic, icon: "eye") { text "View" }
        end
        Button(href: diagrams_path, size: :small, variant: :basic, icon: "arrow left") { text "Back" }
      }
      TextField(:description, placeholder: "Optional description")
    }
  }

  Wrapper(html_class: "bpmn-content") {
    BpmnJsModeler(diagram, field_name: "diagram[xml]")
  }
}
