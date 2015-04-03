---
layout: page
title: "Content types"
category: doc
date: 2015-04-02 14:16:42
order: 55
---

When we send a Response to the client we must specify the content type. In most cases the content type is __html__ (`text/html`) but are situations (for example a REST application/module)
when we want to return __plain text__ (`text/plain`) or __json__ (`application/json`) or __xml__ (`application/xml`) or __yaml__ (`application/x-yaml`).  
To resolve these situations Pippo comes with a nice concept [ContentTypeEngine]({{ site.coreurl }}/src/main/java/ro/pippo/core/ContentTypeEngine.java).  
Pippo comes bultin (direct or via modules) with the following content type engines: 

- plain text ([TextPlainEngine]({{ site.coreurl }}/src/main/java/ro/pippo/core/TextPlainEngine.java))
- xml ([JaxbEngine]({{ site.coreurl }}/src/main/java/ro/pippo/core/JaxbEngine.java), [XstreamEngine]({{ site.codeurl }}/pippo-xstream/src/main/java/ro/pippo/xstream/XstreamEngine.java))
- json ([GsonEngine]({{ site.codeurl }}/pippo-gson/src/main/java/ro/pippo/gson/GsonEngine.java), [FastjsonEngine]({{ site.codeurl }}/pippo-fastjson/src/main/java/ro/pippo/fastjson/FastjsonEngine.java))
- yaml ([SnakeYamlEngine]({{ site.codeurl }}/pippo-snakeyaml/src/main/java/ro/pippo/snakeyaml/SnakeYamlEngine.java))

If you want to develop a new engine of content type you can do it very easily. All you have to do is to implement ContentTypeEngine.  

See below a possible implementation for XstreamEngine (an XmlEngine based on [XStream](http://xstream.codehaus.org)):

```java
public class XstreamEngine implements ContentTypeEngine {

    @Override
    public String getContentType() {
        return HttpConstants.ContentType.APPLICATION_XML; // "application/xml"
    }

	@Override
	public String toString(Object object) {
		return new XStream().toXML(object);
	}

	@Override
	public <T> T fromString(String content, Class<T> classOfT) {
		return (T) new XStream().fromXML(content);
	}

	@Override
	public void init(Application application) {
		// do nothing
	}

}
```

To register a content type engine in your application you have two options:

- add programatically the content type engine in `Application.init()` with `Application.registerContentTypeEngine(XstreamEngine.class)`
- create an [Initializer]({{ site.coreurl }}/src/main/java/ro/pippo/core/Initializer.java) in your project that register the content type engine

For above _XstreamEngine_ we can create an _XstreamInitializer_ with this possible content: 

```java
public class XstreamInitializer implements Initializer {

    @Override
    public void init(Application application) {
        application.registerContentTypeEngine(XstreamEngine.class);
    }

    @Override
    public void destroy(Application application) {
		// do nothing
    }

}
```

Below is an example how to send an xml:

```java
public class BasicApplication extends Application {

    @Override
    public void init() {
        // send xml as response
        GET("/xml", (routeContext) -> {
			Contact contact = createContact();
			routeContext.xml().send(contact);
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

Another useful concept is `Content Type Negotiation`. It can be used via `Response.contentType()` or `ResponseContext.negotiateContentType()`.  
It attempts to set the Content-Type of the Response based on Request headers. The Accept header is preferred for negotiation but the Content-Type
header may also be used if an agreeable content type engine can not be determined.  
If no Content-Type can not be negotiated then the response will not be modified. This behavior allows specification of a default Content-Type
using one of the methods such as `xml()` or `json()`.

See below an example related to content type negotiation: 

```java
public class BasicApplication extends Application {

    @Override
    public void init() {
        // send an object and negotiate the Response content-type, default to XML
        GET("/negotiate", (routeContext) -> {
			Contact contact = createContact();
			routeContext.xml().negotiateContentType().send(contact);
		});
	}

}
```

In above example `routeContext.xml().negotiateContentType().send(contact)` would set the default Content-Type as `application/xml` and
then attempt to negotiate the client's preferred type. If negotiation failed, then the default `application/xml` would be sent and used to
serialize the outgoing object.  

