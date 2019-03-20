#!/bin/bash

EXIT_CODE=0

export PATH=$PATH:$(pwd)/bin

echo "------------------------"
echo "Running Shellcheck Tests"
echo "------------------------"

if test/shellcheck.sh ; then
  echo "✅ Shellcheck Tests Passed"
else
  echo "⛔️ Shellcheck Tests Failed"
  EXIT_CODE=1
fi

echo "------------------------"
echo "Running K8S Lint Tests"
echo "------------------------"

if test/k8s-lint.sh ; then
  echo "✅ K8S Lint Tests Passed"
else
  echo "⛔️ K8S Lint Tests Failed"
  EXIT_CODE=1
fi

echo "------------------------"
echo "Running Helm Tests"
echo "------------------------"

if test/helm.sh ; then
  echo "✅ Helm Tests Passed"
else
  echo "⛔️ Helm Tests Failed"
  EXIT_CODE=1
fi

exit $EXIT_CODE
