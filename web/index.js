function registerServiceWorker() {
  navigator.serviceWorker.register('/service-worker.js')
    .then((reg) => console.log(`Service Worker registered: ${reg}`))
    .catch((err) => console.warn(`Error registering Service Worker: ${err}`));
}

let response = await fetch('/lib/core/runtime/core.js', { method: 'HEAD' });

if(response.ok) {
  if (!globalThis.VolundirApp) {
    const core = await import('/lib/core/runtime/core.js');
    const Core = core['Core'];

    const config  = {
      name: 'Volundir',
      description: 'Volundir PWA Platform',
      objectType: 'core',
      version: '0.0.1',
      apiVersion: '0.0.1'
    }
    const options = {};

    if ('serviceWorker' in navigator) {
      if (document.readyState === 'complete') {
        registerServiceWorker();
      } else {
        window.addEventListener('load', registerServiceWorker);
      }
    }

    if (HTMLScriptElement.supports?.("importmap")) {
      console.log("Browser supports import maps.");
    }
    else {
      console.warn("Browser does not supports import maps.");
    }

    globalThis.Volundir = Core.create(config, options);

    console.log('Volundir: ', Volundir);

    // await Volundir.init();
  }
}
else {
  document.querySelector('.pulse-container .loading-panel .loading-title').textContent = "Stopped";
  document.querySelector('.pulse-container .loading-panel .loading-item').textContent = "Core System are not ready";

  let logo = document.querySelector('.loading-logo');

  logo.classList.remove('pulse');
  logo.classList.add('stopped');
}



