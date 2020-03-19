#!/bin/bash

if [ $# -eq 0 ]
  then
      echo "No arguments supplied"
      exit
fi

echo "replacement term: $1"
sed "s/myLibTemplate/${1}/g" myLibTemplate.java > $1.java

echo "file $1.java has been created"
