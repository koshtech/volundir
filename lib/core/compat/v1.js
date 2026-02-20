
export function applyCompat(app) {
  app.alias = function(name, fn) {
    this[name] = fn
  }
}
