class CreateBpmnJsRailsForms < ActiveRecord::Migration[8.1]
  def change
    create_table :bpmn_js_rails_forms do |t|
      t.string :name, null: false
      t.text :description
      t.json :schema, null: false, default: { type: "default", components: [] }
      t.string :status, null: false, default: "draft"
      t.integer :version, null: false, default: 1

      t.timestamps
    end

    add_index :bpmn_js_rails_forms, :status
  end
end
