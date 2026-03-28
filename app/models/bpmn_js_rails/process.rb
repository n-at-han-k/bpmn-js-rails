# frozen_string_literal: true

module BpmnJsRails
  class Process < ActiveRecord::Base
    self.table_name = "bpmn_js_rails_processes"

    STATUSES = %w[draft published].freeze

    DEFAULT_XML = <<~BPMN
      <?xml version="1.0" encoding="UTF-8"?>
      <bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL"
                        xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI"
                        xmlns:dc="http://www.omg.org/spec/DD/20100524/DC"
                        targetNamespace="http://bpmn.io/schema/bpmn" id="Definitions_1">
        <bpmn:process id="Process_1" isExecutable="false">
          <bpmn:startEvent id="StartEvent_1"/>
        </bpmn:process>
        <bpmndi:BPMNDiagram id="BPMNDiagram_1">
          <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_1">
            <bpmndi:BPMNShape id="_BPMNShape_StartEvent_2" bpmnElement="StartEvent_1">
              <dc:Bounds height="36.0" width="36.0" x="173.0" y="102.0"/>
            </bpmndi:BPMNShape>
          </bpmndi:BPMNPlane>
        </bpmndi:BPMNDiagram>
      </bpmn:definitions>
    BPMN

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
