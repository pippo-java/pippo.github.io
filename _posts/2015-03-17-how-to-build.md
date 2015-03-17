---
layout: page
title: "How to build"
category: dev
date: 2015-03-17 18:11:49
order: 3
---

Requirements: 

- [Git](http://git-scm.com/) 
- JDK 1.7 (test with `java -version`)
- [Apache Maven 3](http://maven.apache.org/) (test with `mvn -version`)

Steps:

- create a local clone of this repository (with `git clone https://github.com/decebals/pippo.git`)
- go to project's folder (with `cd pippo`) 
- build the artifacts (with `mvn clean package` or `mvn clean install`)

After above steps a folder _target_ is created for each module and all goodies are in that folder.

