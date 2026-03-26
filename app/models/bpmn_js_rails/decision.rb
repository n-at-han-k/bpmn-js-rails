# frozen_string_literal: true

module BpmnJsRails
  class Decision < ActiveRecord::Base
    self.table_name = "bpmn_js_rails_decisions"

    STATUSES = %w[draft published].freeze

    DEFAULT_XML = <<~DMN
      <?xml version="1.0" encoding="UTF-8"?>
      <definitions xmlns="https://www.omg.org/spec/DMN/20191111/MODEL/"
                   xmlns:dmndi="https://www.omg.org/spec/DMN/20191111/DMNDI/"
                   xmlns:dc="http://www.omg.org/spec/DMN/20180521/DC/"
                   id="Definitions_1"
                   name="definitions"
                   namespace="http://camunda.org/schema/1.0/dmn">
        <decision id="Decision_1" name="Decision">
          <decisionTable id="DecisionTable_1">
            <input id="Input_1" label="">
              <inputExpression id="InputExpression_1" typeRef="string">
                <text></text>
              </inputExpression>
            </input>
            <output id="Output_1" label="" name="" typeRef="string" />
          </decisionTable>
        </decision>
        <dmndi:DMNDI>
          <dmndi:DMNDiagram id="DMNDiagram_1">
            <dmndi:DMNShape id="DMNShape_1" dmnElementRef="Decision_1">
              <dc:Bounds height="80" width="180" x="250" y="300" />
            </dmndi:DMNShape>
          </dmndi:DMNDiagram>
        </dmndi:DMNDI>
      </definitions>
    DMN

    validates :name, presence: true
    validates :xml, presence: true
    validates :status, inclusion: { in: STATUSES }

    scope :draft, -> { where(status: "draft") }
    scope :published, -> { where(status: "published") }

    attribute :xml, :string, default: -> { DEFAULT_XML }
    attribute :status, :string, default: "draft"
    attribute :version, :integer, default: 1

    def published?
      status == "published"
    end

    def draft?
      status == "draft"
    end

    def publish!
      update!(status: "published")
    end
  end
end
