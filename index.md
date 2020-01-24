---
layout: default
title: "Pippo"
---

<img src="{{ site.baseurl }}/pippo-logo.svg" width="250"/>

It's an open source ([Apache License](http://www.apache.org/licenses/LICENSE-2.0)) micro web framework in Java, with minimal dependencies and a quick learning curve.     
The goal of this project is to create a micro web framework in Java that should be easy to use and hack.  
Pippo can be used in small and medium applications and also in applications based on micro services architecture.   
We believe in simplicity and we will try to develop this framework with these words in mind.  

The core is small (around **140 KB**) and we intend to keep it as small/simple as possible and to push new functionalities in pippo modules and third-party repositories/modules.  
You are not forced to use a specific template engine or an embedded web server. Furthermore you have multiple out of the box options (see [Templates](/doc/templates.html) and [Server](/doc/server.html)).  

Also, Pippo comes with a very small footprint that makes it excellent for embedded devices (Raspberry Pi for example).  
 
The framework is based on __Java Servlet 3.1__ and requires __Java 8__.

<br>

If you like Pippo, please consider starring us on GitHub:
<a class="github-button" href="https://github.com/pippo-java/pippo" data-size="large" data-show-count="true" aria-label="Star Pippo on GitHub">Star</a>
   
**Talk is cheap. Show me the code.**

#### 1.1 Routes approach

Add some routes in your application:

```java
public class BasicApplication extends Application {

    @Override
    protected void onInit() {
        // send 'Hello World' as response
        GET("/", routeContext -> routeContext.send("Hello World"));

        // send a file as response
        GET("/file", routeContext -> routeContext.send(new File("pom.xml")));

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

        // send a template with name "hello" as response
        GET("/template", routeContext -> {
            routeContext.setLocal("greeting", "Hello"); // template's model/context
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

#### 1.2 Controllers approach

Define controller(s):

```java
@Path("/contacts")
@Logging
public class ContactsController extends Controller {

    private ContactService contactService;

    public ContactsController() {
        contactService = new InMemoryContactService();
    }

    @GET
    @Named("index")
//    @Produces(Produces.HTML)
    @Metered
    @Logging
    public void index() {
        // inject "user" attribute in session
        getRouteContext().setSession("user", "decebal");

        // send a template with name "contacts" as response
        getResponse()
            .bind("contacts", contactService.getContacts())
            .render("contacts");
    }

    @GET("/uriFor/{id: [0-9]+}")
    @Named("uriFor")
    @Produces(Produces.TEXT)
    @Timed
    public String uriFor(@Param int id, @Header String host, @Session String user) {
        System.out.println("id = " + id);
        System.out.println("host = " + host);
        System.out.println("user = " + user);

        Map<String, Object> parameters = new HashMap<>();
        parameters.put("id", id);

        String uri = getApplication().getRouter().uriFor("api.get", parameters);

        return "id = " + id + "; uri = " + uri;
    }

    @GET("/api")
    @Named("api.getAll")
    @Produces(Produces.JSON)
    @NoCache
    public List<Contact> getAll() {
        return contactService.getContacts();
    }

    @GET("/api/{id: [0-9]+}")
    @Named("api.get")
    @Produces(Produces.JSON)
    public Contact get(@Param int id) {
        return contactService.getContact(id);
    }

}
```

```java
@Path("/files")
public class FilesController extends Controller {

    @GET
    public void index() {
        // send a template with name "files" as response
        getRouteContext().render("files");
    }

    @GET("/download")
    public File download() {
        // send a file as response
        return new File("pom.xml");
    }

    @POST("/upload")
    @Produces(Produces.TEXT)
    public String upload(FileItem file) {
        // send a text (the info about uploaded file) as response
//        return file.toString();
        return new StringBuilder()
            .append(file.getName()).append("\n")
            .append(file.getSubmittedFileName()).append("\n")
            .append(file.getSize()).append("\n")
            .append(file.getContentType())
            .toString();
    }

}
```

Add controller(s) in your application:

```java
public class BasicApplication extends ControllerApplication {

    @Override
    protected void onInit() {
        addControllers(ContactsController.class); // one instance for EACH request
        // OR
        addControllers(new ContactsController()); // one instance for ALL requests

        addControllers(FilesController.class);
    }

}
```

#### 2. Start your application

```java
public class BasicDemo {

    public static void main(String[] args) {
        Pippo pippo = new Pippo(new BasicApplication());
        pippo.start();
    }

}
```

See [Getting started](/doc/getting-started.html) section for some basic information.
