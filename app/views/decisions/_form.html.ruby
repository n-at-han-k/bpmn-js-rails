Form(model: decision, url: decision.persisted? ? decision_path(decision) : decisions_path, class: "ui form bpmn-form") {
  if decision.errors.any?
    Message(type: :error) { |c|
      c.header { text pluralize(decision.errors.count, "error") + " prohibited this decision from being saved" }
      decision.errors.full_messages.each { |msg| Paragraph { text msg } }
    }
  end

  Wrapper(html_class: "bpmn-header-bar") {
    VStack(spacing: 8) {
      HStack(spacing: 12, align: "end") {
        Wrapper(style: "flex: 1;") {
          TextField(:name, placeholder: "Decision name")
        }
        Select(:status, BpmnJsRails::Decision::STATUSES)
        Button(variant: :primary, type: :submit, icon: "save", size: :small) {
          text decision.persisted? ? "Update" : "Create"
        }
        if decision.persisted?
          Button(href: decision_path(decision), size: :small, variant: :basic, icon: "eye") { text "View" }
        end
        Button(href: decisions_path, size: :small, variant: :basic, icon: "arrow left") { text "Back" }
      }
      TextField(:description, placeholder: "Optional description")
    }
  }

  Wrapper(html_class: "bpmn-content") {
    DmnJsModeler(decision, field_name: "decision[xml]")
  }
}
