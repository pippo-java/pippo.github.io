---
layout: page
title: "Spring IoC"
category: doc
date: 2015-03-17 18:07:29
order: 120
---

Pippo can be used together with the Spring framework, using Spring as a dependency injection container. When Pippo creates new instances of your various Controller subclasses, the pippo-spring integration would then take care that the Spring-managed service beans (e.g. Services) get injected into the desired instance fields (marked by the `@Inject` annotations in your code). An example of such a Controller subclass could look as follows:

```java
public class ContactsController extends Controller {

    @Inject
    private ContactService contactService;

    public void index() {
        getResponse().getLocals().put("contacts", contactService.getContacts());
        getResponse().render("crud/contacts");
    }

}
```

Pippo automatically creates the ContactsController instance and pippo-spring integration injects the ContactService service bean, so basically you don’t have to worry about any of that stuff yourself. 

To activate pippo-spring integration in your Application you must add `SpringControllerInjector`:

```java
public class MyApplication extends Application {

    @Override
    public void init() {
        super.init();

        // create spring application context
        ApplicationContext applicationContext = new AnnotationConfigApplicationContext(SpringConfiguration.class);
        
        // registering SpringControllerInjector
        getControllerInstantiationListeners().add(new SpringControllerInjector(applicationContext));

        // add controller
        GET("/", ContactsController.class, "index");        
    }

}
```

where SpringConfiguration can looks like:

```java
@Configuration
public class SpringConfiguration {

    @Bean
    public ContactService contactService() {
        return new InMemoryContactService();
    }

}
```
