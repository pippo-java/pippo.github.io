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
                
        addControllers(FilesController.class);
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

**DON'T** forget to add `pippo-controller` module as dependency in your project. 
If you use Maven, your `pom.xml` must contains above lines:

```xml
<dependency>
    <groupId>ro.pippo</groupId>
    <artifactId>pippo-controller</artifactId>
    <version>${pippo.version}</version>
</dependency>

```

#### Parameter name

The Controller module may depend on the `-parameters` flag of the Java 8 javac compiler. This flag embeds the names of method parameters in the generated .class files.
  
By default Java 8 does not compile with this flag set so you must specify javac compiler arguments for Maven and your IDE.
```xml
<build>
  <plugins>
    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <configuration>
            <source>1.8</source>
            <target>1.8</target>
            <compilerArguments>
                <parameters/>
            </compilerArguments>
        </configuration>
    </plugin>
  </plugins>
</build>
```

So, if you you compile with `-parameters` flag you can define the controller method like:
```java
void invoice(@Param orderId) { ... }
```

instead of:
```java
void invoice(@Param("orderId") orderId) { ... }
```

If you use the first variant without `-parameters` flag on compile, you will receive an exception like:
```java
ro.pippo.core.PippoRuntimeException: Method 'acme.controller.MyController::invoice' parameter 0 does not specify a name!
	at ro.pippo.controller.extractor.ParamExtractor.getParameterName(ParamExtractor.java:69)
	at ro.pippo.controller.extractor.ParamExtractor.extract(ParamExtractor.java:44)
	at ro.pippo.controller.ControllerRouteHandler.prepareMethodParameters(ControllerRouteHandler.java:388)
	at ro.pippo.controller.ControllerRouteHandler.handle(ControllerRouteHandler.java:120)
	at ro.pippo.core.route.DefaultRouteContext.handleRoute(DefaultRouteContext.java:394)
	at ro.pippo.core.route.DefaultRouteContext.next(DefaultRouteContext.java:276)
	at ro.pippo.core.route.RouteDispatcher.onRouteDispatch(RouteDispatcher.java:153)
	at ro.pippo.core.route.RouteDispatcher.dispatch(RouteDispatcher.java:101)
	at ro.pippo.core.PippoFilter.processRequest(PippoFilter.java:179)
```  
  
#### Implementation details

Advanced features (Extractor, Interceptor, ...) and technical aspects are presented in details [here](https://github.com/decebals/pippo/pull/341).

You can see a demo [here]({{ site.demourl }}/pippo-demo-controller)
