# concept-helper
A simple java script set meant to ease the difficulty and repetitive aspects of making proof of concept models. 

This is primarily for my own use. It's a little script I've slowly compiled and modified while I practice programming contest problems. For an example of a project where it has been used, see https://github.com/NBKelly/QuickLinks.

### Features
* Handles all input from the inputstream (primarily meant for programming contest problems)
* Handles this input is ints, lines, and bigints
* error output can be enabled/disabled at runtime
* exceptions can be disabled/enabled at runtime
* timer output can be enabled/disabled at runtime
* information can be displayed on output consumed/not consumed
* Some simple arithmetic operations have been inmplemnted (GCD (including collections), LCM (including collections))
* support for simple timesplits without any extra coding required

### Usage
There is a file called rename.sh. It takes as input one argument, which is a classname. If I wanted to make 'QuickLinks.java', I would call `rename.sh QuickLinks`.

This will produce a copy of the myLibTemplate file where all instances of the classname are replaced by the word QuickLinks.

To actually use the script, start on line `59`. The body of your program goes in here. Consider it a replacement main script.

### Things to take note of

* input, output and debug commands are annotated at the top of the file
* The logger uses all of these same functions, so if you have any other classes, pass it to them to preserve debug/etc output
* if you need to do a lot of construction for your debug output, consider fencing that in an `if(DEBUG) {}` block to using cycles when not in debug mode
* alternatively, just use the DEBUGF command
* The base commands are `-se` (show exceptions), `-d` (debug), `-t` (timer), and `-dt <int>` (timer digits, int: significant digits)
