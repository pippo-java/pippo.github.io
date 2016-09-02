---
layout: page
title: "Under the hood"
category: dev
date: 2015-03-17 18:02:31
order: 10
---

First, the framework is splits in [modules]({{ site.codeurl }}) because I want to use only that modules that are usefully for me.  
For example if I develop a rest like application for a javascript frontend library (AngularJS for example) I don't want to use a template engine because my application connects to a database and it delivers only json.  
Also, maybe I want to use an external servlet container (Tomcat for example) and I don't want to use the web server supplied by Pippo. You can eliminate in this scenarios the default server(Jetty) from Pippo (pippo-jetty module).   
Another scenarios is the case when you (as a web designer/developer) are not familiar with Freemarker (the default template engine from pippo) but you know Jade template engine because you have some experience with NodeJS applications. You can eliminate completely in this scenarios the Freemarker from Pippo (pippo-jetty module).   
How is it implemented the modularity in Pippo? Simple, using the ServiceLoader standard mechanism from Java.  
Also you can use the same mechanism to modularize your application using [ServiceLocator]({{ site.coreurl }}/src/main/java/ro/pippo/core/util/ServiceLocator.java) class from pippo-core.  

In Pippo are few concepts that you would need to know them as simple user:

- Application
- Request
- Response
- Route
- RouteHandler
- RouteContext

If you want to extend Pippo (create new module, modify some default behaviors) you would need to know about:

- PippoFilter
- WebServer
- TemplateEngine
- RouteDispatcher
- Router
- RequestResponseFactory
- ServiceLocator
- Initializer

The easy mode to run your application is to use [Pippo]({{ site.coreurl }}/src/main/java/ro/pippo/core/Pippo.java) wrapper class.  

The `Route` concept was described [here]({{site.url}}/doc/routes.html).

The [Response]({{ site.coreurl }}/src/main/java/ro/pippo/core/Response.java) is a wrapper over [HttpServletResponse](https://tomcat.apache.org/tomcat-7.0-doc/servletapi/javax/servlet/http/HttpServletResponse.html) from servlet API and it provides functionality for modifying the response. You can send a char sequence with `send` method, or a file with `file` method, or a json with `json` method, or a xml with `xml` method. Also you can send a template file merged with a model using `render` method.  

The [Request]({{ site.coreurl }}/src/main/java/ro/pippo/core/Request.java) is a wrapper over [HttpServletRequest](https://tomcat.apache.org/tomcat-7.0-doc/servletapi/javax/servlet/http/HttpServletRequest.html) from servlet API.  

When a request is made to the server, which matches a route definition, the associated handlers are called. The [Router]({{ site.coreurl }}/src/main/java/ro/pippo/core/route/Router.java) contains a method `findRoutes(String requestUri, String requestMethod):List<RouteMatch>` that returns all routes which matches a route definition (requestUri-requestMethod pair).  
Why does `Router` have the method `findRoutes():List<RouteMatch>` instead of `findRoute():RouteMatch`? The response is that I want to use the `RouteHandler` also to define the __Filter__ concept. I don't want to define a new interface Filter with the same signature as the RouteHandler interface.  
The route handler determines how requests are handled, either by directing a request to a module, or marking a request to be handled by the static files, or by marking a request as 404 Not Found.
A RouteHandler has only one method `handle(RouteContext routeContext)`. The __handle__ method can be an endpoint or not.  
A regular RouteHandler is an endpoint, that means that the response is committed in the handle method of that RouteHandler instance. A committed response has already had its status code and headers written. In Response class exists a method `isCommitted()` that tell you if the response is committed or not. The methods from Response that commit a response are: `send`, `json`, `file`, `render` (the list may increases in the future). If you try to commit a response that was already committed (after content has been written) than a `PippoRuntimeException` will be thrown.  
You can reconize in a very simple mode if a response method sets the committed flag on true (it's an endpoint method) just by looking at its signature. The convension is that these methods return `void` unlike the other methods that return `Response` (you can set many fields at once).  
You can see a filter as a RouteHandler that does not commit the response. A filter is typically used to perform a particular piece of functionality either before or after the primary functionality (another RouteHandler) of a web application is performed. The filter might determine that the user does not have permissions to access a particular servlet, and it might send the user to an error page rather than to the requested resource.  

```java
// audit filter
GET("/.*", (routeContext) -> {
	Request request = routeContext.getRequest();
    System.out.println("Url: '" + request.getUrl());
    System.out.println("Uri: '" + request.getUri());
    System.out.println("Parameters: " + request.getParameters());
});

GET("/hello",(routeContext) -> routeContext.send("Hello World"));
```

You can see in the above example that I put an audit filter in front of all requests.

From version 0.4, Pippo comes with a new very useful method `Request.createEntityFromParameters`. This method binding the request parameters values from PUT/POST/etc to Java objects (POJOs).  
Let's see some code that shows in action this feature:

```java
POST("/contact", (routeContext) -> {
	String action = routeContext.getParameter("action").toString();
	if ("save".equals(action)) {
		Contact contact = routeContext.createEntityFromParameters(Contact.class);
		contactService.save(contact);
		routeContext.redirect("/contacts");
	}        
});
```
The old version has:

```java
POST("/contact", (routeContext) -> {
	String action = routeContext.getParameter("action").toString();
    if ("save".equals(action)) {
        Contact contact = new Contact();
        contact.setId(request.getParameter("id").toInt(-1));
        contact.setName(request.getParameter("name").toString());
        contact.setPhone(request.getParameter("phone").toString());
        contact.setAddress(request.getParameter("address").toString());
        contactService.save(contact);
        routeContext.redirect("/contacts");
    }
});                    
```

Pippo supports the following request parameter and entity field types:

- boolean/Boolean
- byte/Byte
- short/Short
- int/Integer
- long/Long
- float/Float
- double/Double
- BigDecimal
- char/Character
- String
- UUID
- java.util.Date
- java.sql.Date
- java.sql.Time
- java.sql.Timestamp
- enum types mapped by case (in)sensitive name or by ordinal
- and simple arrays [] of all these types

An [Application]({{ site.coreurl }}/src/main/java/ro/pippo/core/Application.java) is a class which associates with an instance of [PippoFilter]({{ site.coreurl }}/src/main/java/ro/pippo/core/PippoFilter.java) to serve pages over the HTTP protocol. Usually I subclass this class and add my routes in `init` method.

```java
public class MyDemo {

    public static void main(String[] args) {
        Pippo pippo = new Pippo(new SimpleApplication());
        pippo.start();
    }

}

public class MyApplication extends Application {

    @Override
    protected void onInit() {
        GET("/", (routeContext) -> routeContext.send("Hello World"));        
    }

}
```     

another approach is:  

```java
public class MyDemo {

    public static void main(String[] args) {
        Pippo pippo = new Pippo();

        // add routes
        pippo.GET("/", (routeContext) -> routeContext.send("Hello World"));

        // start the embedded server
        pippo.start();
    }

}
```     

[RouteContext]({{ site.coreurl }}/src/main/java/ro/pippo/core/route/RouteContext.java) represents the current context of a `Route` being processed by the Pippo.  
It's an object that encapsulates information about the route.  
On short it's an holder for some useful instances (Application, Request, Response, Session) and it contains some shortcut methods (Request.getParameter, Request.getHeader, Response.send, Response.render, etc.).  
You can obtain the current RouteContext using the static method `RouteDispatcher.getRouteContext()`.
