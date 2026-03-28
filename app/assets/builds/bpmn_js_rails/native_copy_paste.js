// node_modules/min-dash/dist/index.js
var nativeToString = Object.prototype.toString;
function isObject(obj) {
  return nativeToString.call(obj) === "[object Object]";
}
function isString(obj) {
  return nativeToString.call(obj) === "[object String]";
}

// node_modules/bpmn-js-native-copy-paste/lib/PasteUtil.js
function createReviver(moddle) {
  const elementCache = {};
  return function(key, object) {
    if (isObject(object) && isString(object.$type)) {
      const { id } = object;
      if (id && elementCache[id]) {
        return elementCache[id];
      }
      const type = object.$type;
      const attrs = Object.assign({}, object);
      delete attrs.$type;
      const descriptor = moddle.getTypeDescriptor(type);
      if (!descriptor) {
        return;
      }
      const newElement = moddle.create(type, attrs);
      if (id) {
        elementCache[id] = newElement;
      }
      return newElement;
    }
    return object;
  };
}

// node_modules/bpmn-js-native-copy-paste/lib/NativeCopyPaste.js
var HIGHER_PRIORITY = 2050;
var PREFIX = "bpmn-js-clip----";
var NativeCopyPaste = class {
  constructor(eventBus, copyPaste, moddle) {
    this._eventBus = eventBus;
    this._handleCopied = (context) => {
      if (context.hints?.clip !== false) {
        navigator.clipboard.writeText(PREFIX + JSON.stringify(context.tree)).catch((err) => {
          this._handleError("failed to populate clipboard", err);
        });
        context.hints.clip = false;
      }
    };
    this._handlePaste = (context) => {
      if (context.tree) {
        return;
      }
      const contextCopy = { ...context };
      navigator.clipboard.readText().then((text) => {
        if (!text?.startsWith(PREFIX)) {
          return;
        }
        const tree = JSON.parse(text.substring(PREFIX.length), createReviver(moddle));
        copyPaste.paste({
          ...contextCopy,
          tree
        });
      }).catch((err) => {
        this._handleError("failed to paste from clipboard", err);
      });
      return false;
    };
    this._handleError = (message, error) => {
      console.error("[native-copy-paste]", message, error);
      this._eventBus.fire("native-copy-paste:error", { message, error });
    };
    this.toggle(typeof navigator.clipboard !== "undefined");
  }
  /**
   * Enable or disable native copy and paste.
   *
   * @param {boolean} active
   */
  toggle(active) {
    if (this._active === active) {
      return;
    }
    if (active) {
      this._eventBus.on("copyPaste.elementsCopied", HIGHER_PRIORITY, this._handleCopied);
      this._eventBus.on("copyPaste.pasteElements", HIGHER_PRIORITY, this._handlePaste);
    } else {
      this._eventBus.off("copyPaste.elementsCopied", this._handleCopied);
      this._eventBus.off("copyPaste.pasteElements", this._handlePaste);
    }
    this._active = active;
  }
};
NativeCopyPaste.$inject = [
  "eventBus",
  "copyPaste",
  "moddle"
];

// node_modules/bpmn-js-native-copy-paste/lib/index.js
var lib_default = {
  __init__: ["nativeCopyPaste"],
  nativeCopyPaste: ["type", NativeCopyPaste]
};

// app/javascript/bpmn_js_rails/entrypoints/native_copy_paste.js
var native_copy_paste_default = lib_default;
export {
  lib_default as NativeCopyPasteModule,
  native_copy_paste_default as default
};
//# sourceMappingURL=/assets/native_copy_paste.js.map
