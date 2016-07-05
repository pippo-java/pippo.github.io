---
layout: page
title: "Modularity"
category: doc
date: 2015-03-17 17:48:14
order: 120
---

Pippo was designed since the first version with the modularity in mind. Many aspects (extension points) of this framework can be changed:

- `WebServer` (using _Pippo setServer()_ or auto discovery mechanism)
- `TemplateEngine` (using _Application.setTemplateEngine()_ or auto discovery mechanism)
- `Router` (using _Application.setRouter()_)
- `ErrorHandler` (using _Application.setErrorHandler()_)

Also you can set some parameters related to file upload process (_Application.setUploadLocation()_ and _Application.setMaximumUploadSize()_).
You can modify some settings for an embedded WebServer using _WebServerSettings_.

We chose the Service Loader mechanism from Java as built in modules system in Pippo because is a standard and easy to use.
You can create a modular application using [ServiceLocator]({{ site.coreurl }}/src/main/java/ro/pippo/core/util/ServiceLocator.java) class (trivial wrapper over Service Loader concept).

To improve the modularity mechanism, we added the concept of [Initializer]({{ site.coreurl }}/src/main/java/ro/pippo/core/Initializer.java).  
When Pippo starts up an application, it scans the classpath roots, looking for files named `pippo.properties`. It reads 
every pippo.properties file it finds, and it instantiates and execute the initializers defined in those files. 

To demonstrate the initializer concept I added a dump [FreemarkerInitializer]({{ site.codeurl }}/pippo-template-parent/pippo-freemarker/src/main/java/ro/pippo/freemarker/FreemarkerInitializer.java) in pippo-freemarker module. In our example, 
the [pippo.properties]({{ site.codeurl }}/pippo-freemarker/src/main/resources/pippo.properties) file (which should be packaged in the root of the classpath) contains only one line:

```properties
initializer=ro.pippo.freemarker.FreemarkerInitializer
```

The initializer can be implemented like this:

 ```java
public class FreemarkerInitializer implements Initializer {

    @Override
    public void init(Application application) {
		application.registerTemplateEngine(FreemarkerTemplateEngine.class);
    }

    @Override
    public void destroy(Application application) {
        // do nothing    
    }

} 
 ```

One scenario when I can use the _Initializer_ concept is when I split my application in several modules and each module 
wants to add some routes to the application.  
For example my application comes with two modules (two jars): _contacts_ and _users_.  
I can have _ContactInitializer.java_ with this content:

```java
public class ContactInitializer implements Initializer {

    @Override
    public void init(Application application) {
        // show contacts page
        application.GET("/contacts", (routeContext) -> routeContext.render("contacts"));
        
        // show contact page for the contact with id specified as path parameter 
        application.GET("/contact/{id}", (routeContext) -> routeContext.render("contact"));
    }

    @Override
    public void destroy(Application application) {
        // do nothing
    }

}
```

I can have _UserInitializer.java_ with this content:

```java
public class UserInitializer implements Initializer {

    @Override
    public void init(Application application) {
        // show users page
        application.GET("/users", (routeContext) -> routeContext.render("users"));
        
        // show user page for the user with id specified as path parameter 
        application.GET("/user/{id}", (routeContext) -> routeContext.render("user"));
    }

    @Override
    public void destroy(Application application) {
        // do nothing
    }

}
```

>__NOTE__ The order of the initializers depends on the order of the jars in the classpath. 
