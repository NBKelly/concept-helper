#!/bin/bash

CURDIR=`pwd`
SCRDIR=`dirname "$0"`
cd $SCRDIR
SCRDIR=`pwd`
cd $CURDIR

help=$(cat <<-END
USAGE: opts_test <-c|--classname> <-d|--destination>
    -c|--class-name: the classname of the target file (mandatory)
    -d|--destination: the destination of the target file (optional: default is pwd)
    -p|--package-name: package name of the files (optional: default is no package names)
    -s|--aux-class: specify shared classes classpath (optional: requires t)
    -t|--aux-dir: specify shared classes location  (optional: requires s)
    -n|--no-overwrite: do not overwrite auxiliary classes (still make them if they don't exist)
    -h|--help: display this help dialog
END
)

TEMP=`getopt -q -n opt_test -o c:d:p:hs:t:n -l class-name:,destination:,package-name:,help,aux-class:,aux-dir:,no-overwrite -- "$@"`

if [ $? -ne 0 ]
then
    echo "$help"
    exit 1
fi

eval set -- "$TEMP"

#TODO:
# shared-classpath
# shared-location
#
# ie: ./rename -c MyClass -d nbkelly/stuff/ -p nbkelly.stuff -s nbkelly.shared -t nbkelly/shared
#

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
	-s|--aux-class)
	    ACSET=1
	    #need to assert not empty
	    if [ -z "$2" ]
	    then
		echo "auxilary class path specified, but not classname has been given"
		echo "$help"
		exit 1
	    fi
	    auxclass=$2
	    shift 2 ;;
	-t|--aux-dir)
	    APSET=1
	    #need to assert not empty
	    if [ -z "$2" ]
	    then
		echo "auxilary class directory specified, but not classname has been given"
		echo "$help"
		exit 1
	    fi
	    auxdir="$2"
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
	-n|--no-overwrite)
	    NO_OVERWRITE=1
	    shift 1 ;;
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
	--)
	    shift ; break ;;
	*) echo "Internal Error!" ; exit 1 ;;
    esac
done

if((ACSET == 1))
then
    if((APSET != 1))
    then
	echo "$help"
    fi
fi

if((APSET == 1))
then
    if((ACSET != 1))
    then
	echo "$help"
    fi
fi

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
	WHERE=`pwd`
	mkdir -p $destination > /dev/null 2>&1
	cd $destination > /dev/null 2>&1 || { echo "Location $2 does not exist, we cannot create it, or we do not have permission to use it"; exit 1; }
	touch $classname.java > /dev/null 2>&1 || { echo "Do not have write permissions in location $2"; exit 1; }
	destination=`pwd`
	cd $WHERE
    fi
else
    echo "placing output files in current directory"
    destination=`pwd`
fi

if ((APSET == 1))
then
    if [ -z "$auxdir" ]
    then
	echo "auxiliary directory argument supplied, but no destination has been given"
	echo "$help"
	exit 1
    else
	#we're giving a specific output directory
	#let's get the full qualified name of that directory
	echo "making directory $auxdir for auxiliary classes..."
	WHERE=`pwd`
	mkdir -p "$auxdir" > /dev/null 2>&1
	cd "$auxdir" > /dev/null 2>&1 || { echo "Location $2 does not exist, we cannot create it, or we do not have permission to use it"; exit 1; }
	touch "DebugLogger.java" > /dev/null 2>&1 || { echo "Do not have write permissions in location $2"; exit 1; }
	auxdir=`pwd`
	cd $WHERE
    fi
fi



#SCRIPDIR=`dirname "$0"`/
cd $SCRDIR
#pwd

#make a temporary directory for our distribution components
mkdir dist

##first replacement: we want to make a file called conceptHelper.java, which is our superclass

CONCEPTSTR="ConceptHelper"
#echo "replacement term: $CONCEPTSTR"


sed "s/myLibTemplate/${CONCEPTSTR}/g" myLibTemplate.java > dist/$CONCEPTSTR.java

#next, we want to construct our child class

sed "s/myHelperClass/${classname}/g" myHelperClass.java > dist/$classname.javatmp

#replace superclass mentions
sed "s/myLibTemplate/${CONCEPTSTR}/g" dist/$classname.javatmp > dist/$classname.java

if((ACSET == 1))
then
    if((PACKSET == 1))
    then
	printf "package $package;\nimport $auxclass.DebugLogger;\nimport $auxclass.ConceptHelper;\n" | cat - dist/$classname.java > dist/tmp && mv dist/tmp dist/$classname.java
    else
	printf "import $auxclass;\n" | cat - dist/$classname.java > dist/tmp && mv dist/tmp dist/$classname.java
    fi
    printf "package $auxclass;\n" | cat - dist/$CONCEPTSTR.java > dist/tmp && mv dist/tmp dist/$CONCEPTSTR.java
    printf "package $auxclass;\n" | cat - DebugLogger.java > $auxdir/DebugLogger.java
elif ((PACKSET == 1))
then
    #package
    printf "package $package;\n" | cat - dist/$classname.java > dist/tmp && mv dist/tmp dist/$classname.java
    printf "package $package;\n" | cat - dist/$CONCEPTSTR.java > dist/tmp && mv dist/tmp dist/$CONCEPTSTR.java
    printf "package $package;\n" | cat - DebugLogger.java > $destination/DebugLogger.java
else
    printf "//no package specified;" | cat - dist/$classname.java > dist/tmp && mv dist/tmp dist/$classname.java
    cp DebugLogger.java $destination
fi

mv dist/$classname.java $destination

if((ACSET == 1))
then
    mv dist/$CONCEPTSTR.java $auxdir
else
    mv dist/$CONCEPTSTR.java $destination
fi
rm -r dist
