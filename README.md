# Minimart Cookbook

Install minimart supermarket for chef cookbooks

https://github.com/electric-it/minimart

## Requirements

* Chef 12+
* Centos 7

## How it's working?

Cookbook parse list of tags from repos and generate berks compatible repository

So you should specify tags for your release commits

```
git commit -m "refactoring"

git push

git tag -a v0.3.2 -m "version 0.3.2"

git push --tags
```

Next chef run will download tagged cookbook version

## TODO

A lot of things :)
