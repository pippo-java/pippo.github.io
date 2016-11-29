---
layout: page
title: "Reverse routing"
category: doc
date: 2015-03-17 18:00:00
order: 110
---

Reverse routing is a feature in Pippo that is used to allow you to easily change your URL structure without having to modify all your code.  
Why would you want to build URLs instead of hard-coding them into your templates?  
One answer is that reversing is often more descriptive than hard-coding the URLs. More importantly, it allows you to change URLs in one go, without having to remember to change URLs all over the place.  

If you create a route like (the Controller aproach):

```java
GET("/contacts/{id}", ContactsController.class, "show");
```

This route will take requests such as `/contacts/1` and map it to the __show__ method on the __Contacts__ controller.

Using reverse routing we can create a link to it and pass in any parameters that we have defined. Extra parameters suplied in method `Router.uriFor` are added as query parameters in the generated link.  
Also this method is available as a shortcut in `RouteContext`.

```java
Map<String, Object> parameters = new HashMap<>();
parameters.put("id", 1);
parameters.put("action", "new"); // extra parameter
String url = routeContext.uriFor(ContactsController.class, "show", parameters);
```
And now the link created should be something like `/contacts/1?action=new`.

The same can be applied to non controller routes:

```java
GET("/contacts/{id}", routeContext -> {...}
```

Now we can use `uriFor(String uriPattern, Map<String, Object> parameters)` method to retrieves the URL:

```java
Map<String, Object> parameters = new HashMap<>();
parameters.put("id", 1);
parameters.put("action", "new");
String url = routeContext.uriFor("/contacts/{id}", parameters);
```

Are some scenarios when it's more ease to use the route name for `uriFor()`.  
In few words I can add a route (in an hypothetical blog application) that render a template with:

```java
GET("/blogs/{year}/{month}/{day}/{title}", routeContext -> { routeContext.render("myTemplate")});
```

It's hard to create the reverse routing using the `uriPattern`:

```java
Map<String, Object> parameters = ...
routeContext.uriFor("/blogs/{year}/{month}/{day}/{title}", parameters);
```

The simplest solution is to add a `name` to our route and to use this name when we build the URL(reverse routing) to that route:

```java
GET("/blogs/{year}/{month}/{day}/{title}", routeContext -> routeContext.render("myTemplate")).named("blog");
```

The new code becomes more short and readable:

```java
Map<String, Object> parameters = ...
routeContext.uriFor("blog", parameters);
```

Advantages:

- it is often more descriptive than hard-coding the `uriPattern`
- it allows you to change `uriPattern` in one go, without having to remember to change URLs all over the place.


**Note:** By default (via `DefaultRouter`) the `uriFor` method automatically encode the parameters values.

In conclusion if you want to create links to routes or controllers you must use `Router.uriFor` methods.

