HStack(justify: "between", align: "center") {
  Header(size: :h2) { text "Decisions" }
  Button(href: new_decision_path, variant: :primary, icon: "plus") { text "New Decision" }
}

Divider(hidden: true)

if @decisions.any?
  text datatable(columns: ["Name", "Description", "Status", "Version", "Updated", "Actions"]) {
    capture {
      @decisions.each do |decision|
        TableRow {
          TableCell { Link(href: decision_path(decision)) { text decision.name } }
          TableCell { text truncate(decision.description.to_s, length: 60) }
          TableCell {
            Label(color: decision.status == "published" ? :green : :grey, size: :mini) { text decision.status }
          }
          TableCell { text decision.version.to_s }
          TableCell { text time_ago_in_words(decision.updated_at) + " ago" }
          TableCell {
            HStack(spacing: 4) {
              Button(href: decision_path(decision), size: :mini, variant: :basic, icon: "eye")
              Button(href: edit_decision_path(decision), size: :mini, variant: :basic, icon: "edit")
              output_buffer << link_to(decision_path(decision), class: "ui mini basic red button", data: { turbo_method: :delete, turbo_confirm: "Are you sure?" }) {
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
    text "No decisions yet. "
    Link(href: new_decision_path) { text "Create one" }
  }
end
