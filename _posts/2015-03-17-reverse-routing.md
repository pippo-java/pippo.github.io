---
layout: page
title: "Reverse routing"
category: doc
date: 2015-03-17 18:00:00
order: 90
---

Reverse routing is a feature in Pippo that is used to allow you to easily change your URL structure without having to modify all your code.  
Why would you want to build URLs instead of hard-coding them into your templates?  
One answer is that reversing is often more descriptive than hard-coding the URLs. More importantly, it allows you to change URLs in one go, without having to remember to change URLs all over the place.  

If you create a route like (the Controller aproach):

```java
GET("/contacts/{id}", ContactsController.class, "show");
```

This route will take requests such as `/contacts/1` and map it to the __show__ method on the __Contacts__ controller.

Using reverse routing we can create a link to it and pass in any parameters that we have defined. Extra parameters suplied in method urlFor are added as query parameters in the generated link.

```java
Map<String, Object> parameters = new HashMap<>();
parameters.put("id", 1);
parameters.put("action", "new"); // extra parameter
String url = getApplication().urlFor(ContactsController.class, "show", parameters);
```
And now the link created should be something like `/contacts/1?action=new`.

The same can be applied to non controller routes:

```java
GET("/contacts/{id}", (request, response, chain) -> {...}
```

Now we can use `Application.urlFor(String urlPattern, Map<String, Object> parameters)` method to retrieves the URL:

```java
Map<String, Object> parameters = new HashMap<>();
parameters.put("id", 1);
parameters.put("action", "new");
String url = getApplication().urlFor("/contacts/{id}", parameters);
```

In conclusion if you want to create links to routes or controllers you must use `Application.urlFor` methods.

