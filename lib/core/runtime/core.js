import { Kernel } from './kernel.js'

export class Core {
  constructor(config) {
  }

  static create(config, options={}) {
    return new Kernel(config, options={})
  }
}
