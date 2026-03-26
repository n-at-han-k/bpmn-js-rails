BpmnJsRails::Diagram.find_or_create_by!(name: "Pizza Collaboration") do |diagram|
  diagram.description = "Pizza ordering process between customer and vendor"
  diagram.xml = File.read(File.expand_path("../../mirrors/bpmn-js-examples/bundling/resources/pizza-collaboration.bpmn", __dir__))
end

BpmnJsRails::Form.find_or_create_by!(name: "Invoice Form") do |form|
  form.description = "Full invoice form with groups, dynamic lists, validation, and various field types"
  form.schema = JSON.parse(File.read(File.expand_path("../../mirrors/form-js/packages/form-js-playground/test/spec/form.json", __dir__)))
end

BpmnJsRails::Decision.find_or_create_by!(name: "Dish Decision") do |decision|
  decision.description = "What dish to serve based on season and guest count"
  decision.xml = File.read(File.expand_path("../../mirrors/dmn-js-examples/starter/diagram.dmn", __dir__))
end
