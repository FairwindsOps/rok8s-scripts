# How to contribute

Issues, whether bugs, tasks, or feature requests are essential for keeping rok8s-scripts (and ReactiveOps in general) great.
We believe it should be as easy as possible to contribute changes that
get things working in your environment. There are a few guidelines that we
need contributors to follow so that we can have a chance of keeping on
top of things.

## Getting Started

* Submit an issue, assuming one does not already exist.
  * Clearly describe the issue including steps to reproduce when it is a bug.
  * Apply the appropriate labels, whether it is bug, feature, or task.

## Making Changes

* Create a feature branch from where you want to base your work.
  * This is usually the master branch.
  * To quickly create a topic branch based on master; `git checkout -b
    feature master`. Please avoid working directly on the
    `master` branch.
* Try to make commits of logical units.
* Make sure you have added the necessary tests for your changes if applicable.
* Make sure you have added any required documentation changes.

## Making Trivial Changes

### Documentation

For changes of a trivial nature to comments and documentation, it is not
always necessary to create a new issue in GitHub. In these cases, a branch with pull request is sufficient.

## Submitting Changes

* Push your changes to a topic branch.
* Submit a pull request.
* Mention the issue in your PR description. I.E. `Fixes #42`.  This will ensure that your issue gets tagged with the PR.

## Orb development

There is a Makefile that can assist in validating and testing the orb locally.  See the commands there for more info.

Attribution
===========
Portions of this text are copied from the [Puppet Contributing](https://github.com/puppetlabs/puppet/blob/master/CONTRIBUTING.md) documentation.
