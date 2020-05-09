# concept-helper
A simple Java script set to ease the difficulty and repetition of creating proof of concept models. 

This is primarily for my own use. It's a little script I've slowly compiled and modified while I practice programming contest problems. For an example of a project where it has been used, see https://github.com/NBKelly/QuickLinks.

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
There is a file called rename.sh.

```text
It takes as input three values:
    -c classname
    -d destination
    -p package-name
```

The classname value is mandatory, and the destination/package-name values are optional. Files will be produced in the destination (or the pwd, if no destination is supplied), with the classname being used for the production file, and the package name being used in each file if supplied.

All documentation required to use the script should be in the <classname>.java file.

### Things to take note of

* Input, output and debug commands are annotated at the top of the file
* The logger uses all of these same functions, so if you have any other classes, pass it to them to preserve debug/etc output
* If you need to do a lot of construction for your debug output, consider fencing that in an `if(DEBUG) {}` block to using cycles when not in debug mode
* Alternatively, just use the DEBUGF command
* The base commands are `-se` (show exceptions), `-d` (debug), `-t` (timer), and `-dt <int>` (timer digits, int: significant digits)
