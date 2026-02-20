export class Base {
  #ready = false;

  set ready(value) {
    this.#ready = value;
  }

  get ready() {
    return this.#ready;
  }
}
