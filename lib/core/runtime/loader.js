
export async function loadIngots(app) {
  const modules = import.meta.glob('/app/ingots/*/ingot.js')

  for (const path in modules) {
    const mod = await modules[path]()
    const ingot = mod.default

    const context = { state: {} }

    if (ingot.boot) {
      await ingot.boot(app, context)
    }

    app.registerProcess(ingot.name, context)
  }
}
