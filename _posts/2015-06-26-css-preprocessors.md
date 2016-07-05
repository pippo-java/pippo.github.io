---
layout: page
title: "CSS pre-processors"
category: mod
date: 2015-06-26 21:31:52
order: 18
---

Both Less and Sass are CSS pre-processors, meaning that both extends the CSS language, adding features that allow variables, mixins, functions,
 and many other techniques that allow you to make CSS that is more maintainable, themable and extendable. 

#### LESS

Pippo uses [less4j](https://github.com/SomMeri/less4j) for Less compiler. Less4j is a compiler written in java that outputs the same as less.js.
Any difference in output will be considered as a bug and will be fixed.
Simply add the dependency like this:

```xml
<dependency>
    <groupId>ro.pippo</groupId>
    <artifactId>pippo-less4j</artifactId>
    <version>${project.version}</version>
</dependency>	
```
You can enable using the less4j handler in your Application.onInit method like this:

```java
addResourceRoute(new LessResourceHandler("/lesscss", "public/less"));
```
where `/lesscss` will be the context path that for the less folder files.

#### SASS

For Sass implementation Pippo used [sass-compiler](https://github.com/vaadin/sass-compiler). This is also a pure Java implementation of [http://sass-lang.com](http://sass-lang.com) compiler
written for [Vaadin](https://vaadin.com/home) framework.
Again add the dependecy like this:

```xml
<dependency>
    <groupId>ro.pippo</groupId>
    <artifactId>pippo-sasscompiler</artifactId>
    <version>${project.version}</version>
</dependency>	
```

Also you can enable using the sass handler in your Application.onInit method like this:

```java
addResourceRoute(new SassResourceHandler("/sasscss", "public/sass"));
```
where `/sasscss` will be the context path that for the sass folder files.

Mixin both sass and less in your project is possible as you can see in the [demo](https://github.com/decebals/pippo-demo/tree/master/pippo-demo-css).
