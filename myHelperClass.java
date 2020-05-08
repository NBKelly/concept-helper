import java.util.Scanner;

public class myHelperClass extends myLibTemplate {
    public myHelperClass() {
	super();
    }
    
    public static void main(String[] argv) {
	new myHelperClass().process(argv);
    }

    public boolean processArgs(String[] argv) {
	for(int i = 0; i < argv.length; i++) {
	    switch(argv[i]) {
	    case "-se" : IGNORE_UNCLEAN = false; break;
	    case "-d"  : DEBUG = true; IGNORE_UNCLEAN = false;
	    case "-t"  : TIMER = true; break;
	    case "-dt" :
		Scanner tst = null;
		if(i + 1 < argv.length &&
		   (tst = new Scanner(argv[i+1])).hasNextInt()) {
		    DEBUG_TIME_MAGNITUDE = tst.nextInt();
		    i++;
		    break;
		}
		
	    default :
		System.err.
		    println("Usage: -se       = (show exceptions),\n" +
			    "       -d        = debug mode,\n" +
			    "       -t        = timer mode (debug lite),\n" +
			    "       -dt <int> = set timer digits");
		return false;
	    }
	}

	return true;
    }

    public void solveProblem() throws Exception {
	/**
	 *  Timer t = new Timer().start();
	 *  
	 *  while(hasNextInt()) {
	 *      t.split("Started scenario at " + line);
	 *
	 *      //your logic here
	 *  }
	 *  
	 *  t.total("Finished processing of file. 
	 */
    }
}
