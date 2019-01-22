#!/bin/bash

cd examples/production-ready
k8s-lint -f staging.config
k8s-lint -f production.config
