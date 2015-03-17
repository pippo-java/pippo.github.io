---
layout: page
title: "Modularity"
category: doc
date: 2015-03-17 17:48:14
order: 6
---

Pippo was designed since the first version with the modularity in mind. Any aspect of this framework can be changed:
- embedded `WebServer` (using _Pippo setServer_ or auto discovery mechanism)
- `TemplateEngine` (using _Application.setTemplateEngine_ or auto discovery mechanism)
- `RouteMatcher` (using _Application.setRouteMatcher_)
- `ExceptionHandler` (using _Application.setExceptionHandler_)
- `RouteNotFoundHandler` (using _Application.setRouteNotFoundHandler_)

Also you can set some parameters related to file upload process (_Application.setUploadLocation_ and _Application.setMaximumUploadSize_).
You can modify some settings for an embedded WebServer using _WebServerSettings_.

We chose Service Loader mechanism from Java as builtin module system in Pippo because is a standard easy to use mechanism
You can create a modular application using `ServiceLocator` class (trivial wrapper over Service Loader concept).

To improve the modularity mechanism, we added the concept of `Initializer`.  
When Pippo starts up an application, it scans the classpath roots, looking for files named `pippo.properties`. It reads 
every pippo.properties file it finds, and it instantiates and execute the initializers defined in those files. 

To demonstrate the initializer concept I added a dump _FreemarkerInitializer_ in pippo-freemarker module. In our example, 
the _pippo.properties_ file (which should be packaged in the root of the classpath) contains only one line:

```properties
initializer=ro.pippo.freemarker.FreemarkerInitializer
```

The initializer can be implemented like this:

 ```java
public class FreemarkerInitializer implements Initializer {

    @Override
    public void init(Application application) {
        application.setTemplateEngine(new FreemarkerTemplateEngine());
        // or do some freemarker configuration
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
        application.GET("/contacts", (request, response, chain) -> response.send("contacts"));
        
        // show contact page for the contact with id specified as path parameter 
        application.GET("/contact/{id}", (request, response, chain) -> response.send("contact"));
    }

    @Override
    public void destroy(Application application) {
        // do nothing
    }

}
```

I can have _UserInitializer.java_ with this content:

```java
public class ContactInitializer implements Initializer {

    @Override
    public void init(Application application) {
        // show users page
        application.GET("/users", (request, response, chain) -> response.send("users"));
        
        // show user page for the user with id specified as path parameter 
        application.GET("/user/{id}", (request, response, chain) -> response.send("user"));
    }

    @Override
    public void destroy(Application application) {
        // do nothing
    }

}
```

