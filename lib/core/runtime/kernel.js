import { EventBus }    from '/lib/core/event-bus.js'
import { LogBus }      from '/lib/core/log-bus.js'
import { loadIngots }  from '/lib/core/runtime/loader.js'
import { applyCompat } from '/lib/core/compat/v1.js'

export class Kernel {
  constructor(config, options={}) {
    this.objectType  = config.objectType;
    this.name        = config.name;
    this.description = config.description;
    this.version     = config.version;
    this.options     = options;
    this.apiVersion  = config.apiVersion;

    this.events = new EventBus();
    this.logBus = new LogBus();

    this.processes = new Map();
    this.capabilities = new Map();
  }

  async boot() {
    applyCompat(this)

    await loadIngots(this)

    this.logBus.flush()
    await this.events.emit('kernel:booted')
  }

  log(level, message, meta = {}) {
    this.logBus.write({ level, message, meta })
  }

  emit(event, payload) {
    return this.events.emit(event, payload)
  }

  on(event, handler) {
    this.events.on(event, handler)
  }

  registerProcess(name, context) {
    this.processes.set(name, context)
  }

  capabilityRegister(name, fn) {
    this.capabilities.set(name, fn)
  }

  capabilityRequire(name) {
    if (!this.capabilities.has(name))
      throw new Error(`Capability not found: ${name}`)
    return this.capabilities.get(name)
  }
}
