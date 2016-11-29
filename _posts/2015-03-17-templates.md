---
layout: page
title: "Templates"
category: doc
date: 2015-03-17 17:37:21
order: 40
---

Not all applications are REST based and you might need to generate some HTML. 
It is not productive to inline the HTML in strings in your code and concatenate them at request time.  
Pippo ships with Freemarker template engine as default and other engines as a builtin alternatives.  
These engines are optional and Pippo detects automatically the template engine using __ServiceLocator__.  
You can set programmatically the desired template engine using `setTemplateEngine(TemplateEngine templateEngine)` from
__Appplication__.

Pippo comes (out of the box) with some template engines:

- [Freemarker](/doc/templates/freemarker.html) `pippo-freemarker`
- [Jade](/doc/templates/jade.html) `pippo-jade`
- [Groovy](/doc/templates/groovy.html) `pippo-groovy`
- [Pebble](/doc/templates/pebble.html) `pippo-pebble`
- [Trimou](/doc/templates/trimou.html) `pippo-trimou`
- [Velocity]({{ site.codeurl }}/pippo-template-parent/pippo-velocity) `pippo-velocity`

To use one of these template engines just add a dependency in your project:

```
<dependency>
	<groupId>ro.pippo</groupId>
	<artifactId>pippo-freemarker</artifactId>
	<version>${pippo.version}</version>
</dependency>
```

If you want to add support for other template engine in your application, please create a new module/project, add file 
`ro.pippo.core.TemplateEngine` in _src/main/resources/META-INF/services_ folder with your class name that implements 
TemplateEngine as content (for Jade the content file is _ro.pippo.jade.JadeTemplateEngine_).  

Bellow is a code snippet about how you can use a template as response to a request:

```java
GET("/contact/{id}", routeContext -> {
    int id = routeContext.getParameter("id").toInt(0);    
    String action = routeContext.getParameter("action").toString("new");
    
    Map<String, Object> model = new HashMap<>();
    model.put("id", id);
    model.put("action", action)
    routeContext.render("contact", model);
});
```

Don't forget that `locals` variables from a response will be available automatically to all templates for the current request/response cycle.
So, maybe the shortest version is:

```java
GET("/contact/{id}", routeContext -> {
	routeContext.setLocal("id", routeContext.getParameter("id").toInt(0));
	routeContext.setLocal("action", routeContext.getParameter("action").toString("new"));	
    routeContext.render("contact");
});
```

 
For each template engine we expose its configuration. For example __Freemarker__ works with `freemarker.template.Configuration` and __Jade__ works with `de.neuland.jade4j.JadeConfiguration`.  
In _Application.onInit_ you can create a new instance for a discovered template engine or you can modify its configuration.

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

      // ... add routes
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

      // ... add routes
   }

}
```

For more information about how to implement a template engine please see _pippo-freemarker_ and _pippo-jade_ modules.

