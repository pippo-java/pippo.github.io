---
layout: page
title: "Prometheus"
permalink: /mod/metrics/prometheus.html
date: 2018-06-29 13:43:29
---

[Prometheus](https://prometheus.io) is a monitoring system and a time series database.

Add the following dependency to your application `pom.xml`.

```xml
<dependency>
    <groupId>ro.pippo</groupId>
    <artifactId>pippo-metrics-prometheus</artifactId>
    <version>${pippo.version}</version>
</dependency>
```

Add the following settings to your `application.properties`.

```properties
metrics.prometheus.enabled = true
metrics.prometheus.address = prometheus.example.com // default 'localhost'
metrics.prometheus.port = 9091
metrics.prometheus.period = 60 seconds
```
