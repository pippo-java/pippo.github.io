---
layout: page
title: "WebSocket"
category: doc
date: 2017-07-20 20:03:09
order: 200
---

#### How to use

Pippo allows you to use [WebSocket](https://en.wikipedia.org/wiki/WebSocket) in your application in an easy and uniform mode.
You use the same interface for all major embedded web server supported by Pippo builtin (Jetty, Tomcat and Undertow).  
 
The `Application` class contains a method with the signature:

``` java
public void addWebSocket(String path, WebSocketHandler webSocketHandler);
```

`WebSocketHandler` is an interface (functional) that contains one method 

``` java
void onMessage(WebSocketContext webSocketContext, String message);
```

and some default methods.

To add an echo application based on websocket you should write something similar with:

``` java
// add web socket
addWebSocket("/ws/echo", (webSocketContext, message) -> {
    try {
        webSocketContext.sendMessage(message);
    } catch (IOException e) {
        e.printStackTrace();
    }
});
```

If you need more control you can override other methods available in `WebSocketHandler`:

``` java
addWebSocket("/ws/echo", new WebSocketHandler() {

    @Override
    public void onMessage(WebSocketContext webSocketContext, String message) {
        System.out.println("TestWebSocket.onMessage");
        System.out.println("message = " + message);
        try {
            webSocketContext.sendMessage(message);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onMessage(WebSocketContext webSocketContext, byte[] message) {
        System.out.println("TestWebSocket.onMessage");
    }

    @Override
    public void onOpen(WebSocketContext webSocketContext) {
        System.out.println("TestWebSocket.onOpen");
    }

    @Override
    public void onClose(WebSocketContext webSocketContext, int closeCode, String message) {
        System.out.println("TestWebSocket.onClose");
    }

    @Override
    public void onTimeout(WebSocketContext webSocketContext) {
        System.out.println("TestWebSocket.onTimeout");
    }

    @Override
    public void onError(WebSocketContext webSocketContext, Throwable t) {
        System.out.println("TestWebSocket.onError");
    }

});
```

In above example, I used a standard `Route` to serve the `index.html` file that contains the script block with the websocket client side:

``` java
GET("/", routeContext -> {
    try {
        routeContext.send(IoUtils.toString(WebSocketApplication.class.getResourceAsStream("/index.html")));
    } catch (IOException e) {
        e.printStackTrace();
    }
});

// OR

DirectoryHandler directoryHandler = new DirectoryHandler("/", new File("src/main/resources"));
GET(directoryHandler.getUriPattern(), directoryHandler);
```

**Note** A functional demo is available to [pippo-demo-websocket]({{ site.demourl }}/pippo-demo-websocket).