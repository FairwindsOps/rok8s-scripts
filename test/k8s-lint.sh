#!/bin/bash

cd examples/production-ready || exit 1
k8s-lint -f staging.config
k8s-lint -f production.config
