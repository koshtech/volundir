import { Base } from '/lib/base/base.js'

export class EventBus extends Base {
  #listeners = new Map()
  #buffer    = [];

  constructor() {
    super();
  }

  on(event, handler) {
    if (!this.#listeners.has(event)) {
      this.#listeners.set(event, []);
    }

    this.#listeners.get(event).push(handler);
  }

  async emit(event, payload) {

    const entry = { "datetime": new Date(), "event": event, "payload": payload };

    this.#buffer.push(entry);

    const handlers = this.#listeners.get(event) || [];

    for (const handler of handlers) {
      await handler(entry);
    }
  }
}
