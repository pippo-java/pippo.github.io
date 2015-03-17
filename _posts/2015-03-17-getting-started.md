---
layout: page
title: "Getting started"
category: doc
date: 2015-03-17 17:18:31
order: 0
---

We provide a pippo-demo module that contains many demo applications: SimpleDemo and CrudDemo are some.

For SimpleDemo you have two java files: SimpleDemo.java and SimpleApplication.java

> **NOTE**
> Pippo is built using Java 1.7 (and NOT Java 1.8) but we will use lambdas in examples to show shorter code. 

```java
public class SimpleDemo {

    public static void main(String[] args) {
        Pippo pippo = new Pippo(new SimpleApplication());
        pippo.start();
    }

}

public class SimpleApplication extends Application {

    @Override
    public void init() {
        super.init();

        GET("/", (request, response, chain) -> response.send("Hello World"));

        GET("/file", (request, response, chain) -> response.file(new File("pom.xml"));

        GET("/json", (request, response, chain) -> {
            Contact contact = new Contact()
                    .setName("John")
                    .setPhone("0733434435")
                    .setAddress("Sunflower Street, No. 6");
            // you can use variant 1 or 2
            //response.contentType(HttpConstants.ContentType.APPLICATION_JSON); // 1
            //response.send(new Gson().toJson(contact)); // 1
            response.json(contact); // 2
         });

        GET("/template", (request, response, chain) -> {
            Map<String, Object> model = new HashMap<>();
            model.put("greeting", "Hello my friend");
            response.render("hello", model);
        });

        GET("/error", (request, response, chain) -> { throw new RuntimeException("Error"); });
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

After run the application, open your internet browser and check the routes declared in Application (`http://localhost:8338/`, 
`http://localhost:8338/file`, `http://localhost:8338/json`, `http://localhost:8338/error`).


