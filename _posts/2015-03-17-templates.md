---
layout: page
title: "Templates"
category: doc
date: 2015-03-17 17:37:21
order: 40
---

Not all applications are REST based and you might need to generate some HTML. 
It is not productive to inline the HTML in strings in your code and concatenate them at request time. 
Pippo ships with Freemarker template engine as default and Jade template engine as a builtin alternative. These engines
are optional and Pippo detect automatically the template engine using __ServiceLocator__.  
You can set programmatically the desired template engine using `setTemplateEngine(TemplateEngine templateEngine)` from
__Appplication__.

If you want to add support for other template engine in your application, please create a new module/project, add file 
`ro.pippo.core.TemplateEngine` in _src/main/resources/META-INF/services_ folder with your class name that implements 
TemplateEngine as content (for Jade the content file is _ro.pippo.jade.JadeTemplateEngine_).  

The `TemplateEngine` interface contains only one method, `public void render(String templateName, Map<String, Object> model, Writer writer)`, 
that must be implemented by your concrete template engine.

The template engine is uses in `public void render(String templateName, Map<String, Object> model)` and `public void render(String templateName)` 
from `Response` class.

Bellow is a code snippet about how you can use a template as response to a request:

```java
GET("/contact/{id}", (request, response, chain) -> {
    int id = request.getParameter("id").toInt(0);    
    String action = request.getParameter("action").toString("new");
    
    Map<String, Object> model = new HashMap<>();
    model.put("id", id);
    model.put("action", action)
    response.render("crud/contact", model);
});
```

Don't forget that `locals` variables from a response will be available automatically to all templates for the current request/response cycle.
 
For each template engine we expose its configuration. For example __Freemarker__ works with `freemarker.template.Configuration` and __Jade__ works with `de.neuland.jade4j.JadeConfiguration`.  
In _Application.init_ you can create a new instance for a discovered template engine or you can modify its configuration.

```java
public class CrudApplication extends Application {

   @Override
   public void init() {
      super.init();

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
   public void init() {
      super.init();

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

