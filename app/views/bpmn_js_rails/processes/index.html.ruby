HStack(justify: "between", align: "center") {
  Header(size: :h2) { text "Processes" }
  Button(href: new_process_path, variant: :primary, icon: "plus") { text "New Process" }
}

Divider(hidden: true)

if @processes.any?
  text datatable(columns: ["Name", "Description", "Status", "Version", "Updated", "Actions"]) {
    capture {
      @processes.each do |process|
        TableRow {
          TableCell { Link(href: process_path(process)) { text process.name } }
          TableCell { text truncate(process.description.to_s, length: 60) }
          TableCell {
            Label(color: process.status == "published" ? :green : :grey, size: :mini) { text process.status }
          }
          TableCell { text process.version.to_s }
          TableCell { text time_ago_in_words(process.updated_at) + " ago" }
          TableCell {
            HStack(spacing: 4) {
              Button(href: process_path(process), size: :mini, variant: :basic, icon: "eye")
              Button(href: edit_process_path(process), size: :mini, variant: :basic, icon: "edit")
              output_buffer << link_to(process_path(process), class: "ui mini basic red button", data: { turbo_method: :delete, turbo_confirm: "Are you sure?" }) {
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
    text "No processes yet. "
    Link(href: new_process_path) { text "Create one" }
  }
end
