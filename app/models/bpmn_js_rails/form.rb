# frozen_string_literal: true

module BpmnJsRails
  class Form < ActiveRecord::Base
    self.table_name = "bpmn_js_rails_forms"

    STATUSES = %w[draft published].freeze

    validates :name, presence: true
    validates :schema, presence: true
    validates :status, inclusion: { in: STATUSES }

    scope :draft, -> { where(status: "draft") }
    scope :published, -> { where(status: "published") }

    attribute :schema, :json, default: -> { { "type" => "default", "components" => [] } }
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
