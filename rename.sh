#!/bin/bash

if [ $# -eq 0 ]
then
    echo "No arguments supplied"
    exit
fi

SCRIPDIR=`dirname "$0"`/
CURDIR=`pwd`
cd $SCRIPDIR
SCRIPDIR=`pwd`
cd $CURDIR

echo "SCRIPDIR: "$SCRIPDIR

if [ $# -eq 1 ]
then
    #we need to figure out where the script is being run from,
    #so we can deposite the created files there and reference file
    echo "placing output files in current directory"
    OUTDIR=`pwd`
fi

#second argument makes a folder (at the cd), and places the files in there
if [ $# -eq 2 ]
then
    #we're giving a specific output directory
    #let's get the full qualified name of that directory
    echo "making directory $2, and placing output files there..."
    mkdir $2
    cd $2
    OUTDIR=`pwd`
    
fi

cd $SCRIPDIR
pwd
echo "OUTDIR: "$OUTDIR

##first replacement: we want to make a file called conceptHelper.java, which is our superclass

#constructing concepthelper file
CONCEPTSTR="ConceptHelper"
echo "replacement term: $CONCEPTSTR"
sed "s/myLibTemplate/${CONCEPTSTR}/g" myLibTemplate.java > $CONCEPTSTR.java

echo "file $CONCEPTSTR.java has been created"

#next, we want to construct our child class
echo "replacement term: $1"
sed "s/myHelperClass/${1}/g" myHelperClass.java > $1.javatmp

#replace superclass mentions
sed "s/myLibTemplate/${CONCEPTSTR}/g" $1.javatmp > $1.java

rm $1.javatmp
mv $1.java $OUTDIR
mv $CONCEPTSTR.java $OUTDIR
cp DebugLogger.java $OUTDIR
