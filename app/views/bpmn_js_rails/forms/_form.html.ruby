Form(model: form, url: form.persisted? ? form_path(form) : forms_path, class: "ui form bpmn-form") {
  if form.errors.any?
    Message(type: :error) { |c|
      c.header { text pluralize(form.errors.count, "error") + " prohibited this form from being saved" }
      form.errors.full_messages.each { |msg| Paragraph { text msg } }
    }
  end

  Wrapper(html_class: "bpmn-header-bar") {
    VStack(spacing: 8) {
      HStack(spacing: 12, align: "end") {
        Wrapper(style: "flex: 1;") {
          TextField(:name, placeholder: "Form name")
        }
        Select(:status, BpmnJsRails::Form::STATUSES)
        Button(variant: :primary, type: :submit, icon: "save", size: :small) {
          text form.persisted? ? "Update" : "Create"
        }
        if form.persisted?
          Button(href: form_path(form), size: :small, variant: :basic, icon: "eye") { text "View" }
        end
        Button(href: forms_path, size: :small, variant: :basic, icon: "arrow left") { text "Back" }
      }
      TextField(:description, placeholder: "Optional description")
    }
  }

  Wrapper(html_class: "bpmn-content") {
    FormJsEditor(form, field_name: "form[schema]")
  }
}
