#!/bin/sh

# go to the gh-pages branch
git checkout gh-pages

# bring gh-pages up to date with master
git rebase master

# commit the changes
git push origin gh-pages

# go back to the master branch
git checkout master
