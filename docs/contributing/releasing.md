# Releasing New Versions of rok8s-scripts

## Creating the Tag

Create an annotated tag on the commit you would like to release

`HASH` is the commit-ish to tag.
`VERSION` is the version to tag the `HASH` as. This should be of the form of `v[MAJOR].[MINOR].[PATCH]`, with an appended `-TEXT` as needed.

Follow [Semantic Versioning](http://semver.org).

```
git checkout $HASH
git tag -a $VERSION
```

Create a message with a 1-line subject, a blank line, then a 1+ line description.

The `SUBJECT` will be used as the name of the release. The description will be the description of the release.

It is encouraged (but not required) to include changes for this release in the description along with any helpful release notes.

```
SUBJECT

DESCRIPTION
```

Your tag commit message may look like

```
v0.0.0 Awesome Release Name

Breaking Changes:

* No longer defends against non-awesome debuffs

New Features:

* Add new --awesome flag to enable extra awesomeness!

Bug Fixes:

* Fix infinite loop in weird use case
```

Push your tag with

```
git push $REMOTE $VERSION
```

A Github Release will be created by CircleCI and an NPM package will be pushed to NPMjs.
