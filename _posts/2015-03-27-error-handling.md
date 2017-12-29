---
layout: page
title: "Error handling"
category: doc
date: 2015-03-27 11:52:24
order: 100
---

In `Application` class you can set a custom [ErrorHandler]({{ site.coreurl }}/src/main/java/ro/pippo/core/ErrorHandler.java).  
ErrorHandler is the core [ExceptionHandler]({{ site.coreurl }}/src/main/java/ro/pippo/core/ExceptionHandler.java).
ErrorHandler can register custom ExceptionHandlers and will handle an exception with a matching ExceptionHandler, if found.
Otherwise ErrorHandler will fallback to itself to handle the exception.  
By default each Application instance comes with a [DefaultErrorHandler]({{ site.coreurl }}/src/main/java/ro/pippo/core/DefaultErrorHandler.java) 
that integrates with the `TemplateEngine` & `ContentTypeEngine`. It generates a representation of an exception or error result.  


See below an custom ErrorHandler in action:
```java
public class BasicApplication extends Application {

    @Override
    protected void onInit() {
        // throw a programmatically exception
        GET("/exception", routeContext -> {
            throw new RuntimeException("My programmatically error");
        });

        // throw an exception that gets handled by a registered ExceptionHandler
        GET("/whoops", routeContext -> {
            throw new ForbiddenException("You didn't say the magic word!");
        });

        // register a custom ExceptionHandler
        getErrorHandler().setExceptionHandler(ForbiddenException.class, new ExceptionHandler() {
        
            @Override
            public void handle(Exception e, RouteContext routeContext) {
                routeContext.setLocal("message", e.getMessage());
                // render the template associated with this http status code ("pippo/403forbidden" by default)
                getErrorHandler().handle(403, routeContext);
            }
            
        });
    }
    
    public static class ForbiddenException extends RuntimeException {

        public ForbiddenException(String message) {
            super(message);
        }
        
    }

}
```
  
If you want to customize the template content for the default error templates (see the list of templates names in [TemplateEngine]({{ site.coreurl }}/src/main/java/ro/pippo/core/TemplateEngine.java)) then create a template with the same name in `src/main/resources/templates` folder. 
