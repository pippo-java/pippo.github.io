---
layout: page
title: "Getting started"
category: doc
date: 2015-03-17 17:18:31
order: 10
---

We provide a pippo-demo module that contains many demo applications (submodules): pippo-demo-basic and pippo-demo-crud are some.  
For a list with all demo please see [Demo](demo.html) section.

#### 1. Routes approach 

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
 
#### 2. Controllers approach

Another approach to handling a request and producing a response is using Controllers. After routing has determined what controller to use, an action method will be invoked.
In Pippo, controllers are instances of [Controller]({{ site.codeurl }}/pippo-controller-parent/pippo-controller/src/main/java/ro/pippo/controller/Controller.java).

Defining a new controller is simple:

```java
@Path("/contacts")
public class ContactsController extends Controller {

    @GET("/?")
    public void index() {
		List<Contact> contacts = contactService.getContacts();
		getResponse().bind("contacts", contacts).render("contacts");
    }
    
    @GET("/{id: [0-9]+}")
    public void getContact(@Param int id) {
        Contact contact = contactService.getContact(id);
        getResponse().bind("contact", contact).render(contact);
    }

    @GET("/text")
    @Named("text")
    @Produces(Produces.TEXT)
    @NoCache
    public void complex(@Param int id, @Param String action, @Header String host, @Session String user) {
        // do something
    }
    
}
```

Methods attached to the controller (for example `index` from above snippet) are known as action methods. When Pippo receives a request, it will create a new instance of the controller and call the appropriate action method.
You can register a controller's action in application with a simple line:

```java
public class BasicApplication extends ControllerApplication {

    @Override
    protected void onInit() {
        addControllers(ContactsController.class); // one instance for EACH request
        // OR
        addControllers(new ContactsController()); // one instance for ALL requests        
    }

}
```

For more information about Controllers please see [Controller](controller.html) section.
 
For a detailed overview please see section [Under the hood](/dev/under-the-hood.html).
