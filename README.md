## Preloaded Elasticsearch Dockerfile

This repository contains a modified **Dockerfile** of [Elasticsearch](http://www.elasticsearch.org/)
based on  [Docker](https://www.docker.com/)'s [automated build](https://registry.hub.docker.com/u/dockerfile/elasticsearch/)
published to the public [Docker Hub Registry](https://registry.hub.docker.com/).  It contains some simple
recipes for preloading data into the Docker image.

### Base Docker Image

* [dockerfile/java:oracle-java8](http://dockerfile.github.io/#/java)

### Installation

1. Install [Docker](https://www.docker.com/).

2. Clone this repository.

3. Select a preloaded data recipe.

4. Build the elasticsearch Docker image with your preloaded data.

5. Load the Docker image into Docker for execution.

### Usage

    ```docker load -i preloaded-elasticsearch.tar.gz
    docker run -d -p 9200:9200 -p 9300:9300 preloaded-elasticsearch
    ```

After few seconds, open `http://<host>:9200` to interact with elasticsearch.

### Discussion

This repository is based on a snapshot of the
[dockerfile/elasticsearch](https://github.com/dockerfile/elasticsearch)
repository.  The parent repository creates a Docker image that offers
persistent and shared data by mounting a data directory located outside the
Docker container. It is not possible to start elasticseatch, load data, and
save a new elasticsearc image with the data preloaded, unless you use an
external data directory.

This repository removes the mountable external data directory from the
elasticsearch docker image build. It provides two recipes for building
an elasticsearch docker image with preloaded data.

#### Drop-in elasticsearch data

If you have an existing elasticsearch data directory tree, you can drop it in
place when building the elasticsearch Docker image.

For esample, you can extract data from a running (but quiescent) elasticsearch
Docker container with:

     ```docker cp ${CONTAINER}/usr/share/elasticsearch/data extracted-data
     ```
where ${CONTAINER} is the ID of the running Docker container as obtained from:

     ```docker ps
     ```

#### Loading elasticsearch data

This is a more complex recipe. You first build a modified elasticsearch Docker
image, without the mountable external data columne and without any prelaoded
data.  You run that image inside a container, and load data into it. You
commit the container to a new docker image, and save and compress the
new image with preloaded data.


### TODOs

1. This repository currently contains a snapshot of the [dockerfile/elasticsearch](https://github.com/dockerfile/elasticsearch) repository. Perhaps it should be linked to the parent repository?

2. Is there a procedure that should be followed for shutting down eleasticsearch in a running Docker container before extracting data from the container or committing the container to a new Docker image?
