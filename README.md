# [:Volundir]


## Prefer Another Language?

Read this document in:

[Brazilian Portuguese]:(/doc/pt-BR/README.md)

---

## About [:Volundir]

[:Volundir] is a curated ecosystem of Kosh’s ideas — engineered to deliver a lightweight, agnostic, modular, and extensible Vanilla JavaScript framework.

At its core, [:Volundir][:JS] provides a structured yet flexible foundation for building modern applications without external dependencies. It embraces architectural clarity, developer autonomy, and full control over the stack.

Complementing the core, [:Volundir][:UI] offers an in-house UI Kit designed for clarity, consistency, and rapid interface composition — without sacrificing flexibility.

The ecosystem also includes [:Volundir][:PWA], a cross-platform Progressive Web App server and builder, enabling seamless deployment across environments. For quality assurance, [:Volundir][:vSpec] delivers a complete and integrated testing system.

Together, these components — along with a suite of Kosh-styled development tools — create a Rails-inspired JavaScript development experience focused on building and deploying Cross Progressive Web Applications with elegance, control, and performance.

---

## Why "[:Volundir]"?

Volundir is inspired by Volundr (also known as Wayland the Smith) — a legendary blacksmith in Norse mythology renowned for crafting divine weapons and artifacts of immense power. His story represents mastery, resilience, and craftsmanship taken to its highest form.

In the manga Shuumatsu no Valkyrie, “Volundr” refers to a sacred ritual in which a valkyrie merges her soul with a human, transforming into a divine weapon uniquely aligned with that warrior’s strength.

This framework adopts the name Volundir to embody that same spirit of precision, transformation, and craftsmanship — providing developers with a powerful foundation to forge their own applications with clarity and intent.

And all [:koshtech] products and services follows our ruby maming philosophy, by this way, this amazing PWA platform are named [:Volundir].

---

## Project Status

[:Volundir] and its components are currently in the initial development stage.

The code available in the main branch already provides the following capabilities:

### CLI

A Bash runner located in the /bin directory that can:

* Detect a backend script executor;
* Load the detected Backend Ingot;
  * [:Volundir] Ruby Ingot:
    * Starts a WEBrick-based development server at http://localhost:3020
      * Command: bin/volundir s
    * Processes JavaScript, JSON, views, assets, and text files;
      * Available methods:
        * serve_dynamic_file;
        * before_callback;
        * after_callback;
        * transform_content;
        * mime_type;
      * Provides internal routes:
        * Static /assets;
        Development-only /api using [:ruby_fake_api:] for * local JSON storage;
        * Document root index.html;
        * Protected internal route /app;
        * Protected internal route /lib;
* Display i18n help content from text or JSON files.

Installation instructions will be included in the next release.


### Ingots

* volundir-ruby
* volundir-demo-app

---

## License

This project is licensed under the [MIT License](LICENSE).

You are free to use, modify, and distribute this framework for personal or commercial purposes, with proper attribution.

---

## Thank You

Thank you for choosing [:Volundir].

It is deeply rewarding to know that these tools help you build further, cleaner, and stronger. Craft boldly.

**|o/|**
