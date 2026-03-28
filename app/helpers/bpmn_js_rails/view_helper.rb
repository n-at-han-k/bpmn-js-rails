# frozen_string_literal: true

module BpmnJsRails
  module ViewHelper
    # ── form-js assets ───────────────────────────────────────────────

    # Render <link> and <script> tags for form-js assets.
    #
    #   <%= form_js_assets %>                    # viewer only
    #   <%= form_js_assets(:viewer, :editor) %>  # both viewer and editor
    #
    def form_js_assets(*components)
      components = [ :viewer ] if components.empty?
      tags = []

      tags << tag.link(
        rel: "stylesheet",
        href: "https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:ital,wght@0,400;0,600;1,400&display=swap"
      )

      tags << stylesheet_link_tag("form-js/form-js", "data-turbo-track": "reload")

      if components.include?(:editor)
        tags << stylesheet_link_tag("form-js/form-js-editor", "data-turbo-track": "reload")
      end

      safe_join(tags, "\n")
    end

    # Render a form-js viewer that displays/fills a form.
    #
    #   <%= form_js_viewer(@form) %>
    #   <%= form_js_viewer(@form, data: { name: "John" }) %>
    #   <%= form_js_viewer({ type: "default", components: [...] }) %>
    #
    def form_js_viewer(form_or_schema, data: {}, **html_options)
      schema = extract_schema(form_or_schema)

      html_options[:class] = Array(html_options[:class]).push("form-js-viewer-container").join(" ")
      html_options[:style] = [ html_options[:style], "min-height: 200px" ].compact.join("; ")

      html_options[:data] = (html_options[:data] || {}).merge(
        controller: "form-js-viewer",
        form_js_viewer_schema_value: schema.to_json,
        form_js_viewer_data_value: data.to_json
      )

      content_tag(:div, "", **html_options)
    end

    # Render a form-js editor for designing forms.
    #
    #   <%= form_js_editor(@form) %>
    #   <%= form_js_editor(@form, field_name: "form[schema]") %>
    #
    def form_js_editor(form_or_schema, field_name: nil, **html_options)
      schema = extract_schema(form_or_schema)

      html_options[:class] = Array(html_options[:class]).push("form-js-editor-container").join(" ")

      html_options[:data] = (html_options[:data] || {}).merge(
        controller: "form-js-editor",
        form_js_editor_schema_value: schema.to_json
      )

      content_tag(:div, **html_options) do
        children = []
        children << content_tag(:div, "", style: "min-height: 500px", data: { form_js_editor_target: "container" })

        if field_name
          children << tag.input(
            type: "hidden",
            name: field_name,
            value: schema.to_json,
            data: { form_js_editor_target: "schemaField" }
          )
        end

        safe_join(children)
      end
    end

    # ── bpmn-js assets ───────────────────────────────────────────────

    # Render stylesheet <link> tags for bpmn-js assets.
    #
    #   <%= bpmn_js_assets %>                                             # viewer only
    #   <%= bpmn_js_assets(:viewer, :modeler) %>
    #
    def bpmn_js_assets(*components)
      components = [ :viewer ] if components.empty?
      tags = []

      tags << stylesheet_link_tag("bpmn-js/diagram-js", "data-turbo-track": "reload")
      tags << stylesheet_link_tag("bpmn-js/bpmn-js", "data-turbo-track": "reload")
      tags << stylesheet_link_tag("bpmn-js/bpmn-font/css/bpmn-embedded", "data-turbo-track": "reload")

      if components.include?(:modeler)
        tags << stylesheet_link_tag("bpmn-js/diagram-js-minimap", "data-turbo-track": "reload")
        tags << stylesheet_link_tag("bpmn-js/properties-panel", "data-turbo-track": "reload")
        tags << stylesheet_link_tag("bpmn-js/color-picker", "data-turbo-track": "reload")
        tags << stylesheet_link_tag("bpmn-js/element-templates", "data-turbo-track": "reload")
        tags << stylesheet_link_tag("bpmn-js/element-template-chooser", "data-turbo-track": "reload")
      end

      safe_join(tags, "\n")
    end

    # Render a bpmn-js viewer that displays a BPMN process (read-only).
    #
    #   <%= bpmn_js_viewer(@process) %>
    #   <%= bpmn_js_viewer("<bpmn:definitions ...>...</bpmn:definitions>") %>
    #
    def bpmn_js_viewer(process_or_xml, **html_options)
      xml = extract_xml(process_or_xml)

      html_options[:class] = Array(html_options[:class]).push("bpmn-js-viewer-container").join(" ")
      html_options[:style] = [ html_options[:style], "height: 500px" ].compact.join("; ")

      html_options[:data] = (html_options[:data] || {}).merge(
        controller: "bpmn-js-viewer",
        bpmn_js_viewer_xml_value: xml
      )

      content_tag(:div, "", **html_options)
    end

    # Render a bpmn-js modeler for designing BPMN processes.
    #
    #   <%= bpmn_js_modeler(@process) %>
    #   <%= bpmn_js_modeler(@process, field_name: "process[xml]") %>
    #   <%= bpmn_js_modeler(@process, properties_panel: false) %>
    #
    def bpmn_js_modeler(process_or_xml, field_name: nil, properties_panel: true, **html_options)
      xml = extract_xml(process_or_xml)

      html_options[:class] = Array(html_options[:class]).push("bpmn-js-modeler-container").join(" ")
      html_options[:style] = [ html_options[:style], "position: relative", "height: 500px" ].compact.join("; ")

      html_options[:data] = (html_options[:data] || {}).merge(
        controller: "bpmn-js-modeler",
        bpmn_js_modeler_xml_value: xml,
        bpmn_js_modeler_properties_panel_enabled_value: properties_panel
      )

      content_tag(:div, **html_options) do
        children = []

        children << content_tag(:div, style: "display: flex; height: 100%") do
          canvas = content_tag(:div, "", style: "flex: 1 1 auto; height: 100%", data: { bpmn_js_modeler_target: "container" })

          if properties_panel
            panel = content_tag(
              :div,
              "",
              style: "flex: 0 0 320px; height: 100%; border-left: 1px solid #ddd; overflow: auto",
              data: { bpmn_js_modeler_target: "propertiesPanel" }
            )
            safe_join([ canvas, panel ])
          else
            canvas
          end
        end

        if field_name
          children << tag.input(
            type: "hidden",
            name: field_name,
            value: xml,
            data: { bpmn_js_modeler_target: "xmlField" }
          )
        end

        safe_join(children)
      end
    end

    # ── dmn-js assets ────────────────────────────────────────────────

    # Render <link> and <script> tags for dmn-js assets.
    #
    #   <%= dmn_js_assets %>                       # viewer only
    #   <%= dmn_js_assets(:viewer, :modeler) %>    # both viewer and modeler
    #
    def dmn_js_assets(*components)
      components = [ :viewer ] if components.empty?
      tags = []

      tags << stylesheet_link_tag("dmn-js/diagram-js", "data-turbo-track": "reload")
      tags << stylesheet_link_tag("dmn-js/dmn-js-shared", "data-turbo-track": "reload")
      tags << stylesheet_link_tag("dmn-js/dmn-js-drd", "data-turbo-track": "reload")
      tags << stylesheet_link_tag("dmn-js/dmn-js-decision-table", "data-turbo-track": "reload")
      tags << stylesheet_link_tag("dmn-js/dmn-js-literal-expression", "data-turbo-track": "reload")
      tags << stylesheet_link_tag("dmn-js/dmn-js-boxed-expression", "data-turbo-track": "reload")
      tags << stylesheet_link_tag("dmn-js/dmn-font/css/dmn-embedded", "data-turbo-track": "reload")

      if components.include?(:modeler)
        tags << stylesheet_link_tag("dmn-js/dmn-js-decision-table-controls", "data-turbo-track": "reload")
        tags << stylesheet_link_tag("dmn-js/dmn-js-boxed-expression-controls", "data-turbo-track": "reload")
      end

      safe_join(tags, "\n")
    end

    # Render a dmn-js viewer that displays a DMN decision (read-only).
    #
    #   <%= dmn_js_viewer(@decision) %>
    #   <%= dmn_js_viewer("<definitions ...>...</definitions>") %>
    #
    def dmn_js_viewer(decision_or_xml, **html_options)
      xml = extract_dmn_xml(decision_or_xml)

      html_options[:class] = Array(html_options[:class]).push("dmn-js-viewer-container").join(" ")
      html_options[:style] = [ html_options[:style], "height: 500px" ].compact.join("; ")

      html_options[:data] = (html_options[:data] || {}).merge(
        controller: "dmn-js-viewer",
        dmn_js_viewer_xml_value: xml
      )

      content_tag(:div, "", **html_options)
    end

    # Render a dmn-js modeler for designing DMN decisions.
    #
    #   <%= dmn_js_modeler(@decision) %>
    #   <%= dmn_js_modeler(@decision, field_name: "decision[xml]") %>
    #
    def dmn_js_modeler(decision_or_xml, field_name: nil, **html_options)
      xml = extract_dmn_xml(decision_or_xml)

      html_options[:class] = Array(html_options[:class]).push("dmn-js-modeler-container").join(" ")

      html_options[:data] = (html_options[:data] || {}).merge(
        controller: "dmn-js-modeler",
        dmn_js_modeler_xml_value: xml
      )

      content_tag(:div, **html_options) do
        children = []
        children << content_tag(:div, "", style: "height: 500px", data: { dmn_js_modeler_target: "container" })

        if field_name
          children << tag.input(
            type: "hidden",
            name: field_name,
            value: xml,
            data: { dmn_js_modeler_target: "xmlField" }
          )
        end

        safe_join(children)
      end
    end

    # ── PascalCase helpers for .html.ruby views ─────────────────

    def BpmnJsViewer(process_or_xml, **html_options)
      output_buffer << bpmn_js_viewer(process_or_xml, **html_options)
    end

    def BpmnJsModeler(process_or_xml, field_name: nil, properties_panel: true, **html_options)
      output_buffer << bpmn_js_modeler(process_or_xml, field_name: field_name, properties_panel: properties_panel, **html_options)
    end

    def FormJsViewer(form_or_schema, data: {}, **html_options)
      output_buffer << form_js_viewer(form_or_schema, data: data, **html_options)
    end

    def FormJsEditor(form_or_schema, field_name: nil, **html_options)
      output_buffer << form_js_editor(form_or_schema, field_name: field_name, **html_options)
    end

    def DmnJsViewer(decision_or_xml, **html_options)
      output_buffer << dmn_js_viewer(decision_or_xml, **html_options)
    end

    def DmnJsModeler(decision_or_xml, field_name: nil, **html_options)
      output_buffer << dmn_js_modeler(decision_or_xml, field_name: field_name, **html_options)
    end

    private

    def extract_schema(form_or_schema)
      case form_or_schema
      when BpmnJsRails::Form
        form_or_schema.schema || { "type" => "default", "components" => [] }
      when Hash
        form_or_schema
      when String
        JSON.parse(form_or_schema)
      else
        form_or_schema.try(:schema) || { "type" => "default", "components" => [] }
      end
    end

    def extract_xml(process_or_xml)
      case process_or_xml
      when BpmnJsRails::Process
        process_or_xml.xml || BpmnJsRails::Process::DEFAULT_XML
      when String
        process_or_xml
      else
        process_or_xml.try(:xml) || BpmnJsRails::Process::DEFAULT_XML
      end
    end

    def extract_dmn_xml(decision_or_xml)
      case decision_or_xml
      when BpmnJsRails::Decision
        decision_or_xml.xml || BpmnJsRails::Decision::DEFAULT_XML
      when String
        decision_or_xml
      else
        decision_or_xml.try(:xml) || BpmnJsRails::Decision::DEFAULT_XML
      end
    end
  end
end
