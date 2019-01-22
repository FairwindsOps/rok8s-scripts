#!/bin/bash

pip install --user .
PIP_EXIT_CODE=$?

pip install semver
latest_release="$(git describe --abbrev=0 --tags)"
latest_release="${latest_release#*v}"
setup_py_version="$(python setup.py --version)"

if ! python -c "import semver, sys; sys.exit(0 if semver.match('${setup_py_version}', '>=${latest_release}') else 1)"; then
  echo "Repo setup.py version is stale: $setup_py_version Latest Git tag release: $latest_release"
  PIP_EXIT_CODE=1
fi

exit $PIP_EXIT_CODE
