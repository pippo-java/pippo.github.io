---
layout: page
title: "Hot reloading"
category: doc
date: 2017-07-18 22:30:05
order: 199
---

#### How to use
This feature allows you to write code, save the code on disk and reload the web page from browser without restart the application (from IDE).

```java
@MetaInfServices
public class PippoApplication extends Application {

    @Override
    protected void onInit() {
        GET("/", routeContext -> routeContext.send("Hello"));
    }

}
```
```java
public class PippoLauncher {

    public static void main(String[] args) {
        Pippo pippo = new Pippo();
        pippo.start();
    }

}
```

So, the code is almost the same with the version without hot reloading. The only one difference is that you must specify 
your **application class name** and **NOT** to create the application instance.
 
You can supply the application class name using one of the below methods:

- create by hand a `META-INF/services/ro.pippo.core.Application` file with content `mypackage.PippoApplication` (see Java [ServiceLoader](https://docs.oracle.com/javase/8/docs/api/java/util/ServiceLoader.html))
- add a `MetaInfServices` annotation on your application class (generate automatically the `META-INF/services/ro.pippo.core.Application` file)
- use `-Dpippo.applicationClassName` system property

#### How works
To implement hot reloading, Pippo introduces two new concepts (classes in package `ro.pippo.core.reload`):

- `ReloadWatcher`
- `ReloadClassLoader`

The `ReloadWatcher` class runs a background task that checks directories for new, modified or removed files. The default directory is `target/classes` (standard from Maven) but you can specify other target classes directory via `-Dpippo.reload.targetClasses` system property.
When `ReloadWatcher` detects a modification, the method `onEvent(ReloadWatcher.Event event, Path dir, Path path)` method from `Pippo` class is called. 

By default, the `onEvent` method does:

- stop server;
- create a new instance of application using `ReloadClassLoader`
- set the new application instance in `PippoFilter`
- start server

You can overwrite this method (onEvent) if you wish more control (not to restart the server, only to ...).

The `ReloadClassLoader` class is a Java `ClassLoader` that loads classes from files. You can specify the classes that will be loaded by this loader using `-Dpippo.reload.rootPackageName` system property (for example I want to reload only classes from web layer, classes with packages that start with "mycompany.web").

By default, hot reloading mechanism is enabled if you are in `dev` (development) mode and you use the application class name instead of application instance. You can use `-Dpippo.reload.enabled` system property to enable or disable the hot reloading mechanism.

**Note** If you use Idea IntelliJ as IDE, it's a good idea to remap `Ctrl-Shift-F9` (compile file) to `Ctrl-S` (save file) to compile file on save (see [post](https://intellij-support.jetbrains.com/hc/en-us/community/posts/206996845-compile-on-file-save)).
