# [:Volundir]


## Prefere outro idioma?

Leia este documento em:

[English EUA]:(/README.md)

---

## Sobre o [:Volundir]

[:Volundir] é um ecossistema curado de ideias de Kosh — projetado para oferecer um framework Vanilla JavaScript leve, agnóstico, modular e extensível.

Em seu núcleo, [:Volundir][:JS] fornece uma base estruturada e flexível para o desenvolvimento de aplicações modernas, sem dependências externas. A proposta é clareza arquitetural, autonomia do desenvolvedor e controle total sobre a stack.

Complementando o núcleo, [:Volundir][:UI] disponibiliza um UI Kit próprio, concebido para garantir consistência visual, organização e velocidade na construção de interfaces — sem engessar a criatividade.

O ecossistema inclui ainda [:Volundir][:PWA], um servidor e builder de Progressive Web Apps multiplataforma, permitindo implantações contínuas em diferentes ambientes. Para assegurar qualidade e confiabilidade, [:Volundir][:vSpec] oferece um sistema completo e integrado de testes.

Em conjunto, esses componentes — aliados a um conjunto de ferramentas com identidade própria — proporcionam uma experiência de desenvolvimento JavaScript inspirada no Rails, focada na criação e entrega de Cross Progressive Web Applications com elegância, controle e performance.

---

## Por que “Volundir”?

O nome Volundir é inspirado em Volundr (também conhecido como Wayland, o Ferreiro) — um lendário ferreiro da mitologia nórdica, famoso por forjar armas divinas e artefatos de imenso poder. Sua história representa maestria técnica, resiliência e excelência artesanal.

No mangá Shuumatsu no Valkyrie, “Volundr” é o ritual sagrado em que uma valquíria une sua alma à de um humano, transformando-se em uma arma divina perfeitamente alinhada à força daquele guerreiro.

O framework adota o nome Volundir para refletir esse mesmo espírito de precisão, transformação e artesania — oferecendo aos desenvolvedores uma base poderosa para forjar suas próprias aplicações com clareza e intenção.

---

## Status do Projeto

[:Volundir] e seus componentes encontram-se atualmente em estágio inicial de desenvolvimento.

O código disponível na branch main já oferece as seguintes capacidades:

### CLI

Um runner em Bash localizado no diretório /bin, capaz de:

* Detectar um executor de script backend;
* Carregar o Backend Ingot detectado;
  * Ingot de Ruby para o [:Volundir]:
    * Inicia um servidor de desenvolvimento baseado em WEBrick em http://localhost:3020;
      * Comando: bin/volundir s
    * Processa arquivos JavaScript, JSON, views, assets e textos;
      * Métodos disponíveis:
        * serve_dynamic_file;
        * before_callback;
        * after_callback;
        * transform_content;
        * mime_type;
      * Fornece rotas internas:
        * /assets estático
        * /api para desenvolvimento utilizando [:ruby_fake_api:] como armazenamento local de JSON
        * index.html como raiz do documento
        * Rota interna protegida /app
        * Rota interna protegida /lib
* Exibe conteúdo de ajuda i18n a partir de arquivos de texto ou JSON.

As instruções de instalação serão incluídas na próxima versão.


### Ingots

* volundir-ruby
* volundir-demo-app

---

## Licença

Este projeto está licenciado sob a MIT License.

Você pode usar, modificar e distribuir este framework para fins pessoais ou comerciais, desde que mantenha a devida atribuição.

---

## Agradecimento

Obrigado por escolher o [:Volundir].

É gratificante saber que essas ferramentas ajudam você a ir além — construindo aplicações mais limpas, estruturadas e poderosas.

Forje com propósito.

**|o/|**
