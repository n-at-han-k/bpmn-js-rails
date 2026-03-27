HStack(justify: "between", align: "center") {
  Header(size: :h2) { text "Forms" }
  Button(href: new_form_path, variant: :primary, icon: "plus") { text "New Form" }
}

Divider(hidden: true)

if @forms.any?
  text datatable(columns: ["Name", "Description", "Status", "Version", "Updated", "Actions"]) {
    capture {
      @forms.each do |form|
        TableRow {
          TableCell { Link(href: form_path(form)) { text form.name } }
          TableCell { text truncate(form.description.to_s, length: 60) }
          TableCell {
            Label(color: form.status == "published" ? :green : :grey, size: :mini) { text form.status }
          }
          TableCell { text form.version.to_s }
          TableCell { text time_ago_in_words(form.updated_at) + " ago" }
          TableCell {
            HStack(spacing: 4) {
              Button(href: form_path(form), size: :mini, variant: :basic, icon: "eye")
              Button(href: edit_form_path(form), size: :mini, variant: :basic, icon: "edit")
              output_buffer << link_to(form_path(form), class: "ui mini basic red button", data: { turbo_method: :delete, turbo_confirm: "Are you sure?" }) {
                capture { Icon(name: "trash") }
              }
            }
          }
        }
      end
    }
  }
else
  Message(type: :info) {
    text "No forms yet. "
    Link(href: new_form_path) { text "Create one" }
  }
end
