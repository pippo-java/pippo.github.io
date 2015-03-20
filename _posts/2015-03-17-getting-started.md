---
layout: page
title: "Getting started"
category: doc
date: 2015-03-17 17:18:31
order: 10
---

We provide a pippo-demo module that contains many demo applications: pippo-demo-basic and pippo-demo-crud are some.  
For a list with all demo please see [Demo](demo.html) section.

For [pippo-demo-basic]({{ site.demourl }}/pippo-demo-basic) you have two java files: [BasicDemo.java]({{ site.demourl }}/pippo-demo-basic/src/main/java/ro/pippo/demo/basic/BasicDemo.java) and [BasicApplication.java]({{ site.demourl }}/pippo-demo-basic/src/main/java/ro/pippo/demo/basic/BasicApplication.java)  
We split our application in two parts for a better readability.

First we must create a BasicApplication (extends Application) and add some routes:

```java
public class BasicApplication extends Application {

    @Override
    public void init() {
		// send 'Hello World' as response
        GET("/", (routeContext) -> routeContext.send("Hello World"));

		// send a file as response
        GET("/file", (routeContext) -> routeContext.send(new File("pom.xml"));

        // send a json as response
        GET("/json", (routeContext) -> {
            Contact contact = new Contact()
				.setId(12345)
				.setName("John")
				.setPhone("0733434435")
				.setAddress("Sunflower Street, No. 6");
            // you can use variant 1 or 2
//            response.contentType(HttpConstants.ContentType.APPLICATION_JSON); // 1
//            response.send(new Gson().toJson(contact)); // 1
            routeContext.json().send(contact); // 2
         });

        // send xml as response
        GET("/xml", (routeContext) -> {
			Contact contact = new Contact()
				.setId(12345)
				.setName("John")
				.setPhone("0733434435")
				.setAddress("Sunflower Street, No. 6");
			// you can use variant 1 or 2
//                response.contentType(HttpConstants.ContentType.APPLICATION_XML); // 1
//                response.send(new Xstream().toXML(contact)); // 1
			routeContext.xml().send(contact); // 2
        });
        
        // send an object and negotiate the Response content-type, default to XML
        GET("/negotiate", (routeContext) -> {
			Contact contact = new Contact()
				.setId(12345)
				.setName("John")
				.setPhone("0733434435")
				.setAddress("Sunflower Street, No. 6");
			routeContext.xml().negotiateContentType().send(contact);
        });
        
        // send a template as response
        GET("/template", (routeContext) -> {
			routeContext.setLocal("greeting", "Hello");
			routeContext.render("hello");        
		});
    }

}
``` 

where `Contact` is a simple POJO:

```java
public class Contact  {

    private int id;
    private String name;
    private String phone;
    private String address;
    
    // getters ans setters

}
```

The last step it's to start Pippo with your application as parameter:

```java
public class SimpleDemo {

    public static void main(String[] args) {
        Pippo pippo = new Pippo(new BasicApplication());
        pippo.start();
    }

}

```

Pippo launchs the embedded web server (found in your classpath) and makes the application available on port `8338` (default value).
Open your internet browser and check the routes declared in Application:

 - `http://localhost:8338`
 - `http://localhost:8338/file`
 - `http://localhost:8338/json`
 - `http://localhost:8338/xml`
 - `http://localhost:8338/negotiate`
 - `http://localhost:8338/template` 
