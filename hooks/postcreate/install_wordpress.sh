#!/bin/bash

REPOSITORY_NAME=$1

cd $REPOSITORY_NAME
wget https://wordpress.org/latest.tar.gz
tar xzf latest.tar.gz
unlink latest.tar.gz
git add -A
git commit -m "added latest wordpress"
git push -u origin master
