Préparation
===========

Environnement
-------------

### Node.JS

Install in from the package manager of your distribution

```bash
sudo apt-get install nodejs
```

You can also either download the last binaries from the official website or install it from the sources

(http://nodejs.org/download/)[http://nodejs.org/download/]

### Installation des dépendances

```bash
npm install
```


Déploiement
===========

Production (heroku)
-------------------

* NODE\_ENV ← "production"
* CLIENT\_ID et CLIENT\_secret ← client id/secret de http://iiens.eu

Dévelopement
------------

Par défaut les URL utilisés sont http://ares-web.dev pour le fournisseur d'OAuth 
et http://oauth-demo.dev pour l'application. Cela suppose que vous avez un serveur web
qui pointe vers ces domaines. Sinon vous pouvez définir :

* IIENS\_URL
* IIENS\_API\_URL
* OAUTH\_DEMO\_URL

* CLIENT\_ID et CLIENT\_SECRET doivent être définis

```bash
  node app.coffee
```
