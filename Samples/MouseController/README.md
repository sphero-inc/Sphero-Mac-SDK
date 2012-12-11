![logo](http://update.orbotix.com/developer/sphero-small.png)

# Mouse Controller

This sample demonstartes how to use data streaming values of roll, pitch, and yaw to control the mouse of your computer.  Not only is this a neat little trick that could be greatly improved, it shows how to control on screen objects using Sphero.

## Understand Roll, Pitch, and Yaw

![android.jpg](https://github.com/orbotix/Sphero-Android-SDK/raw/master/assets/IMU.png)
    
If we are in an airplane, heading is where we are pointing (north,south,east,west), roll is how much the airplane is banking, and pitch is how the nose of the plane is pointing to gain or lose altitude.  

Using this representation of orientation, we can make Sphero into a controller quite easily.  In this example, we use pitch and roll to move the the mouse pointer left, right, down, and up, and we use yaw to control left and right mouse clicks.

## Moving the Mouse Pointer

The idea behind my algorithm was to have a safe zone where the mouse will not move and you can safely left or right click.  I made that threshold 20 degrees, however I encourage the developer to play around with these values I will explain.  The code to move the mouse left and right is below:

    // Move horizontally
    if( ABS(roll) > 20 ) {
        // Quadratic equation to control speed of mouse movement
        int addition = (0.005*roll*roll);
        if( roll < 0 ) addition = -addition;
        int newMouseX = mousePositionX + addition;
        // Keep mouse position within the bounds of the screen
        if( newMouseX < 0 ) newMouseX = 0;
        if( newMouseX > screenWidth ) newMouseX = screenWidth;
        mousePositionX = newMouseX;
        mousePositionChanged = YES;
    }
    
This computes a new mouse x-position by using an exponentially increasing speed algorithm limited by a screen boundary size. The mouse is moved up and down with the pitch value below:

    // Move horizontally
    if( ABS(pitch) > 20 ) {
        // Quadratic equation to control speed of mouse movement
        int addition = (0.005*pitch*pitch);
        if( pitch < 0 ) addition = -addition;
        int newMouseY = mousePositionY + addition;
        // Keep mouse position within the bounds of the screen
        if( newMouseY < 0 ) newMouseY = 0;
        if( newMouseY > screenHeight ) newMouseY = screenHeight;
        mousePositionY = newMouseY;
        mousePositionChanged = YES;
    }
    
Now, to actually move the mouse, we have to post a CGMouseEvent to be interpretted by our computer to move.  The code is below:

    if( mousePositionChanged ) {
        if( !isMouseLeftDown ) {
            // Create move the mouse to a different position event
            CGEventRef move1 = CGEventCreateMouseEvent(
                                                       NULL, kCGEventMouseMoved,
                                                       CGPointMake(mousePositionX, mousePositionY),
                                                       kCGMouseButtonLeft // ignored
                                                       );
            // Post event
            CGEventPost(kCGHIDEventTap, move1);
            CFRelease(move1);
        }
   }
   
It is a good idea to only move the mouse when the position has changed.  That way, you give the user the oppurtunity to click the button to stop using the mouse if they are incapable of figuring out how to use it.

## Performing Mouse Click Events with Yaw

The value I chose for the threshold of a mouse down click is a yaw angle of 45 degrees, or about an 1/8th turn around Sphero.  This is arbitrary and can be adjusted as well. Once you go past the threshold, it is a down click, but once you come back past the threshold it is an up click.  That way, you can even drag windows around on the screen, or even resize them.
    
    // Left Mouse Click
    if( !isMouseRightDown ) {
        // Sphero is level, and rotated clockwise
        if( yaw > 45 && ABS(roll) < 20 && ABS(pitch) < 20  ) {
            if( !isMouseLeftDown ) {
                // Create a mouse event that the their should be a left click down event
                CGEventRef click1_down = CGEventCreateMouseEvent(
                                                                 NULL, kCGEventLeftMouseDown,
                                                                 CGPointMake(mousePositionX, mousePositionY),
                                                                 kCGMouseButtonLeft
                                                                 );
                // Post the mouse event
                CGEventPost(kCGHIDEventTap, click1_down);
                CFRelease(click1_down);
                isMouseLeftDown = YES;
            }
        }
    }
    
This code will post a left click mouse event.

## Future Ideas

Using Sphero to control your control has a wide variety of implications.  We encourage you to explore the power of data streaming in controlling your mac computer.

## Questions

For questions, please visit our developer's forum at [http://forum.gosphero.com/](http://forum.gosphero.com/)





