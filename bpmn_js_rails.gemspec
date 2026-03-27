require_relative "lib/bpmn_js_rails/version"

Gem::Specification.new do |spec|
  spec.name        = "bpmn-js-rails"
  spec.version     = BpmnJsRails::VERSION
  spec.authors     = [ "nathan" ]
  spec.email       = [ "nathankidd@hey.com" ]
  spec.homepage    = "https://github.com/general-intelligence-systems/bpmn-js-rails"
  spec.summary     = "bpmn-io/bpmn-js and form-js packaged as a Rails engine"
  spec.description = "bpmn-io/bpmn-js and form-js packaged as a Rails engine"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.1.0"
  spec.add_dependency "ui"
end
