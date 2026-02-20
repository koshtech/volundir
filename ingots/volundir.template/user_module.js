export class ModuleHub extends BaseHub {
  #state = 'idle';        // idle | initialized | running | completed | failed
  #loaded = false;

  constructor() {
    super();

    this.resolved = true;
    this.ready    = true;

    Object.freeze(this); // evita mutações estruturais externas
  }

  get state() {
    return this.#state;
  }

  get isLoaded() {
    return this.#loaded;
  }

  async load() {
    if (this.#loaded) return;

    await this.init();
    this.#loaded = true;
    this.#state  = 'initialized';
  }

  async start() {
    if (!this.#loaded) {
      await this.load();
    }

    if (this.#state === 'running') return;

    this.#state = 'running';

    try {
      await this.run();
      await this.process();
      this.#state = 'completed';
    } catch (err) {
      this.#state = 'failed';
      throw err;
    }
  }

  async init() {
    // override nos filhos
  }

  async run() {
    // override nos filhos
  }

  async process() {
    // override nos filhos
  }

  async other() {
    // extensões específicas
  }
}
