#!/bin/bash

CURDIR=`pwd`
SCRDIR=`dirname "$0"`
cd $SCRDIR
SCRDIR=`pwd`
cd $CURDIR

TEMP=`getopt -n opt_test -o c:d:p:h -l class-name:,destination:,package-name:,help -- "$@"`
eval set -- "$TEMP"

help=$(cat <<-END
USAGE: opts_test <-c|--classname> <-d|--destination>
    -c: the classname of the target file (mandatory)
    -d: the destination of the target file (optional: default is pwd)
    -p: package name of the files (optional: default is no package names)
    -h: display this help dialog
END
)


while true ; do
    case "$1" in
	-c|--class-name)
	    CNSET=1
	    #need to assert not empty
	    if [ -z "$2" ]
	    then
	       echo "classname argument supplied, but no classname has been given"
	       echo "$help"
	       exit 1
	    fi
	    classname=$2
	    shift 2 ;;
	-d|--destination)
	    DESTSET=1
	    if [ -z "$2" ]
	    then
		echo "destination argument supplied, but no destination has been given"
		echo "$help"
		exit 1
	    fi
	    destination=$2
	    shift 2 ;;
	-h|--help)
	    echo "$help"
	    exit 1 ;;
	-p|--package-name)
	    PACKSET=1
	    if [ -z "$2" ]
	    then
		echo "package name argument supplied, but no package name given"
		echo "$help"
		exit 1
	    fi
	    package=$2
	    shift 2 ;;
	--) shift ; break ;;
	*) echo "Internal Error!" ; exit 1 ;;
    esac
done

#the program cannot run if no classname is given
if ((CNSET != 1))
then
    echo "$help"
    exit 1
fi

if ((DESTSET == 1))
then
    #check an actual argument has been given
    if [ -z "$destination" ]
    then
	echo "destination argument supplied, but no destination has been given"
	echo "$help"
	exit 1
    else
	#we're giving a specific output directory
	#let's get the full qualified name of that directory
	echo "making directory $destination for project $classname..."
	mkdir $destination > /dev/null 2>&1
	cd $destination > /dev/null 2>&1 || { echo "Location $2 does not exist, we cannot create it, or we do not have permission to use it"; exit; }
	touch $classname.java > /dev/null 2>&1 || { echo "Do not have write permissions in location $2"; exit; }
	destination=`pwd`    
    fi
else
    echo "placing output files in current directory"
    destination=`pwd`
fi

#SCRIPDIR=`dirname "$0"`/
cd $SCRDIR
#pwd

#make a temporary directory for our distribution components
mkdir dist

##first replacement: we want to make a file called conceptHelper.java, which is our superclass

#constructing concepthelper file
CONCEPTSTR="ConceptHelper"
#echo "replacement term: $CONCEPTSTR"
sed "s/myLibTemplate/${CONCEPTSTR}/g" myLibTemplate.java > dist/$CONCEPTSTR.java

#echo "file $CONCEPTSTR.java has been created"

#next, we want to construct our child class
#echo "replacement term: $1"
sed "s/myHelperClass/${classname}/g" myHelperClass.java > dist/$classname.javatmp

#replace superclass mentions
sed "s/myLibTemplate/${CONCEPTSTR}/g" dist/$classname.javatmp > dist/$classname.java

if ((PACKSET == 1))
then
    #package
    echo "package $package;" | cat - dist/$classname.java > dist/tmp && mv dist/tmp dist/$classname.java
    echo "package $package;" | cat - dist/$CONCEPTSTR.java > dist/tmp && mv dist/tmp dist/$CONCEPTSTR.java
    echo "package $package;" | cat - DebugLogger.java > $destination/DebugLogger.java
else
    cp DebugLogger.java $destination
fi


mv dist/$classname.java $destination
mv dist/$CONCEPTSTR.java $destination

rm -r dist
