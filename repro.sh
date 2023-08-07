#!/usr/bin/env bash

./mvnw clean package -Dquarkus.container-image.group="some-registry.com" -Dquarkus.container-image.tag="latest"