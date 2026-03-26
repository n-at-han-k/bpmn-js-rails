# frozen_string_literal: true

module BpmnJsRails
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path("templates", __dir__)

      desc "Install BpmnJsRails: copy migrations for forms, diagrams, and decisions"

      def self.next_migration_number(dirname)
        next_migration_nr = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_nr)
      end

      def copy_migrations
        migration_template(
          "create_bpmn_js_rails_forms.rb.erb",
          "db/migrate/create_bpmn_js_rails_forms.rb"
        )

        migration_template(
          "create_bpmn_js_rails_diagrams.rb.erb",
          "db/migrate/create_bpmn_js_rails_diagrams.rb"
        )

        migration_template(
          "create_bpmn_js_rails_decisions.rb.erb",
          "db/migrate/create_bpmn_js_rails_decisions.rb"
        )
      end

      def show_post_install_message
        say ""
        say "BpmnJsRails installed successfully!", :green
        say ""
        say "Next steps:"
        say "  1. Run migrations:  rails db:migrate"
        say ""
        say "  Forms (form-js):"
        say "    - Add to layout:  <%= form_js_assets %>"
        say "    - Viewer:         <%= form_js_viewer(@form) %>"
        say "    - Editor:         <%= form_js_editor(@form, field_name: 'form[schema]') %>"
        say ""
        say "  Diagrams (bpmn-js):"
        say "    - Add to layout:  <%= bpmn_js_assets %>"
        say "    - Viewer:         <%= bpmn_js_viewer(@diagram) %>"
        say "    - Modeler:        <%= bpmn_js_modeler(@diagram, field_name: 'diagram[xml]') %>"
        say ""
        say "  Decisions (dmn-js):"
        say "    - Add to layout:  <%= dmn_js_assets %>"
        say "    - Viewer:         <%= dmn_js_viewer(@decision) %>"
        say "    - Modeler:        <%= dmn_js_modeler(@decision, field_name: 'decision[xml]') %>"
        say ""
      end
    end
  end
end
