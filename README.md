# concept-helper
A simple Java script set to ease the difficulty and repetition of constructing proof of concept models. 

Picture this concept: You have a dozen small projects you want to work on. All of these projects require some form of logging, time-based metrics, and input handling. Normally, these small details would actually be a significant amount of time spent between the actual 'meat' of each project. This is why concept-helper exists.

This is a tool designed to eliminate the repetitive/tedious aspects of mass projecting, and allow you to properly engage in the work you set out to do.

This is primarily for my own use. It's a little script I've slowly compiled and modified while I practice programming contest problems. For an example of a project where it has been used, see https://github.com/NBKelly/QuickLinks. (note: rather old version)

### Features
* Handles all input from the inputstream (primarily meant for programming contest problems)
* Handles this input is ints, lines, and bigints
* Error output can be enabled/disabled at runtime
* Exceptions can be disabled/enabled at runtime
* Timer output can be enabled/disabled at runtime
* Information can be displayed on output consumed/not consumed
* Some simple arithmetic operations have been implemented (GCD (including collections), LCM (including collections))
* Support for simple timesplits without any extra coding required

### Usage
The recommended usage is through easy.sh
It takes these arguments:

* -y --yes: you understand what this script does
* -c --class-name: the name of the class to generate
* -l --location: the location to generate classes in. Also specifies the classpath (relative to CWD - this is not infallible - beware).
* -a --auxiliary-location: location of the shared classes (same warning as above)
* h --help: display help

defaults:
* location:  src/
* auxiliary: [location]

Example use case:
```
cd myProject
~/projects/concept-helper -y -c MyCoolProject -l com/nbkelly/cool -a com/nbkelly/helper
...
javac com/nbkelly/cool/MyCoolProject.java
echo "" | java com.nbkelly.cool.MyCoolProject
```

If you're using this script to create classes/classnames not relative to the current directory, then you should probably be using rename.sh instead.

There is a file called rename.sh. It takes these arguments:

```text
    -c classname: the classname of the target file
    -d destination: the destination of the target file
    -p package-name: the package name of the project you want to work on
    -s aux-class: the package name used for the auxiliary files (those that can be shared between projects)
    -t aux-dir: target directory for the auxiliary files
    -h help: display help
```

* The classname value is mandatory, and all other variables are optional.
* The default destination is the current working directory.
* There is no default package name.
* the aux-class defaults to the package name, 
* aux-dir defaults to the destination.

All documentation required to use the generated script should be in the <classname>.java file.

### Things to take note of

* Input, output and debug commands are annotated at the top of the file
* The logger uses all of these same functions, so if you have any other classes, pass it to them to preserve debug/etc output
* If you need to do a lot of construction for your debug output, consider fencing that in an `if(DEBUG) {}` block to using cycles when not in debug mode
* Alternatively, just use the DEBUGF command
* The base commands are `-se` (show exceptions), `-d` (debug), `-t` (timer), and `-dt <int>` (timer digits, int: significant digits)
