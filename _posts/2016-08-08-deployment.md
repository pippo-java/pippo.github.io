---
layout: page
title: "Deployment"
category: doc
date: 2016-08-08 09:46:53
order: 220
---

#### Packaging

The recommended way to deploy Pippo applications is as a normal executable application with an embedded web server.

In order to create a .zip file consisting of your application and its dependencies, complete the following steps:

* Create a `src/main/assembly/assembly.xml` file with the following content:

```xml
<assembly>
    <id>app</id>
    <formats>
        <format>zip</format>
    </formats>
    <includeBaseDirectory>false</includeBaseDirectory>
    <dependencySets>
        <dependencySet>
            <useProjectArtifact>false</useProjectArtifact>
            <scope>runtime</scope>
            <outputDirectory>lib</outputDirectory>
            <includes>
                <include>*:jar:*</include>
            </includes>
        </dependencySet>
    </dependencySets>
    <fileSets>
        <fileSet>
            <directory>${project.build.directory}</directory>
            <outputDirectory>.</outputDirectory>
            <includes>
                <include>*.jar</include>
            </includes>
            <excludes>
                <exclude>*-javadoc.jar</exclude>
                <exclude>*-sources.jar</exclude>
            </excludes>
        </fileSet>
    </fileSets>
</assembly>
```

* Add the following to your `pom.xml` file:

```xml
<build>
    <plugins>
        <plugin>
            <artifactId>maven-assembly-plugin</artifactId>
            <version>2.3</version>
            <configuration>
                <descriptors>
                    <descriptor>src/main/assembly/assembly.xml</descriptor>
                </descriptors>
                <appendAssemblyId>false</appendAssemblyId>
            </configuration>
            <executions>
                <execution>
                    <id>make-assembly</id>
                    <phase>package</phase>
                    <goals>
                        <goal>attached</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-jar-plugin</artifactId>
            <version>2.3.1</version>
            <configuration>
                <archive>
                    <manifest>
                        <addClasspath>true</addClasspath>
                        <classpathPrefix>lib/</classpathPrefix>
                        <mainClass>${main.class}</mainClass>
                    </manifest>
                </archive>
            </configuration>
        </plugin>
    </plugins>
</build>
```

* Add `<main.class>com.path.to.your.MainClass</main.class>` to the `properties` element in your `pom.xml`, replacing the given path with one for the file containing your main method

* Execute `mvn clean package` and view your packaged application at `target/yourappname-#.#.#.zip`

#### Deployment

* Transfer the .zip file to your server
* Unzip it
* Execute `java -jar yourappname-#.#.#.jar`

#### Snapshot Workaround

If you are using a SNAPSHOT version of Pippo as described in the [Maven section](../dev/maven.html), a small workaround is necessary due to a Maven bug:

* Add `<outputFileNameMapping>${artifact.artifactId}-${artifact.baseVersion}${dashClassifier?}.${artifact.extension}</outputFileNameMapping>` to the `dependencySet` element inside `assembly.xml`

* Add `<useUniqueVersions>false</useUniqueVersions>` to the maven-jar-plugin's `manifest` section inside `pom.xml`
