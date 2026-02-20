import { Base } from '/lib/base/base.js'

export class LogBus extends Base {
  #handlers = [];
  #buffer = [];

  constructor() {
    super();
  }

  register(handler) {
    // console.log('info', '[:LogBus][register] handler: ', handler);
    this.#handlers.push(handler);
  }

  write(entry) {
    entry["datetime"] = new Date();

    this.#buffer.push(entry);

    if (this.ready) {
      this.sync();
    }
  }

  sync() {
    if (this.ready) {
      for (const entry of this.#buffer) {
        this.write(entry);
      }
    }

    this.flush();
  }

  flush() {
    this.#buffer = [];
  }
}
