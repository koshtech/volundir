
export class EventBus {
  constructor() {
    this.listeners = new Map()
  }

  on(event, handler) {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, [])
    }
    this.listeners.get(event).push(handler)
  }

  async emit(event, payload) {
    const handlers = this.listeners.get(event) || []
    for (const handler of handlers) {
      await handler(payload)
    }
  }
}
