---
layout: page
title: "Internationalization"
category: doc
date: 2015-04-06 16:43:58
order: 195
---

You can get an internationalized message in code via [Messages]({{ site.coreurl }}/src/main/java/ro/pippo/core/Messages.java) or directly in template ([see](/doc/templates/freemarker.html) how you can achieve this in freemarker template engine).  
First you need a definition of supported languages in your [conf/application.properties]({{ site.demourl }}/pippo-demo-crud/src/main/resources/conf/application.properties) file. This is a simple comma separated list (whitespaces are omitted).  

```
# Comma-separated list of supported languages
# First language specified is the default
application.languages = en, ro, de, ru, fr, es
```

The languages are one or two part ISO coded languages. Usually they resemble language or language and country.  
Examples are `en`, `de`, `en-US`, `en-CA` and so on.  

You can access the [Languages]({{ site.coreurl }}/src/main/java/ro/pippo/core/Languages.java) object via `Application.get().getLanguages()`.  

The messages file name follows a convention. The convention is `messages_LANGUAGE.properties` or `messages_LANGUAGE-COUNTRY.properties`.

Some examples:

- language `ro` is specified in [conf/messages_ro.properties]({{ site.demourl }}/pippo-demo-crud/src/main/resources/conf/messages_ro.properties)
- language `en-US` is specified in `conf/messages_en-US.properties`

A messages [file]({{ site.demourl }}/pippo-demo-crud/src/main/resources/conf/messages.properties) might look like:

```
pippo.welcome = Welcome!
pippo.greeting = Hello, my friend!
pippo.languageChoices = Language Choices
pippo.yourLanguageAndLocale = Your language is <b>{0}</b> and your locale is <b>{1}</b>.
pippo.theContextPath = The context path is <b>{0}</b>.
pippo.demonstrations = Demonstrations
pippo.unmatchedRoute = Unmatched Route
pippo.exceptionHandling = Exception Handling
```

Internally we use `MessageFormat.format(text, values)` to format the messages. Therefore all informations from [MessageFormat](http://docs.oracle.com/javase/7/docs/api/java/text/MessageFormat.html) do apply.  

Bellow is an example how you can retrieve programmatically an internationalized message: 

```java
// send an internationalized message as response
GET("/i18n", (routeContext) -> {
	String message;

	String lang = routeContext.getParameter("lang").toString();
	if (lang == null) {
		message = getMessages().get("pippo.greeting", routeContext);
	} else {
		message = getMessages().get("pippo.greeting", lang);
	}

	routeContext.send(message);
});
```

Also, you can access the `Messages` object via `Application.get().getMessages()`.  
