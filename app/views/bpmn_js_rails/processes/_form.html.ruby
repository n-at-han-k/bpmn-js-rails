Form(model: process, url: process.persisted? ? process_path(process) : processes_path, class: "ui form bpmn-form") {
  if process.errors.any?
    Message(type: :error) { |c|
      c.header { text pluralize(process.errors.count, "error") + " prohibited this process from being saved" }
      process.errors.full_messages.each { |msg| Paragraph { text msg } }
    }
  end

  Wrapper(html_class: "bpmn-header-bar") {
    VStack(spacing: 8) {
      HStack(spacing: 12, align: "end") {
        Wrapper(style: "flex: 1;") {
          TextField(:name, placeholder: "Process name")
        }
        Select(:status, BpmnJsRails::Process::STATUSES)
        Button(variant: :primary, type: :submit, icon: "save", size: :small) {
          text process.persisted? ? "Update" : "Create"
        }
        if process.persisted?
          Button(href: process_path(process), size: :small, variant: :basic, icon: "eye") { text "View" }
        end
        Button(href: processes_path, size: :small, variant: :basic, icon: "arrow left") { text "Back" }
      }
      TextField(:description, placeholder: "Optional description")
    }
  }

  Wrapper(html_class: "bpmn-content") {
    BpmnJsModeler(process, field_name: "process[xml]")
  }
}
