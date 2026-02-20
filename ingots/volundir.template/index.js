
export default {
  objectType: "module",
  name: "example_module",
  description: "Volundir Ingot Module Example"
  version: "0.0.1",
  apiVersion: "v0.0.1",
  options: {},
  provide: {
    config: {
      routes: "routes.json",
      locales: ["pt-BR"]
    },
    modules: true,
    models: true,
    // controllers: true => default value for complete controllers, views and assets | controllers => only controllers | views => only views | assets => only assets | views_and_assets | false
    controllers: true
  }

  boot(app) {
  },

  run() {

  }
}
