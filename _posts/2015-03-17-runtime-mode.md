---
layout: page
title: "Runtime mode"
category: doc
date: 2015-03-17 17:39:06
order: 120
---

An application can run in three modes: __DEV__(development), __TEST__(testing) and __PROD__(production).

You can change the runtime mode using the "pippo.mode" system property (`-Dpippo.mode=dev` in command line or `System.setProperty("pippo.mode", "dev")`).  
The default mode is __PROD__.  

For __DEV__ mode in pippo-jetty the cache for static resources is disabled and in pippo-freemarker the cache for templates is disabled also.

You can retrieves the current runtime mode using `RuntimeMode.getCurrent()`.
