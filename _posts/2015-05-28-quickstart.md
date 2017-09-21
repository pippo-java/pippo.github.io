---
layout: page
title: "Quickstart"
category: dev
date: 2015-05-28 17:09:53
order: 5
---

There are two really good reasons to create a Pippo quickstart. The first is if you just want to get started using Pippo quickly. 
The quickstart will set up a ready-to-use project in under a minute (depending on your bandwidth). Another great reason to create a quickstart is to accompany a bug report. 
If you report a bug in [Github](https://github.com/decebals/pippo/issues) or on the [mailing list](http://groups.google.com/group/pippo-java), the core developers may not be able to recreate it easily.

Quickstarts are made from a Maven archetype. So, you will need to have [Maven](http://maven.apache.org) installed and working (from the command line) before following this.

Creating a quickstart provides only a very basic starting point for your Pippo project. If you are looking for examples of how to use Pippo and its various features, please refer to the [demo](/doc/demo.html) projects instead!

To create your project you must follow these steps:

- create your quickstart project:

```
mvn archetype:generate \
  -DarchetypeGroupId=ro.pippo \
  -DarchetypeArtifactId=pippo-quickstart \
  -DarchetypeVersion=1.5.0 \
  -DgroupId=com.mycompany \
  -DartifactId=myproject
```
maybe you want to change `groupId`, `artifactId` and `archetypeVersion` (the last Pippo version)

- run your application from command line:

```
cd myproject
mvn compile exec:java
```
now your application is available at `http://localhost:8338`

If you want to create the `war` file of your application then you must run:

```
mvn -Pwar package
```
The `-Pwar` parameter (switch to `war` profile) excludes the libraries of the embedded web server from the war file. The war file is available in `target` folder.
