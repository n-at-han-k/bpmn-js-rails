import "bpmn-js/camunda-platform-modeler.production.min"

const CamundaPlatformModeler = globalThis.BpmnModeler

if (!CamundaPlatformModeler) {
  throw new Error("[bpmn-js-rails] Camunda platform modeler failed to load")
}

export default CamundaPlatformModeler
