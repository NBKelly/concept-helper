#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TARGET="$DIR/rename.sh"
echo $TARGET

#what we expect:
#classname
#location
#aux location

help=$(cat <<-END
USAGE: easy -y -c <classname> -l <location> -a <aux-location>
    -y|--yes|--YES: You understand what this program does (mandatory)
    -c|--class-name <classname>: the classname of the target file (mandatory)
    -l|--location <directory>: the location of the target file (optional: default is src)
    -a|--auxiliary-location <directory>: location of the auxiliary (shared) classes (optional: default location)
    -h|--help: display this help dialog
END
)

TEMP=`getopt -n easy.sh -o c:l:a:hy -l class-name:,location:,aux-location:,help,yes -- "$@"`

if [ $? -ne 0 ]
then
    echo "$help"
    exit 1
fi

eval set -- "$TEMP"



#echo "$help"

while true ; do
    case "$1" in
	-y|--yes|--YES)
	    YESSET=1
	    shift 1 ;;
	-c|--class-name)
	    CNSET=1
	    if [ -z "$2" ]
	    then
		echo "classname argument supplied, but no classname has been given"
		echo "$help"
		exit 1
	    fi
	    classname=$2
	    shift 2 ;;
	-l|--location)
	    LOCSET=1
	    if [ -z "$2" ]
	    then
		echo "location argument supplied, but no location has been given"
		echo "$help"
		exit 1
	    fi
	    location=$2
	    shift 2 ;;
	-a|--aux-location)
	    AUXSET=1
	    #need to assert not empty
	    if [ -z "$2" ]
	    then
		echo "auxilary location specified, but has not been given"
		echo "$help"
		exit 1
	    fi
	    auxdir="$2"
	    shift 2 ;;
	-h|--help)
	    echo "$help"
	    exit ;;
	--)
	    shift ; break ;;	
	*)
	    echo "Invalid option given"
	    echo "$help"
	    exit 1 ;;
    esac
done

if ((YESSET != 1))
then
    echo "$help"
    exit 1
fi

if ((LOCSET != 1))
then
    #echo "$help"
    #exit 1
    location="src"
fi

#check variables
if ((CNSET != 1))
then
    echo "$help"
    exit 1
fi

if ((AUXSET != 1))
then
    auxdir=$location
    #echo "$help"
    #exit 1
fi

PACKAGE=`echo "$location" | tr / .`
PACKAGE=${PACKAGE%.}
AUXPACKAGE=`echo "$auxdir" | tr / .`
AUXPACKAGE=${AUXPACKAGE%.}

#PACKAGE=${PACKAGE%.}

#echo $PACKAGE
#echo $AUXPACKAGE
#$TARGET
$TARGET -c "$classname" -d "$location" -p "$PACKAGE" -s "$AUXPACKAGE" -t "$auxdir"
