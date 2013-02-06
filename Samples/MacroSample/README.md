![logo](http://update.orbotix.com/developer/sphero-small.png)

# Macro Sample

This sample demonstrates how to how to programmatically create macros and run them on Sphero.  For those who do not know, macros are a pre-constructed set of commands for Sphero to do.  This is beneficial, because it eliminates any Bluetooth transmission latency that may occur and it also is a great way to make Sphero travel in circles, shapes, or flash to music (if you know the BPM).
	
## Creating Macros

There are 5 main steps to running a macro on a Sphero.
	
1. To create a macro 

    	RKMacroObject* squareMacro = [[RKMacroObject alloc]init];     

2. Add commands to the object

		[squareMacro addCommand:…];
		
3. Set the Macro transmission mode.  Almost always use Normal, unless your Macro is longer than 254 bytes, in which case, use Chunky

    	squareMacro.mode = RKMacroObjectModeNormal;

4. Lastly, play the macro

    	[squareMacro playMacro];  
    	
## Macro Examples  

* Square
	* Drive in a square by rolling, stopping, and turning 90 degrees four times	  
* Shapes 
 	* Drive in a shape with number of sides equal to the loop value
 	
* Vibrate
	* Run the raw motors back and forth very quickly to simulate a vibrate feeling 	
* Spin  
	* The tail light of Sphero turns on and the ball spins in place
	 
* Flip
	* The raw motors take over and if you are holding the ball, it will flip over itself inside its shell
	 
* Figure 8
	* The ball drives in a classic figure 8 shape
	
* Fade	
	* Fade in between colors in a visually appealing macro 

## Sliders

The example has three sliders: speed, loops, and delay.  The speed is generally how fast the ball will roll, or how fast it spins.  Loops, is the number of times you want the macro to repeat.  Delay, is the amount of time that a macro will run, for example, the length of vibration, or the length of time the ball will drive on each side of a shape.


## Return Sphero to Default State

When you want to end a macro, or play another macro, use the abort command and then set sphere in the default state.

		-(void) returnSpheroToStableState {
    		[RKAbortMacroCommand sendCommand];
    		[RKStabilizationCommand sendCommandWithState:RKStabilizationStateOn];
    		[RKBackLEDOutputCommand sendCommandWithBrightness:0.0f];
    		[RKRollCommand sendStop];
		}


## Questions

For questions, please visit our developer's forum at [http://forum.gosphero.com/](http://forum.gosphero.com/)

