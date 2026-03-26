# frozen_string_literal: true

module BpmnJsRails
  class Engine < ::Rails::Engine
    isolate_namespace BpmnJsRails

    initializer "bpmn_js_rails.assets" do |app|
      app.config.assets.paths << root.join("app/assets/javascripts")
      app.config.assets.paths << root.join("app/assets/stylesheets")
      app.config.assets.paths << root.join("app/javascript")
    end

    initializer "bpmn_js_rails.importmap", before: "importmap" do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << Engine.root.join("config/importmap.rb")
      end
    end

    initializer "bpmn_js_rails.helpers" do
      ActiveSupport.on_load(:action_view) do
        include BpmnJsRails::ViewHelper
      end
    end

    initializer "bpmn_js_rails.migrations" do |app|
      engine_migrate_path = root.join("db/migrate").to_s
      app.config.paths["db/migrate"] << engine_migrate_path
    end
  end
end
