---
layout: page
title: "Getting started"
category: doc
date: 2015-03-17 17:18:31
order: 10
---

We provide a pippo-demo module that contains many demo applications (submodules): pippo-demo-basic and pippo-demo-crud are some.  
For a list with all demo please see [Demo](demo.html) section.

For [pippo-demo-basic]({{ site.demourl }}/pippo-demo-basic) you have two java files: [BasicDemo.java]({{ site.demourl }}/pippo-demo-basic/src/main/java/ro/pippo/demo/basic/BasicDemo.java) and [BasicApplication.java]({{ site.demourl }}/pippo-demo-basic/src/main/java/ro/pippo/demo/basic/BasicApplication.java)  
We split our application in two parts for a better readability.

First we must create a BasicApplication (extends [Application]({{ site.coreurl }}/src/main/java/ro/pippo/core/Application.java)) and add some routes:

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

where `Contact` is a simple POJO:

```java
public class Contact  {

    private int id;
    private String name;
    private String phone;
    private String address;
    
    // getters and setters

}
```

The last step it's to start Pippo with your application as parameter:

```java
public class BasicDemo {

    public static void main(String[] args) {
        Pippo pippo = new Pippo(new BasicApplication());
        pippo.start();
    }

}
```

Pippo launches the embedded web server (found in your classpath) and makes the application available on port `8338` (default value).
Open your internet browser and check the routes declared in Application:

 - `http://localhost:8338`
 - `http://localhost:8338/file`
 - `http://localhost:8338/json`
 - `http://localhost:8338/xml`
 - `http://localhost:8338/negotiate`
 - `http://localhost:8338/template` 
 
For a detailed overview please see section [Under the hood](/dev/under-the-hood.html).
