{
  "name": "module_hub",
  "defaults": [
    { "resolved": false },
    { "ready": false },
    { "isLoaded": false }
  ],
  "imports": [
    {
      "modules": ["base*", "render"],
      "controllers": ["home", "admin*"]
    }
  ]
}
