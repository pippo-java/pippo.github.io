---
layout: page
title: "Static files"
category: doc
date: 2015-03-17 17:24:53
order: 20
---

Web applications generally need to serve resource files such as images, JavaScript, or CSS. In Pippo, we refer to these files as “static files”.

The easiest way of serving static files is to use the `PublicResourceHandler`, `WebjarsResourceHandler`, & `FileResourceHandler`.

```java
Pippo pippo = new Pippo();
pippo.getApplication().GET(new PublicResourceHandler());
pippo.getApplication().GET(new WebjarsResourceHandler());
```

The CrudDemo is a good application that demonstrates the concept of static files. In pippo-demo/src/main/resources I created a folder __public__ and I put all assets in that folder (imgs, css, js, fonts, ...).

```
➤ tree pippo-demo/src/main/resources/public
pippo-demo/src/main/resources/public
├── css
│   └── style.css
├── fonts
└── js
    └── crudNgApp.js

3 directories, 2 files
```

The CrudDemo uses the Bootstrap framework & Font-Awesome. You can manually copy those resources into your project or you can serve them from the WebJars project using the *WebjarsAt* method appropriate for your template engine.

The CrudDemo also uses a custom CSS file which is a classpath resource from the `/public/` folder.

```html
<head>
    <meta charset="utf-8">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="${webjarsAt('bootstrap/3.3.1/css/bootstrap.min.css')}" rel="stylesheet">
    <link href="${webjarsAt('font-awesome/4.2.0/css/font-awesome.min.css')}" rel="stylesheet">
    <link href="${publicAt('css/style.css')}" rel="stylesheet">
</head>
```

If you want to serve static files that are not on the classpath then you may use the `FileResourceHandler`.

```java
Pippo pippo = new Pippo();
pippo.getApplication().GET(new FileResourceHandler("/src", "src"));
```

