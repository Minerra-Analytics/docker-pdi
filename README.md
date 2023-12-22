Docker Pentaho Data Integration
===============================

# Introduction

DockerFile for [Pentaho Data Integration](https://sourceforge.net/projects/pentaho/) (a.k.a kettle / PDI)

This image is intendend to allow execution of PDI transformations and jobs through command line and run PDI's UI (`Spoon`).   
PDI server (`Carte`) is also available on this image.

# Docker Build Arguments
```
ARG GIT_USER
ARG GIT_PASS
ARG GIT_ORG
ARG GIT_REPO
```

```
docker build \
  --build-arg "GIT_USER=user" \
  --build-arg "GIT_PASS=password" \
  --build-arg "GIT_ORG=my_org" \
  --build-arg "GIT_REPO=this_repo" \
  -t hermantansg/pdi .
```

This will place the files from the repo into `/jobs` folder in the container.


# Quick start

## Basic Syntax

```
$ docker container run --rm hermantansg/pdi:latest

Usage:	/entrypoint.sh COMMAND

Pentaho Data Integration (PDI)

Options:
  runj filename		Run job file
  runt filename		Run transformation file
  spoon			    Run spoon (GUI)
  help		         Print this help

```

The files in `/jobs` folder must be cloned from a repo before hand.


## Running Transformations


```
$ docker container run --rm -v $(pwd):/jobs hermantansg/pdi runt sample/dummy.ktr
```

## Running Jobs

```
$ docker container run --rm -v $(pwd):/jobs hermantansg/pdi runj  sample/dummy.kjb
```

## Running Spoon (UI)

### Using `docker run`

```
$ docker run -it --rm -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro \
        -v $(pwd):/jobs \
        -e XAUTH=$(xauth list|grep `uname -n` | cut -d ' ' -f5) -e "DISPLAY" \
        --name spoon \
        hermantansg/pdi spoon
```

## Custom `kettle.properties`

In order to use a custom `kettle.properties`, you need to leave the file available in `/jobs/kettle.properties`.

```bash
$ # Custom properties in $(pwd)/kettle.properties
$ docker container run --rm -v $(pwd):/jobs hermantansg/pdi runj  sample/dummy.kjb
```

# Environment variables

This image uses several environment variables in order to control its behavior, and some of them may be required

```
ENV PDI_VERSION=9.2 
ENV PDI_BUILD=9.2.0.0-290 
```

## Database Drivers

* Mariadb 
* Postgres

```
ENV	MARIADB_JDBC_VERSION=2.3.0
ENV POSTGRES_JDBC_VERSION=42.2.5
```


