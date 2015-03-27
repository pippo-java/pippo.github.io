---
layout: page
title: "Runtime mode"
category: doc
date: 2015-03-17 17:39:06
order: 70
---

An application can run in three modes: 

- __DEV__ (development)
- __TEST__ (testing)
- __PROD__ (production).

You can change the runtime mode using the __pippo.mode__ system property (`-Dpippo.mode=dev` in command line or `System.setProperty("pippo.mode", "dev")`).  

The default mode is __PROD__.  

You can do some business according to this parameter. For example if the runtime mode is __DEV__ then in _pippo-freemarker_ module the cache for templates is disabled.

You can retrieves the current runtime mode using `RuntimeMode.getCurrent()`.
