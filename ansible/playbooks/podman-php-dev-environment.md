---
date: August 30, 2022
export_on_save:
    html: true
    pandoc: true
fontsize: 10pt
geometry: margin=0.5in
html:
  embed_local_images: false
  embed_svg: true
  offline: false
  toc: true
lang: en_us
linkcolor: red
output: 
    pdf_document:
        highlight: pygments
papersize: letter
print_background: true
thanks: Thanks to those who wrote it first.
title: "PHP Development Environment with Podman"
---

# Setup a Local PHP Development Environment Using Podman

The purpose of this document is to walk you through creating a development environment in the current working directory. At the end, you'll have the opportunity to export the pod so that is easily reproduced. With a minimal amount of edits, the pod can be used for multiple projects.

## Create a Pod with Containers[^1]

This command creates a pod with port ```8080``` mapped to inside port 80. If you then spin up a container listening on port 80, you'd have connectivity.

```bash
podman pod create --name pod-php-dev -p 3306:3306 -p 8080:80 -p 8081:8081 --network bridge
```
This will return a long string that is the ID of the newly created pod.

``` bash
podman pod ls
```
This will return the status of the created pod, which should look similar to:

```bash
POD ID         NAME     STATUS    CREATED         # OF CONTAINERS   INFRA ID
850425b9c02d   pod-php-dev   Created   7 seconds ago   1                 b525a0511d3e
```

### Create a MySQL Container

To create a container in the pod, use podman run, but don't map a port. This makes more sense when you have more than one container to work with, so we'll create a database container using MariaDB[^5] and then an Apache container.

```bash
podman run \
-d --restart=always \
--pod=pod-php-dev \
-e MYSQL_ROOT_PASSWORD="p@ssw0rd" \
-e MYSQL_DATABASE="learning" \
-e MYSQL_USER="learner" \
-e MYSQL_PASSWORD="l3@rn3r" \
-v "$PWD/config/mysql":/var/lib/mysql:Z \
--name=learning-db mariadb
```

### Create an HTTPD Container

Just like with MySQL, use podman run to create an Apache container that has PHP already built in[^4].

```bash
podman run \
-d --restart=always \
--pod=pod-php-dev \
-v "$PWD":/var/www/html:Z \
-v "$PWD/config/httpd/httpd.conf":/usr/local/apache2/conf/httpd.conf:Z \
--name=learning-httpd php:apache-buster
```

### Test the Pod

After the containers have been started, view the logs with this command:

```bash
podman pod logs pod-php-dev 
```

You can also attach an interactive terminal to a container with this command[^2]:

```bash
podman exec -i -t learning-httpd /bin/bash
```
If everything looks good and you can access the web service, it's time to generate a config file to easily reproduce our ```DEV``` environment.

#### Diagnosing Permission Denied Errors

> _Podman uses many security mechanisms for isolating containers from the host system and other containers. These security mechanisms can cause a permission-denied error, and sadly only the kernel knows which one is blocking access to the container process.[^3]_

If you run into issues with ```httpd``` being able to read the local files, checkout the [writeup by Dan Walsh (Red Hat)](https://www.redhat.com/sysadmin/container-permission-denied-errors). They walk through some issues that you might see and explains how to resolve them.

### MySQL Web Client

If you would like to use a web client for MySQL you can use either ```phpMyAdmin```[^7] or ```Adminer```[^6]. We'll use Adminer since it's very easy to use.

```bash
podman run \
-d --restart=always \
--pod=pod-php-dev \
-e ADMINER_DEFAULT_SERVER=learning-db \
-e ADMINER_PLUGINS='tables-filter' \
-e ADMINER_DESIGN='pepa-linha' \
--name=learning-mysql-admin adminer
```
**OR** use the following if you prefer to use phpMyAdmin:

```bash
podman run \
-d --restart=always \
--pod=pod-php-dev \
-e APACHE_PORT=8081 \
-e PMA_HOST=learning-db \
-e PMA_USER=learner \
-e PMA_PASSWORD=l3@rn3r \
--name=learning-mysql-admin phpmyadmin
```

## Easily Recreate the Environment

### Generate YAML for the Pod[^1]

We output our pod as a YAML definition by using podman generate kube command:

```bash
podman generate kube pod-php-dev >> pod-php-dev.yaml
```

You may need to clean up the generated file to remove a bunch of the ```env:``` entries that the container images may easily re-propagate, and in fact could cause conflicts if it's built again from scratch.

### Start the Pod from the YAML

First, make sure that the test pod and its containers are not running with the following commands:

```bash
podman pod ls

podman ps
```

Next, use podman play kube to start your pod from the defined YAML:

```bash
podman play kube ./pod-php-dev.yaml
```

Once everything is done, you will be able to hit up port 8080. Unless you have an index.[html,php] file in you project directory, you'll get a 403 error page. Now, you can use this DEV environment for anything you need.

[Footnotes]:

[^1]: [Red Hat - Sysadmin Compose Podman Pods](https://www.redhat.com/sysadmin/compose-podman-pods)
[^2]: [Access Apache logs in Docker](https://serverfault.com/questions/763882/apache-in-docker-how-do-i-access-log)
[^3]: [Red Hat - Container Permission Denied Errors](https://www.redhat.com/sysadmin/container-permission-denied-errors#:~:text=The%20classic%20SELinux%20issue%20is%20the%20process%20is,you%20run%20the%20container%20with%20--privileged,%20it%20works:)
[^4]: [Official PHP Docker Image](https://hub.docker.com/_/php)
[^5]: [Official MariaDB Docker Image](https://hub.docker.com/_/mariadb)
[^6]: [Official Adminer Docker Image](https://hub.docker.com/_/mariadb)
[^7]: [Official phpMyAdmin Docker Image](https://hub.docker.com/_/phpmyadmin)
