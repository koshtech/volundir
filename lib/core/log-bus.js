import { Base } from '/lib/base/base.js'

export class LogBus extends Base {
  #handlers = [];
  #buffer = [];

  constructor() {
    super();
  }

  register(handler) {
    console.log('info', '[:LogBus][register] handler: ', handler);
    this.#handlers.push(handler);
  }

  write(entry) {
    console.log('info', '[:LogBus][write] entry: ', entry);

    this.#buffer.push(entry);

    if (this.ready) {
      for (const handler of this.#handlers) {
        handler(entry);
      }
    }
  }

  sync() {
    if (this.ready) {
      for (const entry of this.#buffer) {
        this.write(entry);
      }
    }
  }

  flush() {
    this.#buffer = [];
  }
}
