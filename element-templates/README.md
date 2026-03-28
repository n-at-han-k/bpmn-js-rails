# Element Template Examples

This directory contains copied upstream element template examples and local Kremlin examples.

## Sources

- `camunda/` and `camunda-modeler/all/`: Camunda Modeler `resources/element-templates`
- `upstream/bpmn-js-element-templates-camunda7/`: bpmn-js-element-templates C7 test fixtures
- `upstream/bpmn-js-element-templates-camunda8/`: bpmn-js-element-templates C8 test fixtures
- `upstream/element-templates-json-schema-example/`: element-templates-json-schema example files
- `kremlin.templates.json` and `kremlin.advanced.templates.json`: local starter templates

## Split Folders

Every JSON file with a top-level array has a sibling split folder with one file per entry.

Example:

- `camunda/cloud-samples.json`
- `camunda/cloud-samples/001--io-camunda-examples-emailconnector.json`
- `camunda/cloud-samples/manifest.json`

Each split folder contains:

- one JSON object per template entry
- `manifest.json` with deterministic file ordering for runtime concatenation
