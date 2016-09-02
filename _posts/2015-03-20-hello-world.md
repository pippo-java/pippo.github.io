---
layout: page
title: "Hello world"
category: doc
date: 2015-03-20 15:30:47
order: 0
---

See below the classic `Hello World` in Pippo using the embedded web server:

```java
public class HelloWorld {

    public static void main(String[] args) {
        Pippo pippo = new Pippo();
        pippo.GET("/", (routeContext) -> routeContext.send("Hello World!"));
        pippo.start();
    }

}
```

You can run [HelloWorld]({{ site.demourl }}/pippo-demo-basic/src/main/java/ro/pippo/demo/basic/HelloWorld.java) from your IDE (or command line) as a normal (desktop) application.  
The `default port` for the embedded web server is __8338__ so open your internet browser and type `http://localhost:8338` to 
see the result.
