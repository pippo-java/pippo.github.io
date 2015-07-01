---
layout: page
title: "Static files"
category: doc
date: 2015-03-17 17:24:53
order: 20
---

Web applications generally need to serve resource files such as images, JavaScript, or CSS. In Pippo, we refer to these files as “static files”.

The easiest way of serving static files is to use:

- [PublicResourceHandler]({{ site.coreurl }}/src/main/java/ro/pippo/core/route/PublicResourceHandler.java)
- [WebjarsResourceHandler]({{ site.coreurl }}/src/main/java/ro/pippo/core/route/WebjarsResourceHandler.java)
- [FileResourceHandler]({{ site.coreurl }}/src/main/java/ro/pippo/core/route/FileResourceHandler.java)
- [ClasspathResourceHandler]({{ site.coreurl }}/src/main/java/ro/pippo/core/route/ClasspathResourceHandler.java)

For example:

```java
Pippo pippo = new Pippo();
pippo.getApplication().addPublicResourceRoute();
pippo.getApplication().addWebjarsResourceRoute();
```

or more verbose:

```java
Pippo pippo = new Pippo();
pippo.getApplication().addResourceRoute(new PublicResourceRoute());
pippo.getApplication().addResourceRoute(new WebjarsResourceRoute());
```

You can use multiple `FileResourceRoute` but it is nonsense to use more `PublicResourceRoute` or more `WebjarsResourceRoute`.  

The [CrudNgDemo]({{ site.demourl }}/pippo-demo-crudng) (demo pippo-angularjs integration) is a good application that demonstrates the concept of static files. 
In `src/main/resources` we created a folder __public__ and we put all assets in that folder (imgs, css, js, fonts, ...).

```
➤ tree src/main/resources/public
src/main/resources/public
├── css
│   └── style.css
├── fonts
└── js
    └── crudNgApp.js

3 directories, 2 files
```

The CrudNgDemo uses the [Bootstrap](http://getbootstrap.com/) & [Font-Awesome](http://fortawesome.github.io/Font-Awesome). You can manually copy those resources into your project or you can serve them from the [WebJars](http://www.webjars.org) project using the __webjarsAt__ method appropriate for your template engine.

The CrudNgDemo also uses a custom CSS file which is a classpath resource from the `/public` folder.

In this demo, the html template page (freemarker engine) contains a head section like:

```html
<head>
    <meta charset="utf-8">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="${webjarsAt('bootstrap/css/bootstrap.min.css')}" rel="stylesheet">
    <link href="${webjarsAt('font-awesome/css/font-awesome.min.css')}" rel="stylesheet">
    <link href="${publicAt('css/style.css')}" rel="stylesheet">
</head>
```

If you want to have more control over webjars artifact version you can use this declaration:

```html
<head>
	<link href="${webjarsAt('bootstrap/3.3.1/css/bootstrap.min.css')}" rel="stylesheet">
	<link href="${webjarsAt('font-awesome/4.2.0/css/font-awesome.min.css')}" rel="stylesheet">
</head>
```

Sure in your pom.xml file (if you use Maven) you must declare the dependencies to these webjars:

```xml
<!-- Webjars -->
<dependency>
	<groupId>org.webjars</groupId>
	<artifactId>bootstrap</artifactId>
	<version>3.3.1</version>
</dependency>

<dependency>
	<groupId>org.webjars</groupId>
	<artifactId>font-awesome</artifactId>
	<version>4.2.0</version>
</dependency>
```

If you want to serve static files that are not on the classpath then you may use the `FileResourceRoute`.

```java
Pippo pippo = new Pippo();
// make available some files from a local folder (try a request like 'src/main/resources/simplelogger.properties')
pippo.getApplication().addFileResourceRoute("/src", "src");
```

From security reason the `FileResourceRoute` doesn't serve resources from outside it's base directory by using relative paths such as `../../../private.txt`.
