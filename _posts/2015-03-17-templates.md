---
layout: page
title: "Templates"
category: doc
date: 2015-03-17 17:37:21
order: 40
---

Not all applications are `REST` based and you might need to generate some HTML.  
It is not productive to inline the `HTML` in strings in your code and concatenate them at request time.  
Pippo ships with Freemarker template engine as default and other engines as a builtin alternatives.  

To use a template engine is optional and Pippo detects automatically the template engine using __ServiceLocator__.
If you want to use a template engine in your application, you must add `pippo-<engine name>` as dependency for your project. 
Other option is to set programmatically the desired template engine using `Application#setTemplateEngine(TemplateEngine templateEngine)`, 
that in case that you want to create by hand the template engine.

Pippo comes (out of the box) with some template engines:

- [Freemarker](/doc/templates/freemarker.html) `pippo-freemarker`
- [Jade](/doc/templates/jade.html) `pippo-jade`
- [Groovy](/doc/templates/groovy.html) `pippo-groovy`
- [Pebble](/doc/templates/pebble.html) `pippo-pebble`
- [Trimou](/doc/templates/trimou.html) `pippo-trimou`
- [Velocity]({{ site.codeurl }}/pippo-template-parent/pippo-velocity) `pippo-velocity`

To use one of these template engines just add a dependency in your project:

```xml
<dependency>
    <groupId>ro.pippo</groupId>
    <artifactId>pippo-freemarker</artifactId>
    <version>${pippo.version}</version>
</dependency>
```

All templates by default are localized in `/templates` folder (`src/main/resources/templates` for Maven projects).
So, by default the templates are loaded from classpath.
See below all templates from [pippo-demo-basic]({{ site.demourl }}/pippo-demo-basic) project:

```bash
$ tree src/main/resources/templates
src/main/resources/templates
├── files.ftl
└── hello.ftl
```

You can change the location of templates by adding the following line in `conf/application.properties`:

```properties
template.pathPrefix = /
 ```

Using above snippet we changed the templates location from `/templates` to `/`.
Don't remember that the template will be loaded from classpath as resource.

Below is a code snippet about how you can use a template as response to a request:

```java
GET("/contact/{id}", routeContext -> {
    // retrieve some request's parameters values
    int id = routeContext.getParameter("id").toInt(0);
    String action = routeContext.getParameter("action").toString("new");
    
    // create the template model
    Map<String, Object> model = new HashMap<>();
    model.put("id", id);
    model.put("action", action)
    
    // render the template using data from model
    routeContext.render("contact", model);
});
```

In above route, Pippo will find a template with name "contact" and will respond with the result of rendering template by the template engine (a String).  

Don't forget that `locals` variables from a response will be available automatically to all templates for the current request/response cycle.
So, maybe the shortest version is:

```java
GET("/contact/{id}", routeContext -> {
    routeContext.setLocal("id", routeContext.getParameter("id").toInt(0));
    routeContext.setLocal("action", routeContext.getParameter("action").toString("new"));
    routeContext.render("contact");
});
```

From the above code snippets you can see that we call the `render` method with the template name as parameter but without extension.
That means that you can change anytime the template file extension without to change the route handler code.
Also, you can change the template engine without to change teh route handler code (for Freemarker template engine you supply a template `contact.ftl` file, 
for Pebble template engine you supply a `contact.peb` file, and so on).

Each template engine has a default file extension but you can change it if you want.
For example, `PebbleTemplateEngine` has `peb` as default file extension but you can change it in `html`.
The customization can be applied by adding the following line in `conf/application.properties`:

```properties
template.extension = html
```

For each template engine we expose its configuration. For example __Freemarker__ works with `freemarker.template.Configuration` and __Jade__ works with `de.neuland.jade4j.JadeConfiguration`.  
In _Application#onInit_ you can create a new instance for a discovered template engine or you can modify its configuration.

```java
public class CrudApplication extends Application {

   @Override
   protected void onInit() {
      FreemarkerTemplateEngine templateEngine = new FreemarkerTemplateEngine();
      try {
         templateEngine.getConfiguration().setDirectoryForTemplateLoading(new File("src/main/resources/templates/"));
      } catch (IOException e) {
         throw new PippoRuntimeException(e);
      }
      setTemplateEngine(templateEngine);

      // add routes
   }

}
```

or

```java
public class CrudApplication extends Application {

   @Override
   protected void onInit() {
      Configuration configuration = ((FreemarkerTemplateEngine) templateEngine).getConfiguration();
      try {
         configuration.setDirectoryForTemplateLoading(new File("src/main/resources/templates/"));
      } catch (IOException e) {
         throw new PippoRuntimeException(e);
      }

      // add routes
   }

}
```

In Pippo, each builtin template engine comes with special templates for routing problems and exceptions.
See below the special templates that come by default with `pippo-freemarker`
```bash
$ tree src/main/resources/
src/main/resources/
└── templates
    └── pippo
        ├── 000base.ftl
        ├── 400badRequest.ftl
        ├── 401unauthorized.ftl
        ├── 402paymentRequired.ftl
        ├── 403forbidden.ftl
        ├── 404notFound.ftl
        ├── 405methodNotAllowed.ftl
        ├── 409conflict.ftl
        ├── 410gone.ftl
        ├── 500internalError.ftl
        ├── 501notImplemented.ftl
        ├── 502overloaded.ftl
        └── 503serviceUnavailable.ftl
```
You may override these templates within your own application (put a file with the same name, to same location, in your application classpath).
If you feel that is too much to have a template for each error code, you can return the same template for all error code. In this situation you must override 
`DefaultErrorHandler#getTemplateForStatusCode(int statusCode)`.

By default, all template engines disable the cache in `dev` and `test` mode (to speed the development - change template and refresh the page in browser) 
and enable the cache in `prod` mode (to improve the performance). 

Majority of builtin template engine supplied by Pippo, come with useful functions (extensions) that increase the readability of template:
- webjarsAt
- publicAt
- i18n
Read the documentation page allocated to each template engine for more information. The links to individual pages are presented in the start of this page.  
 
If you want to add support for other template engine in your application you must follow below steps:
- create a new module/project
- create a class (ex. MyTemplateEngine) that extends `AbstractTemplateEngine` (or implements `TemplateEngine`)
- mark your template engine class as service using one of the methods below  
   - automatically via `@MetaInfServices` annotation (mark your template engine class with this annotation)
   - manually, add file `ro.pippo.core.TemplateEngine` in _src/main/resources/META-INF/services_ folder with your class name that implements 
TemplateEngine as content (for Jade the content file is _ro.pippo.jade.JadeTemplateEngine_).  

For more information about how to implement a template engine please see _pippo-freemarker_ and _pippo-jade_ modules.
