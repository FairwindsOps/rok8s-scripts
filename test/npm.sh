#!/bin/bash

cd $(mktemp -d)
npm install git://github.com/reactiveops/rok8s-scripts.git#${CIRCLE_SHA1}