HStack(justify: "between", align: "center") {
  Header(size: :h2) { text "Diagrams" }
  Button(href: new_diagram_path, variant: :primary, icon: "plus") { text "New Diagram" }
}

Divider(hidden: true)

if @diagrams.any?
  text datatable(columns: ["Name", "Description", "Status", "Version", "Updated", "Actions"]) {
    capture {
      @diagrams.each do |diagram|
        TableRow {
          TableCell { Link(href: diagram_path(diagram)) { text diagram.name } }
          TableCell { text truncate(diagram.description.to_s, length: 60) }
          TableCell {
            Label(color: diagram.status == "published" ? :green : :grey, size: :mini) { text diagram.status }
          }
          TableCell { text diagram.version.to_s }
          TableCell { text time_ago_in_words(diagram.updated_at) + " ago" }
          TableCell {
            HStack(spacing: 4) {
              Button(href: diagram_path(diagram), size: :mini, variant: :basic, icon: "eye")
              Button(href: edit_diagram_path(diagram), size: :mini, variant: :basic, icon: "edit")
              output_buffer << link_to(diagram_path(diagram), class: "ui mini basic red button", data: { turbo_method: :delete, turbo_confirm: "Are you sure?" }) {
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
    text "No diagrams yet. "
    Link(href: new_diagram_path) { text "Create one" }
  }
end
