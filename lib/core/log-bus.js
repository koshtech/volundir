
export class LogBus {
  constructor() {
    this.handlers = []
    this.buffer = []
    this.ready = false
  }

  register(handler) {
    this.handlers.push(handler)
  }

  write(entry) {
    if (!this.ready) {
      this.buffer.push(entry)
      return
    }
    for (const handler of this.handlers) {
      handler(entry)
    }
  }

  flush() {
    this.ready = true
    for (const entry of this.buffer) {
      this.write(entry)
    }
    this.buffer = []
  }
}
