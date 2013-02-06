![logo](http://update.orbotix.com/developer/sphero-small.png)

# KeyDrive

This sample demonstrates how to use keyboard input to drive and calibrate Sphero.  If you are planning on making an app that accepts keyboard input to control the robot, this is a good place to start.

## Capturing Keyboard Input

To capture keyboard events, you must override the keyDown function in a Window.  Once you add this code to your WindowController, you can filter key presses to perform Sphero commands.   

	- (void)keyDown:(NSEvent *)theEvent {
    	NSString *keyPressed = [theEvent charactersIgnoringModifiers];
    	unichar keyChar = [keyPressed characterAtIndex:0];
      }
      
To make Sphero drive, we send a Roll Command when an arrow is pressed:

	// if pressed any arrow
    if(keyChar == NSUpArrowFunctionKey) {
        if( !isCalibrating ) [RKRollCommand sendCommandWithHeading:0.0 velocity:0.6];
    }
    
## Calibration

    
The isCalibrating boolean variable is toggled on and off when the Shift Key is pressed down and up.  When the Shift Key is pressed down, we send a Calibrate Command to Sphero, to make it current heading a value of 0 degrees, and then wait for arrow key presses.  If the user pressed the left arrow key, the application sends a roll command with a periodically decreasing heading so that it rotates counter-clockwise.  If the user pressed the right arrow key, the application send a roll command with a periodically increasing heading so that it rotates clockwise.  When the user lets up on the Shift Key, the application sends another Calibrate Command setting the current heading to 0 degrees.  The Shift Key logic code is below:

	- (void)flagsChanged:(NSEvent *)theEvent
	{
    	// Modifier keyboard events are keys like shift
    	// They can be processed while other keys like arrow keys are clicked too
    	if(([theEvent modifierFlags] & NSShiftKeyMask) == NSShiftKeyMask)
    	{
        	isCalibrating = YES;
        	keyMask |= NSShiftKeyMask;
        	// Turn on tail light
        	[RKBackLEDOutputCommand sendCommandWithBrightness:1.0f];
    	}
    	else if([self isMask:[theEvent modifierFlags] upEventForModifierMask:NSShiftKeyMask])
    	{
        	isCalibrating = NO;
        	keyMask ^= NSShiftKeyMask;
        	// Turn off tail light and send calibrate command at 0 heading
        	[RKBackLEDOutputCommand sendCommandWithBrightness:0.0f];
        	[RKCalibrateCommand sendCommandWithHeading:0.0f];
    	}
	}
	
The flagsChanged function is another override from the Window object that notifies when keys like Shift, Command, and Options are pressed, since they can be combined with other keys.  When we are calibrating, this selector is performed every 200 ms.	

	-(void)calibrateEvent {
    	if( noArrowsPressed || !isCalibrating ) return;
    	int newAngle = [RKRollCommand currentHeading];
    	// rotate counter-clockwise
    	if( calibrateDirection ) {
        	newAngle -= 5;
        	if( newAngle < 0 ) newAngle = 359;
    	}
    	// rotate clockwise
    	else {
        	newAngle += 5;
        	if( newAngle >359 ) newAngle = 0;
    	}
    	[RKRollCommand sendCommandWithHeading:newAngle velocity:0.0f stopped:YES];
    	[self performSelector:@selector(calibrateEvent) withObject:nil afterDelay:0.2];
	}

## Questions

For questions, please visit our developer's forum at [http://forum.gosphero.com/](http://forum.gosphero.com/)





