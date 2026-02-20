import { Base }        from '/lib/base/base.js'
import { EventBus }    from '/lib/core/event-bus.js'
import { LogBus }      from '/lib/core/log-bus.js'
import { loadIngots }  from '/lib/core/runtime/loader.js'
import { applyCompat } from '/lib/core/compat/v1.js'

export class Kernel extends Base {
  #current_user = null;

  #visitor = {
    id: 0,
    login: 'visitor',
    name: 'Internet Visitor',
    email: 'app@internet.visitor',
    profiles: ['visitor'],
    roles: ['visitor'],
    state: null,
    created_at: new Date(),
    updated_at: null
  };

  #session = {
    id: 0,
    current_user: null,
    state: null,
    created_at: new Date(),
    updated_at: null
  }

  constructor(config, options={}) {
    super();

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

    this.log('info', '[:Volundir][boot] Boot: ', { session_started: this.current_user } );

    await this.events.emit('kernel:booted', {})

    this.log('info', '[:Volundir][boot] Done: ', { session_started: this.current_user } );

    this.logBus.ready = true;
  }

  run () {
    this.log('info', '[:Volundir][run] Starting Application.', { session_start: this.current_session } );

    (async() => this.boot())();

    (async() => this.events.emit('session:started', this.current_session))();

    this.log('info', '[:Volundir][run] Application Started and Ready.', { session_started: this.current_session } );

  }

  get current_user() {
    return this.#current_user;
  }

  set current_user(user) {
    this.#current_user = user;

    this.#current_user.state = 'active'
  }

  get current_session() {
    if(!this.current_user) {
      this.current_user = this.#visitor;
    }

    this.#session["current_user"] = this.current_user;
    this.#session["state"] = 'active'

    return this.#session;
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
