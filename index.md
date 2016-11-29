---
layout: default
title: "Pippo"
---

     ____  ____  ____  ____  _____
    (  _ \(_  _)(  _ \(  _ \(  _  )
     ) __/ _)(_  ) __/ ) __/ )(_)( 
    (__)  (____)(__)  (__)  (_____)

It's an open source ([Apache License](http://www.apache.org/licenses/LICENSE-2.0)) micro web framework in Java, with minimal dependencies and a quick learning curve.     
The goal of this project is to create a micro web framework in Java that should be easy to use and hack.  
Pippo can be used in small and medium applications and also in applications based on micro services architecture.   
We believe in simplicity and we will try to develop this framework with these words in mind.  

The core is small (around 140k) and we intend to keep it as small/simple as possible and to push new functionalities in pippo modules and third-party repositories/modules.  
You are not forced to use a specific template engine or an embedded web server. Furthermore you have multiple out of the box options (see [Templates](/doc/templates.html) and [Server](/doc/server.html)).  

Also, Pippo comes with a very small footprint that makes it excellent for embedded devices (Raspberry Pi for example).  
 
The framework is based on Java Servlet 3.0 and requires Java 8.

<br>
   
**Talk is cheap. Show me the code.**

1) Add some routes in your application

```java
public class BasicApplication extends Application {

    @Override
    protected void onInit() {
		// send 'Hello World' as response
        GET("/", routeContext -> routeContext.send("Hello World"));

		// send a file as response
        GET("/file", routeContext -> routeContext.send(new File("pom.xml"));

        // send a json as response
        GET("/json", routeContext -> {
			Contact contact = createContact();
			routeContext.json().send(contact);
        });

        // send xml as response
        GET("/xml", routeContext -> {
			Contact contact = createContact();
			routeContext.xml().send(contact);
        });
        
        // send an object and negotiate the Response content-type, default to XML
        GET("/negotiate", routeContext -> {
        	Contact contact = createContact();
			routeContext.xml().negotiateContentType().send(contact);
        });
        
        // send a template as response
        GET("/template", routeContext -> {
			routeContext.setLocal("greeting", "Hello");
			routeContext.render("hello");        
		});
    }

	private Contact createContact() {
		return new Contact()
			.setId(12345)
			.setName("John")
			.setPhone("0733434435")
			.setAddress("Sunflower Street, No. 6");	
	}
	
}
``` 

2) Start your application

```java
public class BasicDemo {

    public static void main(String[] args) {
        Pippo pippo = new Pippo(new BasicApplication());
        pippo.start();
    }

}
```

See [Getting started](/doc/getting-started.html) section for some basic information.
