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
 
So, by default, the following templates are available (copy/paste from `TemplateEngine.java`): 

```java
public final static String BAD_REQUEST_400 = "pippo/400badRequest";
public final static String UNAUTHORIZED_401 = "pippo/401unauthorized";
public final static String PAYMENT_REQUIRED_402 = "pippo/402paymentRequired";
public final static String FORBIDDEN_403 = "pippo/403forbidden";
public final static String NOT_FOUND_404 = "pippo/404notFound";
public final static String METHOD_NOT_ALLOWED_405 = "pippo/405methodNotAllowed";
public final static String CONFLICT_409 = "pippo/409conflict";
public final static String GONE_410 = "pippo/410gone";
public final static String INTERNAL_ERROR_500 = "pippo/500internalError";
public final static String NOT_IMPLEMENTED_501 = "pippo/501notImplemented";
public final static String OVERLOADED_502 = "pippo/502overloaded";
public final static String SERVICE_UNAVAILABLE_503 = "pippo/503serviceUnavailable";
```

Each template engine implementation comes with above templates. For example if we take a look at `pippo-template-parent/pippo-freemarker/src/main/resources` we can see:
```
$ tree .
.
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

If you use `FreemarkerTemplateEngine` in your application and you want to replace/override the content of `404notFound.ftl` template,
then place your variant of `404notFound.ftl` in your `src/main/resources/templates/pippo` directory.

If you are not happy with this fine granularity (a template for each HTTP error code), then you can create your custom `ErrorHandler` that returns the same template for any status code:
```java
public class MyErrorHandler extends DefaultErrorHandler {
    
    public ExampleErrorHandler(Application application) {
        super(application);
    }

    @Override
    protected String getTemplateForStatusCode(int statusCode) {
        return "error.ftl"; // or simple "error" without extension
    }
    
}
```

and use your custom error handler in your application:
```java
public class MyApplication extends Application {
    
    @Override
    protected void onInit() {
        setErrorHandler(new MyErrorHandler(this));
        
        // add routes below
    }
    
}
```
