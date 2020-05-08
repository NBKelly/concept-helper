#!/bin/bash

if [ $# -eq 0 ]
  then
      echo "No arguments supplied"
      exit
fi

##first replacement: we want to make a file called conceptHelper.java, which is our superclass

#constructing concepthelper file
CONCEPTSTR="ConceptHelper"
echo "replacement term: $CONCEPTSTR"
sed "s/myLibTemplate/${CONCEPTSTR}/g" myLibTemplate.java > $CONCEPTSTR.java

echo "file $CONCEPTSTR.java has been created"
