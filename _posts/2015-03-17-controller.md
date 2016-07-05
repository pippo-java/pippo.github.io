---
layout: page
title: "Controller"
category: mod
date: 2015-03-17 17:51:53
order: 0
---

Another approach to handling a request and producing a response is using Controllers. After routing has determined what controller to use, an action method will be invoked.
In Pippo, controllers are instances of [Controller]({{ site.codeurl }}/pippo-controller-parent/pippo-controller/src/main/java/ro/pippo/controller/Controller.java).

Defining a new controller is simple:

```java
public class ContactsController extends Controller {

    public void index() {
		List<Contact> contacts = contactService.getContacts();
		getResponse().bind("contacts", contacts).render("contacts");
    }
    
    public void getContact(@Param("id") int id) {
        Contact contact = contactService.getContact(id);
        getResponse().bind("contact", contact).render(contact);
    }

}
```

Methods attached to the controller (for example `index` from above snippet) are known as action methods. When Pippo receives a request, it will create a new instance of the controller and call the appropriate action method.
You can register a controller's action in application with a simple line:

```java
public class ControllerDemo {

    public static void main(String[] args) {
        Pippo pippo = new Pippo();
        pippo.getApplication().GET("/", ContactsController.class, "index");
        pippo.getApplication().GET("/contact/{id}", ContactsController.class, "getContact");
        pippo.start();
    }

}
```

You can see a demo [here]({{ site.demourl }}/pippo-demo-controller)
