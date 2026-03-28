// node_modules/bpmn-js/lib/util/ModelUtil.js
function getBusinessObject(element) {
  return element && element.businessObject || element;
}

// node_modules/@bpmn-io/element-template-chooser/dist/index.es.js
function ElementTemplateChooser(config, eventBus, elementTemplates, translate, popupMenu) {
  this._eventBus = eventBus;
  this._elementTemplates = elementTemplates;
  this._translate = translate;
  this._popupMenu = popupMenu;
  const enableChooser = !config || config.elementTemplateChooser !== false;
  enableChooser && eventBus.on("elementTemplates.select", (event) => {
    const { element } = event;
    this.open(element).then((template) => {
      elementTemplates.applyTemplate(element, template);
    }).catch((err) => {
      if (err !== "user-canceled") {
        console.error("elementTemplate.select :: error", err);
      }
    });
  });
}
ElementTemplateChooser.$inject = [
  "config.connectorsExtension",
  "eventBus",
  "elementTemplates",
  "translate",
  "popupMenu"
];
ElementTemplateChooser.prototype.open = function(element) {
  const popupMenu = this._popupMenu;
  const translate = this._translate;
  const eventBus = this._eventBus;
  return new Promise((resolve, reject) => {
    const handleClosed = () => reject("user-canceled");
    eventBus.once("popupMenu.close", handleClosed);
    eventBus.once("elementTemplateChooser.chosen", (event) => {
      const { template } = event;
      eventBus.off("popupMenu.close", handleClosed);
      resolve(template);
    });
    popupMenu.open(element, "element-template-chooser", { x: 0, y: 0 }, {
      title: translate("Choose element template"),
      search: true,
      width: 350
    });
  });
};
function ElementTemplateChooserEntryProvider(popupMenu, eventBus, translate, elementTemplates) {
  this._popupMenu = popupMenu;
  this._eventBus = eventBus;
  this._translate = translate;
  this._elementTemplates = elementTemplates;
  this.register();
}
ElementTemplateChooserEntryProvider.$inject = [
  "popupMenu",
  "eventBus",
  "translate",
  "elementTemplates"
];
ElementTemplateChooserEntryProvider.prototype.register = function() {
  this._popupMenu.registerProvider("element-template-chooser", this);
};
ElementTemplateChooserEntryProvider.prototype.getPopupMenuEntries = function(element) {
  return this.getTemplateEntries(element).reduce((entries, [key, value]) => {
    entries[key] = value;
    return entries;
  }, {});
};
ElementTemplateChooserEntryProvider.prototype.getTemplateEntries = function(element) {
  const eventBus = this._eventBus;
  const translate = this._translate;
  return this._getMatchingTemplates(element).map((template) => {
    const {
      icon = {},
      category,
      keywords = []
    } = template;
    const entryId = `apply-template-${template.id}`;
    return [entryId, {
      label: template.name && translate(template.name),
      description: template.description && translate(template.description),
      documentationRef: template.documentationRef,
      imageUrl: icon.contents,
      search: keywords,
      group: category && { ...category, name: translate(category.name) },
      action: () => {
        eventBus.fire("elementTemplateChooser.chosen", { element, template });
      }
    }];
  });
};
ElementTemplateChooserEntryProvider.prototype._getMatchingTemplates = function(element) {
  return this._elementTemplates.getLatest(element).filter((template) => {
    return !isTemplateApplied(element, template);
  });
};
function isTemplateApplied(element, template) {
  const businessObject = getBusinessObject(element);
  if (businessObject) {
    return businessObject.get("modelerTemplate") === template.id;
  }
  return false;
}
var index = {
  __init__: [
    "elementTemplateChooser",
    "elementTemplateChooserEntryProvider"
  ],
  elementTemplateChooser: ["type", ElementTemplateChooser],
  elementTemplateChooserEntryProvider: ["type", ElementTemplateChooserEntryProvider]
};

// app/javascript/bpmn_js_rails/entrypoints/element_template_chooser.js
var element_template_chooser_default = index;
export {
  index as ElementTemplateChooserModule,
  element_template_chooser_default as default
};
//# sourceMappingURL=/assets/element_template_chooser.js.map
