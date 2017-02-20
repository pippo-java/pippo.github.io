---
layout: page
title: "Controller"
category: mod
date: 2015-03-17 17:51:53
order: 0
---

Another approach to handling a request and producing a response is using Controllers. After routing has determined what controller to use, an action method will be invoked.
In Pippo, controllers are instances of [Controller]({{ site.codeurl }}/pippo-controller-parent/pippo-controller/src/main/java/ro/pippo/controller/Controller.java).

#### How to use

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
public class MyApplication extends ControllerApplication {

    @Override
    protected void onInit() {
        // add controller(s)
        addControllers(ContactsController.class); // one instance for EACH request
        // or
        addControllers(new ContactsController()); // one instance for ALL requests        
    }

}
```

```java
public class ControllerDemo {

    public static void main(String[] args) {
        Pippo pippo = new Pippo(new MyApplication());
        pippo.start();
    }

}
```

#### Implementation details

Advanced features (Extractor, Interceptor, ...) and technical aspects are presented in details [here](https://github.com/decebals/pippo/pull/341).

You can see a demo [here]({{ site.demourl }}/pippo-demo-controller)
