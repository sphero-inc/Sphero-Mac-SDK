![iosdeveloperheader.jpg](https://github.com/orbotix/Sphero-iOS-SDK/raw/master/assets/image00.jpg)
# Mac Developer Quick Start Guide

## Resources

### Class Documentation

---

 * [RobotKit Class Documentation](http://docs.gosphero.com/ios/robot_kit/hierarchy.html)

---

### Community and Help

* [Developer Forum](http://forum.gosphero.com/) - Share your project, get help and talk to the Sphero developers!

## Overview
 
This Guide walks you through the basics of creating Mac apps that leverage the Orbotix Sphero SDK. The examples in this guide were built using Objective-C and have been tested with the current released OSX and current version of Xcode. The goal of this developer guide along with sample code is to give the developer a taste of the wide variety of things Sphero can do, respond to, and keep track of.

The Mac SDK is a direct port from the iOS SDK.  Therefore, we tried to keep the syntax identical to it's iOS counterpart.   

*In general this guide will walk you through:*

 - Using our SDK Samples
 - Integrating into an existing project
 - Changing Sphero's Color
 - Using the Roll Command to move Sphero 
 
### Samples

---

The first step to using our SDK is to run the samples we have included.  It is the easiest way to get started.  Simply open the .xcodeproject file of any of our samples and run in Xcode to see a few examples of what Sphero can do.  Currently, we have these samples:

* [HelloWorld](https://github.com/orbotix/Sphero-Mac-SDK/tree/master/samples/HelloWorld) - Connect to Sphero and blink the LED.  This is the most compact and easy to follow sample for dealing with Sphero.  

* [SensorStreaming](https://github.com/orbotix/Sphero-Mac-SDK/tree/master/samples/SensorStreaming) - If you want to use the sensor data from Sphero, you should check this sample out.  Just simply register as an observer to the data, Pay attention to starting and stoping streaming during the application life cycle.

* [KeyDrive](https://github.com/orbotix/Sphero-Mac-SDK/tree/master/samples/KeyDrive) - This sample demonstartes how to use keyboard input to drive Sphero.  It also demonstrates how to calibrate Sphero.

* [MouseController](https://github.com/orbotix/Sphero-Mac-SDK/tree/master/samples/MouseController) - This sample show how you can make sense of the data streaming from Sphero to control behavior, like your computer mouse.  It allows you to move the mouse with IMU values of roll and pitch, and left click and right click with the yaw angle.
* [MacroSample](https://github.com/orbotix/Sphero-Mac-SDK/tree/master/samples/MacroSample) - This sample shows you how to build macros programatically and send them to Sphero.  



### Integrating into an existing project

	Notice: The Sphero Mac SDK should work for OSX 10.6+
	
There are always those cases where you already developed an awesome game or app and want to integrate Sphero functionality or controllability into the project. For those cases we have made it possible to integrate our libraries into your existing project, including some nifty pre-built user interface tools. 

 - Download the current [Sphero Mac SDK](https://github.com/orbotix/Sphero-iOS-SDK/zipball/master).
 
 ---

## Build Phases 

 ---

### Copy Files

You need to add the build phase "Copy Files" to your Xcode project, if it is not already there.  Once you add it, you must move it above "Link Binaries With Libraries" build phase.  This is so the dynamic library RobotKit.framework gets copied into the executable directory of our project before the app tries to find it at runtime.  Without this build phase you will get the runtime error "dyld: Library not loaded: RobotKit.framework… Reason: image not found".   

### Link Binary With Libraries

To integrate the Sphero SDK into your project, you must add the RobotKit.Framework from the framework directory of the SDK into "Link Binary With Libraries" and make sure this Build Phase is below "Copy Files" build phase.

Build Phases tab of your project should now look like this:

![sendingIn.png](https://github.com/orbotix/Sphero-Mac-SDK/raw/master/assets/build_phases.png)

### Code to Connect to Sphero

 The HelloSphero example has all the necessary code needed to create and maintain a connection to Sphero, and can be used as a guide in best practices.  In general you will need to:

 - You should define two methods in your `.h`, One to Setup the connection to Sphero and one to maintain the connection.

        BOOL robotOnline;
        -(void)setupRobotConnection;
        -(void)handleRobotOnline;

 - Make sure to import RobotKit.h

        #import <RobotKit/RobotKit.h>

 - Create a method to handle setting up the Connection to Sphero

        -(void)setupRobotConnection {
            /*Try to connect to the robot*/
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
            if ([[RKRobotProvider sharedRobotProvider] isRobotUnderControl]) {
                [[RKRobotProvider sharedRobotProvider] openRobotConnection];        
            }
        }

 - Create a method to handle maintaining the Connection to Sphero

        - (void)handleRobotOnline {
            /*The robot is now online, we can begin sending commands*/
            if(!robotOnline) {
                /* Send commands to Sphero Here: */

            }
            robotOnline = YES;
        }

 - Overload the `applicationDidFinishLaunching:(NSNotification *)aNotification` method and initialize the connection to Sphero in the AppDelegate.m file

    
		- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
		{
    		[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(appWillTerminate:)
												 name:NSApplicationWillTerminateNotification
											   object:nil];
    
	    	robotOnline = NO;
    
	   	 	// Insert code here to initialize your application
		    [self setupRobotConnection];
		}

  - Do not forget to Disconnect from the Robot when the app closes, otherwise next time you start a connection it will already be in use.

		- (void)appWillTerminate:(NSNotification *)notification {
    
  		 	 if( !robotOnline ) return;
    
   		  	/* When the application is entering the background we need to close the connection to the 			robot*/
    		[[NSNotificationCenter defaultCenter] removeObserver:self name:RKDeviceConnectionOnlineNotification object:nil];
   		 	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationWillTerminateNotification object:nil];
    
    		// Close the connection
    		[[RKRobotProvider sharedRobotProvider] closeRobotConnection];
    
    		robotOnline = NO;
		}

 - You are now ready to start controlling and receiving information from your Sphero, simply add the following to change the LED Color of Sphero to red:

     	[RKRGBLEDOutputCommand sendCommandWithRed:1.0 green:0.0 blue:0.0];

---

## Using the Sphero Mac SDK

---
This command is described in section 3 in more detail but it is a good exercise at this point to change these values and try it out, play around a little bit.

**For example**, try changing the following command in `AppDelegate.m` from

    [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green :0.0 blue :1.0];

to

    [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green :1.0 blue :0.0];

Notice the change from green of 0.0 to a green of 1.0. Run it and you should have a Green Sphero!  

### Sending Roll Commands

 - Using Roll Commands to **Move** Sphero.

 - Using Roll Commands to **Stop** Sphero.

So, you got the LED to blink… thats Awesome! But let's also take advantage of the amazing technology inside Sphero and drive the ball around a little bit. 
	
In order to move Sphero you will need to send a RollCommand. The RollCommand takes two parameters.

   1. Heading in degrees from 0° to 360° 
   2.  Speed from 0.0 to 1.0. 

For example, a heading of 90° at a speed of 0.5 will tell Sphero to turn clockwise 90° at half speed (1.0 is full speed). Once this command is issued Sphero will continue at this heading and speed until it hits something or runs out of range, so you will need to stop the ball using the RollCommand and `sendStop()`.


Now, it's time to modify the code. Let's send Sphero forward for 2 seconds. Next we will create 2 new methods, one to Move Sphero, and Delay. And another to Stop Sphero.

			- (void)stop {
		    	[RKRollCommand sendStop];
			}
			
			- (void)driveforward {
				[RKRollCommand sendCommandWithHeading:0.0 velocity:0.5];			
				[self performSelector:@selector(stop) withDelay:2.0];
			}


Next add the following code in place of the RGB command that was sent before.


		    [self driveforward];


**Run the application on an Mac, if all went well Sphero should have moved forward just a little.**

---

## Where is Sphero going?

---

If you have successfully completed the quick start guide then Sphero should have moved after running the modified code.  What is interesting to note here is that Sphero just went in a *random* direction.  The direction was not random at all, Sphero believe it or not has a *front* and a *back*.  It is necessary for the application to determine what direction forward is for the user from the point of view of the ball.  We call this step `Calibration` and it is **required** to properly drive Sphero in a predictable direction.  To learn more about calibration and using the `BackLED` to set Sphero's orientation please check out the `KeyDrive` Sample project.
		    
		


		




























